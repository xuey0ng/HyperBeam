import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final int score;
  final int fullScore;
  final List<Quiz> quizList;
  final Size size;
  final List<Task> taskList;

  const ProgressCard({
    Key key,
    this.title,
    this.score,
    this.fullScore,
    this.quizList,
    this.size,
    this.taskList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 40, right: 8),
      height: 304,
      width: 0.6*size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 288,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 16,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),/*
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  onPressed: () {},
                ),
                BookRating(score: rating),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: kBlackColor),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: auth,
                            style: TextStyle(
                              color: kLightBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: pressDetails,
                        child: Container(
                          width: 101,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text("Details"),
                        ),
                      ),
                      Expanded(
                        child: TwoSideRoundedButton(
                          text: "Read",
                          press: pressRead,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}


class ProgressAdditionCard extends StatelessWidget {
  final Size size;

  const ProgressAdditionCard({
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 40, right: 8),
      height: 304,
      width: 0.6*size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: Center(
                child: Icon(Icons.add),
              ),
              height: 288,
              decoration: BoxDecoration(
                color: Color(0x88FFFFFF),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ProgressLoadingCard extends StatelessWidget {
  final String title;
  final int score;
  final int fullScore;
  final List<Quiz> quizList;
  final Size size;
  final List<Task> taskList;

  const ProgressLoadingCard({
    Key key,
    this.title,
    this.score,
    this.fullScore,
    this.quizList,
    this.size,
    this.taskList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 40),
      height: 240,
      width: 0.6*size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 216,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}