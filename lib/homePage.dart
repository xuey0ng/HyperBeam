import 'package:HyperBeam/explorePage.dart';
import 'package:HyperBeam/moduleQuery.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/widgets/atAGlance.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/progressChart.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_pushNotification_service.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'objectClasses.dart';
import 'package:async/async.dart' show StreamGroup;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  PageController _controller = PageController(
    initialPage: 0,
  );

  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context);
      await auth.signOut();
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<User>(context, listen: false);
    PushNotificationService(user: user, context: context).initialise();

    Future<String> _loadModulesAsset() async {
      return await rootBundle.loadString('assets/NUS/moduleInfo.json');
    }
    Future loadModule() async {
      String jsonString = await _loadModulesAsset();
      final jsonResponse = json.decode(jsonString);
      NUS_MODULES = new ModulesList.fromJson(jsonResponse);
    }
    if(NUS_MODULES == null)  {
      loadModule();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//hides the app bar above
    var size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context, listen: false);
    final mod = Provider.of<FirebaseModuleService>(context).getRepo();
    Widget quizList() {
      return StreamBuilder<QuerySnapshot> (
          stream: Firestore.instance.collection("Reminders")
              .where("uid", isEqualTo: user.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            List<Widget> colItems = snapshot.data.documents.map((e){
              var timeDisplayed = DateFormat('dd-MM-yyyy  kk:mm').format(e.data['date'].toDate());
              String name = e.data["quizName"];
              return Container(
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 8),
                  margin: EdgeInsets.all(8),
                  width: size.width,
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
                    child: Row(
                        children: [
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kMediumText, fontWeight: FontWeight.bold),
                              text: "$name \n${timeDisplayed}",
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () async {
                              await Firestore.instance.collection("Reminders").document(e.documentID).delete();
                            },
                          ),
                        ]
                    ),
                  )
              );
            }).toList();
            return Container(
              height: size.height*0.4-22,
              child: SingleChildScrollView(
                child: Column(
                  children: colItems,
                ),
              ),
            );
          }
      );
    }
    Widget taskList() {
      return StreamBuilder<QuerySnapshot> (
          stream: Firestore.instance.collection("TaskReminders")
              .where("uid", isEqualTo: user.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            List<Widget> colItems = snapshot.data.documents.map((e){
              var timeDisplayed = DateFormat('dd-MM-yyyy  kk:mm').format(e.data['date'].toDate());
              String name = e.data["taskName"];
              return Container(
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 8),
                  margin: EdgeInsets.all(8),
                  width: size.width,
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
                    child: Row(
                        children: [
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kMediumText, fontWeight: FontWeight.bold),
                              text: "$name \n${timeDisplayed}",
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () async {
                              await Firestore.instance.collection("Reminders").document(e.documentID).delete();
                            },
                          ),
                        ]
                    ),
                  )
              );
            }).toList();
            return Container(
              height: size.height*0.4-118,
              child: SingleChildScrollView(
                child: Column(
                  children: colItems,
                ),
              ),
            );
          }
      );
    }
    return WillPopScope(
      onWillPop: () async {
        //navigatorKey.currentState.maybePop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg2.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            PageView(
                scrollDirection: Axis.vertical,
                controller: _controller,
                children: [
                  Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle),
                                      new Text('${user.name}'),
                                    ]
                                  ),
                                  FlatButton(
                                    child: new Text('Logout'),
                                    onPressed: () => _signOut(context),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.headline5,
                                          children: [
                                            TextSpan(text: "What are you \ndoing "),
                                            TextSpan(text: "today?", style: TextStyle(fontWeight: FontWeight.bold))
                                          ]
                                      )
                                  )
                              ),
                              SizedBox(height: size.height * .02),
                              ProgressChart(),
                              SizedBox(height: size.height * .01),
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              style: Theme.of(context).textTheme.headline5,
                                              children: [
                                                TextSpan(text: "At a "),
                                                TextSpan(text: "glance...", style: TextStyle(fontWeight: FontWeight.bold))
                                              ]
                                          )
                                      )
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          final dialogContext0 = context;
                                          return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:  BorderRadius.circular(20.0)
                                              ),
                                              backgroundColor: kSecondaryColor,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                height: size.height*0.8,
                                                child: Column(
                                                    children: [
                                                      Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: size.width*0.01, top: 8),
                                                        child: Container(
                                                            width: size.width*0.9,
                                                            decoration: BoxDecoration(
                                                              border: Border(bottom: BorderSide(width: 2.0, color: Colors.black)),
                                                            ),
                                                            child: RichText(
                                                                textAlign: TextAlign.left,
                                                                text: TextSpan(
                                                                    style: Theme.of(context).textTheme.headline5,
                                                                    children: [
                                                                      TextSpan(text: "Task reminders", style: TextStyle(fontWeight: FontWeight.bold, ))
                                                                    ]
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                      taskList(),
                                                      Spacer(),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: size.width*0.01, top: 8),
                                                        child: Container(
                                                            width: size.width*0.9,
                                                            decoration: BoxDecoration(
                                                              border: Border(bottom: BorderSide(width: 2.0, color: Colors.black)),
                                                            ),
                                                            child: RichText(
                                                                textAlign: TextAlign.left,
                                                                text: TextSpan(
                                                                    style: Theme.of(context).textTheme.headline5,
                                                                    children: [
                                                                      TextSpan(text: "Quiz reminders", style: TextStyle(fontWeight: FontWeight.bold, ))
                                                                    ]
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                      quizList(),
                                                      Spacer(),
                                                      RaisedButton(
                                                        child: Text("Ok"),
                                                        color: kAccentColor,
                                                        onPressed: () {
                                                          Navigator.pop(dialogContext0);
                                                        },
                                                      ),
                                                      Spacer(),
                                                    ]
                                                ),
                                              )
                                          );
                                        }
                                      );


                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 24),
                                      child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              children: [
                                                TextSpan(text: "View all", style: TextStyle(fontSize: kSmallText, color: Colors.blue)),
                                              ]
                                          )
                                      ),
                                    ),
                                  )
                                ]
                              ),
                              AtAGlance(screenHeight: size.height, screenWidth: size.width),
                              SizedBox(height: size.height * .02),
                            ],
                          )
                      )
                  ),
                  ExplorePage(),
                ]
            ),
          ]
        ),
      ),
    );
  }
}