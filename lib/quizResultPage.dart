import 'package:HyperBeam/moduleDetails.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatelessWidget{
  final Quiz quiz;
  final List<String> givenAnswers;
  final int fullScore;
  final int quizScore;
  final Module module;

  const QuizResultPage({Key key, this.quiz, this.givenAnswers, this.fullScore, this.quizScore, this.module}) : super(key: key);

  Widget _listItem(String question, String answer, String givenAnswer, int index){
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 20, left: 16, right:16),
      height: 176,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.25,
            child: Container(
              decoration: BoxDecoration(
                color: givenAnswer == answer ? Color(0x9998FB98) : Color(0x99FE4242),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Positioned(
            left:8,
            top:8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kMediumText),
                          text: "Question ${index+1}: \n $question",
                      )
                  ),
                  SizedBox(height:8),
                  RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kSmallText),
                          text: "Answer: $answer",
                      )
                  ),
                  SizedBox(height: 4),
                  Container(
                    child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            style: TextStyle(color: Colors.black,
                                fontSize: kSmallText,
                                decoration: TextDecoration.underline
                            ),
                            text: "Your answer: ${givenAnswer?? "No answers given"}",
                        )
                    ),
                  ),
                ]
            ),
          ),
        ]
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    List<Widget> columnItems = new List(fullScore);
    for(int i = 0; i < fullScore; i++) {
      if(quiz.questions[i] != null) {
        columnItems[i] = _listItem(quiz.questions[i], quiz.answers[i], givenAnswers[i], i);
      }
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          ModuleDetailsRoute,
          arguments: module,
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
            ListView(
             // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:24, left: 32),
                  child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.headline3,
                          children: [
                            TextSpan(text: "Summary\n", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Score: $quizScore out of $fullScore", style: TextStyle(fontSize: kMediumText)),
                          ]
                      )
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: columnItems,
                ),
                Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: RaisedButton(
                        color: kAccentColor,
                        child: Text('Return'),
                        onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                          return ModuleDetails(module.moduleCode);
                          })
                        )
                        },
                      ),
                    ),
                    Spacer(),
                  ]
                )
              ],
            ),
          ]
        ),
      ),
    );
  }
}