import 'package:HyperBeam/quizHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';

class QuizForm extends StatefulWidget {
  String quizName;
  QuizForm(this.quizName);

  @override
  State<StatefulWidget> createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  final quizFormKey = new GlobalKey<FormState>();
  List<String> _questions = new List(10);
  List<String> _answers = new List(10); //var = string , var = annotation in pdf???
  Quiz newQuiz;
  DateTime quizDate;
  int index = 1;


  FocusNode f1;
  FocusNode f2;
  void validateAndSetQuiz(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    quizFormKey.currentState.save();
    //quizRepository.updateTime(quizDate);
    newQuiz = Quiz(widget.quizName, questions: _questions,
      answers: _answers, quizDate: Timestamp.fromDate(quizDate));
    quizRepository.addDoc(newQuiz);
  }

  Widget _buildSuggestions() {
    return Scaffold(
      appBar:AppBar(
          title: Text("Create Quiz")
      ),
      body: Column(
        children: <Widget>[
          _buildRow(index),
        ],
      ),
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
                                Navigator.pushNamed(context, '/');
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

  @override
  void initState() {
    super.initState();

    f1 = FocusNode();
    f2 = FocusNode();
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    f1.dispose();
    f2.dispose();
    super.dispose();
  }

  Widget _buildRow(int ind) {
    var controller1 = TextEditingController();
    var controller2 = TextEditingController();
    //bug of having both fields focused if  focusNodes are initialised here
    return new Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              focusNode: f1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ind.toString() + '   Enter your question here'
              ),
              onChanged: (val) => _questions[ind-1] = val,
              controller: controller1,
            ),
            TextFormField(
              focusNode: f2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ind.toString() + '   Enter your answer here'
              ),
              onChanged: (val) => _answers[ind-1] = val,
              controller: controller2,
            ),
            RaisedButton(
              child: Text("Next Question"),
              onPressed: () {
                setState(() {
                  index++;
                  controller1.clear();
                  controller2.clear();
                  f1.requestFocus();
                });
              },
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

class CreateQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  @override
  Widget build(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    QuizDialogWidget dialogWidget = QuizDialogWidget();
    return Scaffold(
      appBar:  AppBar(title: Text("Create Quiz")),
      body:
        AlertDialog(
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
                    return QuizForm(dialogWidget.quizName);
                  }),
                );
                }
              )
            ]
          ),
    );
    //return _buildSuggestions();
  }
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