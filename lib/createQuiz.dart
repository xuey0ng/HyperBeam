import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dataRepo.dart';

class CreateQuiz extends StatefulWidget {
  void setQuiz() async{
    try {

    } catch (err) {
      print("Error: $err");
    }
  }
  @override
  State<StatefulWidget> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final quizFormKey = new GlobalKey<FormState>();
  var _questions = new List(10);
  var _answers = new List(10);
  final quizRepository= DataRepo("Quizzes");

  Widget _buildSuggestions() {
    Quiz newQuiz;
    return Scaffold(
      appBar:AppBar(
        title: Text("Create Quiz")
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            return _buildRow(i + 1);
          }),
      floatingActionButton:FloatingActionButton(
        onPressed: ()=>{
          for(int i = 0; i < _questions.length; i++){
            if(_questions[i] != null) {
              newQuiz = new Quiz(question: _questions[i], answer: _answers[i]),
              quizRepository.addDoc(newQuiz),
            }
          },
          Navigator.of(context).pop(),
        },
        child: const Icon(Icons.assignment_turned_in),
      ),
    );
  }
  Widget _buildRow(int ind) {
    return new Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: ind.toString() + '   Enter your question here'
            ),
            onChanged: (val) => _questions[ind-1] = val,
          ),
          TextFormField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: ind.toString() + '   Enter your answer here'
            ),
            onChanged: (val) => _answers[ind-1] = val,
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}

class Quiz implements iDatabaseable {
  String question;
  String answer;
  @override
  DocumentReference reference;

  Quiz({this.question: "", this.answer: ""});

  //factory constructor
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(question: json['question'] as String, answer: json['answer'] as String);
  }
  //factory constructor
  factory Quiz.fromSnapshot(DocumentSnapshot snapshot) {
    Quiz newQuiz = Quiz.fromJson(snapshot.data);
    newQuiz.reference = snapshot.reference;
    return newQuiz;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'question': this.question,
      'answer' : this.answer,
    };
  }

  toString(){
    return 'Q: $question A: $answer';
  }
}