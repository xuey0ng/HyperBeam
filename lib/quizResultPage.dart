import 'package:HyperBeam/moduleDetails.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatelessWidget{
  final Quiz quiz;
  final List<String> givenAnswers;
  final int fullScore;
  final int quizScore;
  final Module module;

  const QuizResultPage({Key key, this.quiz, this.givenAnswers, this.fullScore, this.quizScore, this.module}) : super(key: key);

  Widget _buildRating(Quiz quiz, BuildContext context) {
    final user = Provider.of<User>(context);
    final quizRepo = Provider.of<FirebaseQuizService>(context).getRepo();
    num quizRating;
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: Theme.of(context).textTheme.headline4,
                  children: [
                    TextSpan(text: "Review it!"),
                  ]
              )
          ),
          SizedBox(height: 8),
          RatingBar(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              quizRating = rating;
            },
          ),
          SizedBox(height: 8),
          RaisedButton(
            child: Text("Submit review and return"),
            color: kSecondaryColor,
            onPressed: () async {
              if(quiz.reviewers == null){
                Map<String,dynamic> map ={
                  "reviewers" : [
                    user.id,
                    quizRating == null ? "3.0" : quizRating.toString(),
                  ]
                };
                quizRepo.getCollectionRef()
                    .document(quiz.reference.documentID.toString()).setData(map, merge: true);
                Navigator.of(context).pop();
              } else {
                if (quiz.reviewers.contains(user.id)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:  BorderRadius.circular(20.0)
                            ),
                            backgroundColor: kSecondaryColor,
                            child: Container(
                                height: 120,
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 8),
                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black, fontSize: kBigText),
                                          text: "You can only give review once",
                                        )
                                    ),
                                    RaisedButton(
                                      child: Text("Ok"),
                                      color: kAccentColor,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                )
                            )
                        );
                      }
                  );
                } else {
                  quizRepo.incrementList(quiz.reference.toString(), "reviewer", user.id);
                  quizRepo.incrementList(quiz.reference.toString(), "reviewer", quizRating.toString());
                  Navigator.of(context).pop();
                }
              }
            },
          )
        ],
      ),
    );
  }

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
    /*
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    List<Widget> columnItems = new List(fullScore);
    for(int i = 0; i < fullScore; i++) {
      if(quiz.questions[i] != null) {
        columnItems[i] = _listItem(quiz.questions[i], quiz.answers[i], givenAnswers[i], i);
      }
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ModuleDetails(module.moduleCode);
            })
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
                ),
                _buildRating(quiz, context),

              ],
            ),
          ]
        ),
      ),
    );*/
  }
}