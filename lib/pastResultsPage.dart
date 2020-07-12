import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
class PastResultsPage extends StatelessWidget{
  DocumentSnapshot quizSnapshot;

  PastResultsPage({this.quizSnapshot});

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
        //indicator: _TimelineIndicator(input: Step.step),
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
                          text: "${DateFormat('dd-MM-yyyy\n     kk:mm').format(snap.data['date'].toDate())}",
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
        List<dynamic> listOfAttempts = Quiz.fromSnapshot(snapshot.data)
            .attempts;
        List<Widget> colChildren = List();
        if(listOfAttempts == null) {
          return Column(
            children: <Widget>[
              Text("Not results found"),
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