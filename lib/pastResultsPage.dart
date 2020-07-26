import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:intl/intl.dart';
import 'package:async/async.dart' show StreamGroup;
class PastResultsPage extends StatelessWidget{
  DocumentSnapshot quizSnapshot;
  User user;

  PastResultsPage({this.quizSnapshot});

  Future<List<Widget>> leaderBoard() async {
    List<DocumentSnapshot> userDocList = await Firestore.instance.collection("users")
        .getDocuments().then((value) => value.documents);
    List<DocumentSnapshot> list = List();
    for(DocumentSnapshot snap in userDocList) {
      List<DocumentSnapshot> sublist = await snap.reference.collection("QuizAttempts")
          .where("quiz", isEqualTo: quizSnapshot.reference).getDocuments()
          .then((value) => value.documents);
      list.addAll(sublist);
    }
    list.sort((a,b){
      if( a.data["date"].toDate().isBefore(b.data["date"].toDate())) {
        return -1;
      } else {
        return 1;
      }
    });
    list.sort((a,b){
      return a.data["score"]>b.data["score"]? -1: 1;
    });
    List<Widget> finalList = List();
    for (DocumentSnapshot doc in list){
      String name = await doc.reference.parent().parent().get()
          .then((value) => value.data["name"]);
      Widget wid =  Card(
        child: Row(
          children: <Widget>[
            Text("${name}"),
            Spacer(),
            Text("${DateFormat('dd-MM-yyyy\n  kk:mm').format(doc.data['date'].toDate())}"),
            SizedBox(width:40),
            Text("${doc.data["score"]}"),
            SizedBox(width: 16,)
          ],
        ),
      );
      finalList.add(wid);
    }
    return finalList;
  }

  Widget AttemptItem(DocumentSnapshot snap, int index, bool isLast) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: index % 2 == 0 ? 0.1 : 0.35,
      isFirst: index == 0 ? true : false,
      isLast: isLast,
      indicatorStyle: const IndicatorStyle(
        width: 20,
        height: 20,
        color: Colors.purple,
      ),
      topLineStyle: const LineStyle(
        color: kAccentColor,
        width: 4,
      ),
      rightChild: index % 2 == 0 ?
      Container(
        padding: EdgeInsets.only(left: 20, right: 60),
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "${DateFormat('dd-MM-yyyy\n    kk:mm').format(snap.data['date'].toDate())}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: kSmallText, color: Colors.black),
                      )
                    ]
                )
            ),
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Score: \n",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: kSmallText, color: Colors.black),
                      ),
                      TextSpan(
                        text: "   ${snap.data['score']}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: kMediumText, color: Colors.black),
                      ),
                    ]
                )
            ),
          ],
        ),
      ) : Container(
        padding: EdgeInsets.only(left: 20, right: 60),
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Score: \n",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: kSmallText, color: Colors.black),
                      ),
                      TextSpan(
                        text: "   ${snap.data['score']}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: kMediumText, color: Colors.black),
                      ),
                    ]
                )
            ),
          ],
        ),
      ),
      leftChild: index % 2 == 0 ?
      Container(
      ) : Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${DateFormat('dd-MM-yyyy\n     kk:mm').format(snap.data['date'].toDate())}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: kSmallText, color: Colors.black),
                      )
                    ]
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttemptItem(DocumentReference docRef, int index, bool isLast) {
    return StreamBuilder<DocumentSnapshot> (
      stream: docRef.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return AttemptItem(
          snapshot.data,
          index,
          isLast,
        );
      },
    );
  }

  Widget _resultList() {
    return StreamBuilder<DocumentSnapshot> (
      stream: quizSnapshot.reference.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        bool filterOut(String attemptPath){
          String getFileName(String path) {
            int slash = 7;
            for(int i = 7; i < path.length; i++) {
              if(path.codeUnitAt(i) == 47) {
                slash = i;
                return path.substring(6, slash);
              }
            }
            return null;
          }
          return user.id == getFileName( attemptPath);
        }
        List<dynamic> listOfAttempts = List.from(Quiz.fromSnapshot(snapshot.data)
            .attempts,growable: true);
        DocumentReference ref;
        listOfAttempts.retainWhere((element) => filterOut(element.path));
        List<Widget> colChildren = List();
        if(listOfAttempts == null) {
          return Column(
            children: <Widget>[
              Text("No results found"),
            ],
          );
        }
        for(int i = 0; i < listOfAttempts.length; i++) {
          colChildren.add(buildAttemptItem(listOfAttempts[i], i, i== listOfAttempts.length-1? true : false));
          if( i != listOfAttempts.length-1){
            colChildren.add(
              const TimelineDivider(
                begin: 0.1,
                end: 0.35,
                thickness: 4,
                color: kAccentColor,
              ),
            );
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: colChildren,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
          SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                      text: "Past results",
                    ),
                  ),
                  SizedBox(height: 20),
                  _resultList(),
                  SizedBox(height: 20,),
                  FutureBuilder(
                    future: leaderBoard(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: size.width*0.01),
                            child: Container(
                                width: size.width*0.98,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 2.0, color: Colors.black)),
                                ),
                                child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                        style: Theme.of(context).textTheme.headline5,
                                        children: [
                                          TextSpan(text: "Leaderboard", style: TextStyle(fontWeight: FontWeight.bold, ))
                                        ]
                                    )
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width*0.01),
                            child: Container(
                                width: size.width*0.98,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1.0, color: Colors.black)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text("Name"),
                                    Spacer(),
                                    Text("Attempted on"),
                                    SizedBox(width: 24),
                                    Text("Score"),
                                  ],
                                )
                            ),
                          ),
                          Column(
                            children: snapshot.data,
                          )
                        ],
                      );
                    },
                  )
                ]
            ),
          ),
        ]
      )
    );
  }
}

class _TimelineIndicator extends StatelessWidget{
  const _TimelineIndicator({Key key, this.input}) : super(key: key);
  final String input;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFCB8421),
      ),
      child: Center(
        child: Text(
          input,
          style: TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    ),
    );
  }
}

class _TimelineSteps extends StatelessWidget {
  const _TimelineSteps({Key key, this.steps}) : super(key: key);

  final List<Step> steps;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class Step {
  const Step({
    this.step,
    this.time,
    this.message,
  });

  final int step;
  final String time;
  final String message;
}