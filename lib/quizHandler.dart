import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:HyperBeam/viewQuizzes.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: 300,
              color: Color(0xFFE3F2FD),
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              child: Column(
                      children: [
                        Text("Quiz overview"),
                        ViewQuizzes(),
                      ]
                  )
              ),
          RaisedButton(
            child: Text("Create Quiz"),
            onPressed: () {
              Navigator.pushNamed(context, CreateQuizRoute);
            },
          ),]
    );
  }
}