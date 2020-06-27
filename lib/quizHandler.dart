import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:HyperBeam/viewQuizzes.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: 300,
              color: Color(0xFFE3F2FD),
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              child: Column(
                      children: [
                        Text("Quiz overview"),
                        ViewQuizzes(),
                      ]
                  )
              ),
          RaisedButton(
            child: Text("Create Quiz"),
            onPressed: () {
              Navigator.pushNamed(context, CreateQuizRoute);
              /*
              Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return CreateQuiz();
                })
              );
               */
            },
          ),]
    );
  }
}

class Quiz implements iDatabaseable {
  String name;
  List<dynamic> questions;
  List<dynamic> answers;
  Timestamp quizDate;
  String masterPdfUri;
  int score;
  int fullScore;

  @override
  DocumentReference reference;

  Quiz(this.name, {this.questions, this.answers, this.quizDate, this.score, this.masterPdfUri, this.fullScore});

  //factory constructor
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(json['name'] as String,
        questions: json['question'] as List<dynamic>,
        answers: json['answer'] as List<dynamic>,
        quizDate: json['quizDate'] as Timestamp,
        score: json['score'] ?? 0,
        fullScore: json['fullScore'] ?? 0,
        masterPdfUri: json['masterPdfUri'] ??  "",
    );
  }
  //factory constructor
  factory Quiz.fromSnapshot(DocumentSnapshot snapshot) {
    Quiz newQuiz = Quiz.fromJson(snapshot.data);
    newQuiz.reference = snapshot.reference;
    return newQuiz;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'name' : this.name,
      'question': this.questions,
      'answer' : this.answers,
      'quizDate' : this.quizDate,
      'score' : this.score,
      'masterPdfUri' : this.masterPdfUri,
      'fullScore' : this.fullScore,
    };
  }

  toString(){
    return 'Quiz: $name with a score of $score';
  }
}