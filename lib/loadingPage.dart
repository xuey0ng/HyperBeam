import 'package:HyperBeam/auth.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class LoadingPage extends StatefulWidget {
  final baseAuth;
  final onSignedOut;

  LoadingPage({this.baseAuth, this.onSignedOut});

  @override
  _LoadingPageState createState() => new _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void signIn() async {
    try{
      String id = await Auth().currentUser();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
        baseAuth: widget.baseAuth,
        onSignedOut: widget.onSignedOut,
        userId: id,
      )));
    } catch(err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Sign in")),
      body: RaisedButton(
        onPressed: signIn,
        child: Center(child: Text("Welcome")),
      )
    );
  }

}