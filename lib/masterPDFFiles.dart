import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_masterPDF_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:custom_switch/custom_switch.dart';

class MasterPDFFiles extends  StatefulWidget{
  Module module;
  MasterPDFFiles({
   this.module,
});

  @override
  State<StatefulWidget> createState() => _MasterPDFFilesState();
}

class _MasterPDFFilesState extends State<MasterPDFFiles> {
  DataRepo repo;
  User user;
  bool loaded = false;
  List<Widget> asyncWidget = [Text("Loading")];

  Widget _buildItem(int i, String PDFHash, String PDFName, Timestamp lastUpdated,
      String uri, String userPDFName, bool subscribed,
      bool allowSubscription, List<String> quizNames) {
    var size = MediaQuery.of(context).size;
    List<Widget> quizNameWidgets = List();
    if( quizNames != null) {
      quizNameWidgets = quizNames.map((e) => Text(e)).toList();
    }
    return GestureDetector(
      onTap: () async{
        if (await canLaunch(uri)) {
          await launch(uri);
        } else {
          throw 'Could not launch $uri';
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
        margin: EdgeInsets.all(8),
        width: size.width,
        //height: size.height*0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 8,
              color: Color(0xFFD3D3D3).withOpacity(.88),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 16,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                        text: " ${PDFName}",
                      ),
                    ),
                  ),
                  Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: kSmallText,),
                      text: "Subscribe: ",
                    ),
                  ),
                  allowSubscription ?
                  CustomSwitch(
                    activeColor: Colors.pinkAccent,
                    value: subscribed ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        value ? FirebaseMessaging().unsubscribeFromTopic(PDFHash) : FirebaseMessaging().subscribeToTopic(PDFHash);
                        asyncWidget[i] = _buildItem(i, PDFHash, PDFName, lastUpdated, uri, userPDFName, !subscribed, true, quizNames);
                      });
                    },
                  ) :
                    CustomSwitch(
                      value: false,
                      onChanged: null,
                    )
                ],
              ),
              SizedBox(height: 4),
              Row(
                  children: [
                    Text("Last updated on: \n ${lastUpdated == null ? "No info" : DateFormat('dd-MM-yyyy kk:mm').format(lastUpdated.toDate())}"),
                    Spacer(),
                    Text("Your PDF is named:  \n  ${userPDFName ?? "No similar PDF uploaded"}"),
                  ]
              ),
              Divider(height: 4),
              quizNames != null ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("It is linked to :"),
                  Column(
                    children: quizNameWidgets,
                  )
                ])
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("It is not linked to any quizzes"),
                ],
              )
            ]
          ),
        )
      )
    );
  }

  void loadingWidget() async {
    List<DocumentSnapshot> pdfList = await repo.getQuery().then((value) => value.documents);
    List<Widget> widgetList = List();
    for(int i = 0; i < pdfList.length; i++) {
      String PDFHash = pdfList[i].documentID;
      DocumentSnapshot pdfInfo = await Firestore.instance.collection("MasterPDFMods")
          .document(widget.module.moduleCode)
          .collection("PDFs")
          .document(PDFHash)
          .get();
      DocumentSnapshot userInfo = await Firestore.instance.collection("MasterPDFMods")
          .document(widget.module.moduleCode)
          .collection("PDFs")
          .document(pdfList[i].documentID).collection("Users")
          .document(user.id)
          .get();
      String PDFName = pdfInfo.data["PDFName"];
      Timestamp lastUpdated = pdfInfo.data["lastUpdated"];
      String uri = pdfInfo.data["uri"];
      bool subscriptionStatus = userInfo.data["subscribed"];
      List<String> linkedQuizzes = List();
      if(userInfo.data["quizRef"] != null) {
        for(DocumentReference ref in userInfo.data["quizRef"]){
          DocumentSnapshot snap = await ref.get();
          linkedQuizzes = snap.data["name"];
        }
      }

      if (userInfo.data == null) {
        widgetList.add(_buildItem(i,PDFHash, PDFName, lastUpdated, uri, null, false, false, null));
      } else {
        String userFileName = userInfo.data["userFileName"];
        if(linkedQuizzes.length > 0){
          widgetList.add(_buildItem(i,PDFHash, PDFName, lastUpdated, uri, userFileName, subscriptionStatus, true, linkedQuizzes));
        } else {
          widgetList.add(_buildItem(i,PDFHash, PDFName, lastUpdated, uri, userFileName, subscriptionStatus, true, null));
        }
      }
    }

    if(widgetList.length == 0) {
      loaded = true;
      asyncWidget = [Text("No PDFs found")];
    }
    setState(() {
      loaded = true;
      asyncWidget = widgetList;
    });
  }


  @override
  Widget build(BuildContext context) {
    repo = FirebaseMasterPDFService().getRepoByMod(widget.module.moduleCode);
    user = Provider.of<User>(context);
    if(!loaded){
      loadingWidget();
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg1.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline2,
                        children: [
                          TextSpan(text: "\u00B7Master PDFs\u00B7", style: TextStyle(fontSize: kExtraExtraBigText)),
                        ]
                    )
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: "All uploaded PDFs with highlights from all users are compared against one other. This list contains the results of the comparisons. The more the portion of text is highlighted by the users, the darker the shade of the highlight. Try open one to see!", style: TextStyle(fontSize: kSmallText, color: new Color(0xFFA0A0A0),)),
                        ]
                    )
                ),
                Column(
                  children: asyncWidget,
                )
              ],
            ),
          ),
        ]

      )
    );
  }
}