import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/dataRepo.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child:
          Material(
              color: Color(0xFF00f0f0),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(quiz.question == null ?//todo need add header
                        "" : "Q1: ${quiz.question} A:${quiz.question}")),
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



  void _handleCreateQuiz(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    QuizDialogWidget dialogWidget = QuizDialogWidget();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Create quiz"),
              content: dialogWidget,
              actions: <Widget>[
                FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
                FlatButton(
                    child: Text("Add"),
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          CreateQuiz quiz = CreateQuiz();
                          return quiz;
                        }),
                      );
                    }
                )
              ]
          );
        }
    );
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
                          child: currentTasks(context),//todo
                        ),
                      ]
                  )
              )
          ),
          RaisedButton(
          child: Text("Create Quiz"),
          onPressed: (){
            _handleCreateQuiz(context);
          },
        ),]
    );
  }
}


class QuizDialogWidget extends StatefulWidget {
  String quizName;

  @override
  _QuizDialogWidgetState createState() => _QuizDialogWidgetState();
}

class _QuizDialogWidgetState extends State<QuizDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a quiz name",
              ),
              onChanged: (val) => widget.quizName = val,
            ),
          ],
        )
    );
  }

}