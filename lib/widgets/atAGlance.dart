import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_reminder_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

class AtAGlance extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const AtAGlance({Key key, this.screenHeight, this.screenWidth}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AtAGlanceState();
}

class _AtAGlanceState extends State<AtAGlance> {
  final controller = PageController();
  List<Widget> _pages;
  void initPage(List<DocumentSnapshot> list) {
    if(list.length == 0){
      _pages = <Widget>[
        new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
              padding: EdgeInsets.only(left: 8,top: 8),
              child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "You have 0 task(s) coming up",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kMediumText
                            )
                        )
                      ]
                  )
              )
          ),
        ),
        new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
              padding: EdgeInsets.only(left: 8,top: 8),
              child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Next task",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kMediumText
                            )
                        ),
                        TextSpan(text: "task1"),
                        TextSpan(text: "dateTime"),
                      ]
                  )
              )
          ),
        ),
      ];
    } else {
      DocumentSnapshot snap = list[0];
      print("snap is ${snap.data}");
      _pages = <Widget>[
        new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
              padding: EdgeInsets.only(left: 4,top: 4),
              child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Next quiz:    ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kMediumText
                            )
                        ),
                        TextSpan(
                            text: "${snap.data["quizName"]}\n\n",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kMediumText
                            )
                        ),
                        TextSpan(
                            text: "Reminder set at:  ${DateFormat('dd-MM-yyyy  kk:mm').format(snap.data['date'].toDate())}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kMediumText
                            )
                        ),
                      ]
                  )
              )
          ),
        ),
        new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
              padding: EdgeInsets.only(left: 8,top: 8),
              child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Next task reminder",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kMediumText
                            )
                        ),
                        TextSpan(text: "task1"),
                        TextSpan(text: "dateTime"),
                      ]
                  )
              )
          ),
        ),
      ];
    }

  }



  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen:false);
    final reminderRepo = Provider.of<FirebaseReminderService>(context, listen:false).getRepo();
    return FutureBuilder<QuerySnapshot>(
      future: reminderRepo.getCollectionRef().where("uid", isEqualTo: user.id).getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        List<DocumentSnapshot> list = snapshot.data.documents;
        initPage(list);
        return Stack(
            children: [
              Opacity(
                opacity: 0.6,
                child: Container(
                  margin: EdgeInsets.only(left: widget.screenWidth*0.1, top: 16),
                  padding: EdgeInsets.only(left: 10,top: 10),
                  height: widget.screenHeight * 0.20,
                  width: widget.screenWidth * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2.0, color: kPrimaryColor),
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: widget.screenWidth*0.1, top: 16),
                  padding: EdgeInsets.only(left: 10,top: 10),
                  height: widget.screenHeight * 0.20,
                  width: widget.screenWidth * 0.8,
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        physics: new AlwaysScrollableScrollPhysics(),
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          return _pages[index % _pages.length];
                        },
                      ),
                      Positioned(
                          bottom: 4,
                          left: 0.0,
                          right: 0.0,
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: 2,
                              effect: WormEffect(),
                            ),
                          )
                      ),
                    ],
                  )
              ),
            ]
        );


      }
    );

  }
}