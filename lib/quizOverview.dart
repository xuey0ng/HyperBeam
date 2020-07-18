import 'package:HyperBeam/homePage.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizOverview extends StatelessWidget{
  final Quiz quiz;
  final int fullScore;


  const QuizOverview({Key key, this.quiz, this.fullScore,}) : super(key: key);

  Widget _listItem(ProblemSet set, int index, var size){
    String question =  set.question;
    String answer = set.answer;
    List<dynamic> options = set.options;
    if(set.MCQ) {
      List<Widget> widgetList = List();
      for(int i = 0; i < options.length; i++) {
        if(options[i] != null) {
          Widget opt = Card(
            color: options[i] == answer ? Color(0xFF00FF00) : null,
            child: Text("${i+1}) ${options[i]}"),
          );
          widgetList.add(opt);
        }
      }
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
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                Positioned(
                  left:8,
                  top:8,
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width * 0.80,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widgetList,
                            ),
                            SizedBox(height: 4),
                          ]
                      ),
                    ),
                  ),
                ),
              ]
          )
      );
    } else {
      return Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 20, left: 16, right:16),
          height: 132,
          width: size.width * 0.95,
          child: Stack(
              children: [
                Opacity(
                  opacity: 0.25,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                Positioned(
                  left:8,
                  top:8,
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width * 0.80,
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
                          ]
                      ),
                    ),
                  ),
                ),
              ]
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    var size = MediaQuery.of(context).size;
    List<Widget> columnItems = new List(fullScore);
    for(int i = 0; i < fullScore; i++) {
      if(quiz.sets[i] != null) {
        columnItems[i] = _listItem(quiz.sets[i], i, size);
      }
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child:
      Scaffold(
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:24, left: 32),
                            child: RichText(
                                text: TextSpan(
                                    style: Theme.of(context).textTheme.headline3,
                                    children: [
                                      TextSpan(text: "${quiz.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                )
                            ),
                          ),
                          Spacer(),
                        ]
                    ),
                    Container(
                      width: size.width*0.95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: columnItems,
                      ),
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
                                      return HomePage();
                                    })
                                )
                              },
                            ),
                          ),
                          Spacer(),
                        ]
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}