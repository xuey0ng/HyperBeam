import 'package:HyperBeam/routing_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        onPressed: () async {
          Navigator.pushNamed(context, HomeRoute);
        },
        child: Text("TAP ME"),
      )
    );
  }
}