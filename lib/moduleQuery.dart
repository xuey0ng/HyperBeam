import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:provider/provider.dart';


class ModuleQuery extends StatelessWidget {

  Widget activityChart(var size) {

  }

  Widget friendList(var size, User user) {
    return Container(
      child: Column(
        children: <Widget>[
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Friend list",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                    ),
                  ]
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context, listen: false);
    return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 32),
                  //Icon(Icons.account_circle,),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.headline5,
                          children: [
                            TextSpan(text: "${user.name}", style: TextStyle(fontWeight: FontWeight.bold))
                          ]
                      )
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.headline5,
                          children: [
                            TextSpan(text: "ID: ${user.id}", style: TextStyle(fontSize: kSmallText))
                          ]
                      )
                  ),
                  //activityChart(size),
                  friendList(size, user),
                ],
              )
            )
          )
        ],
      );
  }

}