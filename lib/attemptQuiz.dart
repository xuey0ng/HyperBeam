import 'package:flutter/material.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:HyperBeam/routing_constants.dart';

class AttemptQuiz extends StatefulWidget {
  Quiz quiz;
  AttemptQuiz({this.quiz});
  @override
  State<StatefulWidget> createState() => _AttemptQuizState(quiz: quiz);
}

class _AttemptQuizState extends State<AttemptQuiz> {
  Quiz quiz;
  List<String> _givenAnswers = new List(10);
  int index = 0;
  _AttemptQuizState({this.quiz});

  Widget _quizResult() {
    int quizScore = 0;
    int fullScore = 0;
    for(int i=0 ; i < 10; i++) {
      if(quiz.questions[i] != null) {
        fullScore++;
        if(quiz.answers[i] == _givenAnswers[i]){
          quizScore++;
        }
      }
    }

    return Scaffold(
      appBar:AppBar(
          title: Text("Quiz result")
      ),
      body: Column(
        children: <Widget>[
          Text("You scored ${quizScore} out of ${fullScore}"),
          RaisedButton(
            child: Text('Return'),
            onPressed: () => Navigator.pushNamed(context, HomeRoute),
          )
        ],
      ),
    );
  }

  Widget _buildRow(int ind) {
    if(quiz.questions[ind] == null) {
      return new Form(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("You have reached the end of quiz"),
              RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return _quizResult();
                    }),
                  );
                },
              )
            ],
        ),
      );
    } else {
      var controller1 = TextEditingController();
      return new Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(quiz.questions[ind]),
              TextFormField(
                autofocus: true,
                controller: controller1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: (ind+1).toString() + '   Enter your answer here'
                ),
                onChanged: (val) => _givenAnswers[ind] = val,
              ),
              RaisedButton(
                child: Text("Next Question"),
                onPressed: () {
                  setState(() {
                    index++;
                    controller1.clear();
                  });
                },
              ),
            ]
          ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text("Attempt Quiz")
      ),
      body: Column(
        children: <Widget>[
          _buildRow(index),
        ],
      ),
    );
  }
}