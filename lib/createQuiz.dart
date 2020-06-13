import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'dataRepo.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';

class CreateQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateQuizState();
}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

class _CreateQuizState extends State<CreateQuiz> {
  final quizFormKey = new GlobalKey<FormState>();
  var _questions = new List(10);
  var _answers = new List(10); //var = string , var = annotation in pdf???
  Quiz newQuiz;
  DateTime quizDate;

  void validateAndSetQuiz(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    quizFormKey.currentState.save();
    quizRepository.updateTime(quizDate);
    for(int i = 0; i < _questions.length; i++){
      if(_questions[i] != null) {
        newQuiz = new Quiz(question: _questions[i], answer: _answers[i]);
        quizRepository.addDoc(newQuiz);
      }
    }
  }

  Widget _buildSuggestions() {
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Schedule quiz"),
                  content: Form(
                      key: quizFormKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          FormBuilderDateTimePicker(
                            initialValue: DateTime.now(),
                            attribute: "date",
                            inputType: InputType.both,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Enter a Date',
                                labelText: "Pick a date"),
                            onSaved: (text) {
                              setState(() {
                                quizDate = text;
                              });
                            },
                          ),
                          RaisedButton(
                            child: Text("Set Quiz"),
                            onPressed: () {
                              validateAndSetQuiz(context);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                  )
              );
            }
          )
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
  Timestamp quizDate;
  @override
  DocumentReference reference;

  Quiz({this.question: "", this.answer: "", this.quizDate});

  //factory constructor
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(question: json['question'] as String, answer: json['answer'] as String,
    quizDate: json['quizDate'] as Timestamp);
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
      'quizDate' : this.quizDate
    };
  }

  toString(){
    return 'Q: $question A: $answer';
  }
}