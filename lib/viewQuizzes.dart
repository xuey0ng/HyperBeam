import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/auth.dart';


class ViewQuizzes extends StatelessWidget{
  DataRepo quizRepository;

  ViewQuizzes(String id){
    this.quizRepository = DataRepo(id, "Quizzes");
  }

  Widget currentTasks() {
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
    final Quiz quiz = Quiz.fromSnapshot(snapshot);
    if (quiz == null) {
      return Container();
    } else {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child:
          Material(
              color: Color(0xFF00f0f0),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(quiz.question == null ?
                        "" : "Q: ${quiz.question} A:${quiz.question}")),
                  ],
                ),
                onTap: () {
                  Quiz currQuiz = Quiz.fromSnapshot(snapshot);
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Update quiz"),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text("Delete"),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    quizRepository.delete(snapshot);
                                  }
                              ),
                              FlatButton(
                                  child: Text("Update"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: 200,
              color: Color(0xFFE3F2FD),
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              child:
              Expanded(
                  child: Column(
                      children: [
                        Text("Quiz overview"),
                        Expanded(
                          child: currentTasks(),
                        ),
                      ]
                  )
              )
          ),
          RaisedButton(
          child: Text("Create Quiz"),
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context){
                CreateQuiz quiz = CreateQuiz(this.quizRepository);
                return quiz;
              }),
            );
          },
        ),]
    );
  }
}
