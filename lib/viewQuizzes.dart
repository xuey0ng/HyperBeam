import 'package:HyperBeam/attemptQuiz.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';

class ViewQuizzes extends StatelessWidget{

  Widget currentTasks(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    return   StreamBuilder<QuerySnapshot>(
        stream: quizRepository.getStream(), //stream<QuerySnapshot>
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshots) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshots.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    final Quiz quiz = Quiz.fromSnapshot(snapshot);
    if (quiz == null) {
      return Container();
    } else {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child:
          Material(
              borderRadius: BorderRadius.circular(8),
              color: quiz.score != null ? Color(0xFF00f0f0) : Color(0xFFf1948a),
              child: InkWell(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(left: 5.0),
                        child: Text(quiz.name),
                        )
                      ),
                      Text("${quiz.score ?? "Not attempted"}"),
                    ],
                  ),
                ),
                onTap: () {
                  Quiz currQuiz = Quiz.fromSnapshot(snapshot);
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("${quiz.name}\n"
                                "score: ${quiz.score?? "Not attempted"}\n"
                                "To be taken by : ${quiz.quizDate.toDate()}"),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text("Delete"),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    quizRepository.delete(snapshot);
                                  }
                              ),
                              FlatButton(
                                  child: Text("Attempt"),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return AttemptQuiz(snapshot: snapshot);
                                        })
                                    );
                                  }
                              )
                            ]
                        );
                      }
                  );
                },
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currentTasks(context),
    );
  }
}

