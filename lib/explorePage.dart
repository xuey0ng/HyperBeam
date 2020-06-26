
import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  DataRepo quizRepository;

  @override
  Widget build(BuildContext context) {
    quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    return Scaffold(
      backgroundColor: Colors.transparent,
        body:
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 800,
              width: 500,
              child: Column(
                children: [
                  Container(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: Theme.of(context).textTheme.headline2,
                            children: [
                              TextSpan(text: "Explore", style: TextStyle(fontWeight: FontWeight.bold, ))
                            ]
                        )
                    )
                  ),
                  Container(
                    height: 600,
                    width: 500,
                    child: _generateData(),
                  ),
                ]
              ),
            ),
    );
  }

  Widget _generateData(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream: quizRepository.getStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: _buildList(context, snapshot.data.documents),
              ),
            ),
          ],
        );


        //return _buildList(context, snapshot.data.documents);
      });
  }
  _buildList(BuildContext context, List<DocumentSnapshot> quizzes) {

    //List<Quiz> quizLst = List();
    List<Quiz> quizLst = List(quizzes.length);
    List<Widget> widgetLst = List(quizzes.length);

    for(int i = 0; i < quizzes.length; i++) {
      quizLst[i] = Quiz.fromSnapshot(quizzes[i]);
    }
    for(int i = 0; i < quizLst.length; i++) {
      widgetLst[i] = _buildQuizCard(quizLst[i]);
    }
    return widgetLst;
  }
  _buildQuizCard(Quiz quiz) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.6,
          child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: kBigText),
                    text: "${quiz.moduleName?? "???"}",
                  )
              ),
            ),
            Container(
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: kMediumText),
                    text: "${quiz.name}",
                  )
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: kSmallText),
                    text: "No. of questions: ${quiz.fullScore}",
                  )
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: kSmallText),
                    text: "Ratings: NA",
                  )
              ),
            ),
          ],
        )
      ]
    );
  }

}