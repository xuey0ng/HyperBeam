import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/quizResultPage.dart';
import 'package:HyperBeam/services/firebase_quizAttempt_service.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:provider/provider.dart';

class AttemptQuiz extends StatefulWidget {
  DocumentSnapshot snapshot;
  Module module;
  AttemptQuiz({this.snapshot, this.module});
  @override
  State<StatefulWidget> createState() => _AttemptQuizState(quiz: Quiz.fromSnapshot(snapshot));
}

class _AttemptQuizState extends State<AttemptQuiz> {
  Quiz quiz;
  List<String> _givenAnswers;
  int index = 0;
  int radioValue;
  _AttemptQuizState({this.quiz});

  @override
  void initState(){
    super.initState();
    _givenAnswers = List(quiz.fullScore);
  }

  Widget _buildRow(int ind) {
    if(ind >= quiz.sets.length) {
      return new Form(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                      text: "You have reached the end of quiz",
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: RaisedButton(
                  child: Text("Submit"),
                  color: kAccentColor,
                  onPressed: () async {
                    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
                    final quizAttemptRepository = Provider.of<FirebaseQuizAttemptService>(context).getRepo();
                    int quizScore = 0;
                    quiz.score = quizScore;
                    for(int i = 0; i < quiz.sets.length; i++) {
                      print(" GIVEN ANS IS");
                      print(_givenAnswers[i]);
                      if(quiz.sets[i].answer == _givenAnswers[i]){
                        quizScore++;
                      }
                    }
                    QuizAttempt currAttempt = QuizAttempt(
                      date: DateTime.now(),
                      givenAnswers: _givenAnswers,
                      quiz: quiz,
                      score: quizScore,
                    );
                    DocumentReference currAttemptRef = await quizAttemptRepository.addDoc(currAttempt);
                    print(quiz.attempts);
                    var quizAttempts = quiz.attempts == null ? null:List.from(quiz.attempts);
                    quizAttempts == null ?
                    quizAttempts = List.from([currAttemptRef]) : quizAttempts.add(currAttemptRef);
                    print("ATTEMPT IS $currAttemptRef");
                    quiz.attempts = quizAttempts;
                    quizRepository.updateDoc(quiz);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return QuizResultPage(
                          quiz: quiz,
                          givenAnswers: _givenAnswers,
                          fullScore: quiz.sets.length,
                          quizScore: quizScore,
                          module: widget.module,
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
        ),
      );
    } else {
      return quizForm(quiz.sets[index] , index);
    }
  }

  Widget quizForm(ProblemSet questionSet, int ind) {
    var controller = TextEditingController();
    if (questionSet.MCQ) {
      List<Widget> optionList = List();
      for(int i = 0; i < questionSet.options.length; i++) {
        if (questionSet.options[i] != null){
          String optionField = questionSet.options[i];
          Widget newCard = GestureDetector(
            onTap: () {
              print("radioValue is $radioValue");
              setState(() {
                radioValue = i;
              });
              _givenAnswers[index] = optionField;
            },
            child: Card(
              elevation: 1,
              child: Row(
                children: <Widget>[
                  Text(optionField),
                  Spacer(),
                  Radio(
                    value: i,
                    groupValue: radioValue,
                  )
                ],
              ),
            )
          );
          optionList.add(newCard);
        }
      }
      return Form(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:24, left: 16),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline4,
                        children: [
                          TextSpan(text: "Question "),
                          TextSpan(text: "${index+1}\n", style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:24, left: 16),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline5,
                        children: [
                          TextSpan(text: questionSet.question),
                        ]
                    )
                ),
              ),
              SizedBox(height: 30,),
              Column(
                children: optionList,
              ),
              SizedBox(height: 48),
              RaisedButton(
                color: kAccentColor,
                child: Text("Next Question"),
                onPressed: () {
                  setState(() {
                    index++;
                    controller.clear();
                    radioValue = null;
                  });
                },
              ),
            ]
        ),
      );
    } else {
      return Form(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:24, left: 16),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline4,
                        children: [
                          TextSpan(text: "Question "),
                          TextSpan(text: "${index+1}\n", style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:24, left: 16),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline5,
                        children: [
                          TextSpan(text: questionSet.question),
                        ]
                    )
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.only(top:24, left: 64),
                child: TextFormField(
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: (questionSet.number).toString() + '   Enter your answer here'
                  ),
                  onChanged: (val) => _givenAnswers[index] = val),
                ),
              SizedBox(height: 48),
              RaisedButton(
                color: kAccentColor,
                child: Text("Next Question"),
                onPressed: () {
                  setState(() {
                    index++;
                    controller.clear();
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          ModuleDetailsRoute,
          arguments: widget.module.moduleCode,
        );
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg1.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
               _buildRow(index),
              ],
            ),
          ]
        ),
      ),
    );
  }
}