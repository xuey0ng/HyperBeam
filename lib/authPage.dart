import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/loginPage.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';


class AuthPage extends StatefulWidget {
  final BaseAuth baseAuth;
  AuthPage({this.baseAuth});

  @override
  State<StatefulWidget> createState() => new _AuthPageState();

}

enum AuthStatus {
  signedIn,
  notSignedIn,
}

class _AuthPageState extends State<AuthPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn; //default

  @override
  void initState() {
    super.initState();
    widget.baseAuth.currentUser().then((Id) {
      setState((){
        _authStatus = Id == null ? AuthStatus.notSignedIn: AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.notSignedIn) {
      return new LoginPage(
        baseAuth: widget.baseAuth,
        onSignedIn: _signedIn,
      );
    } else {
      return new HomePage(
        baseAuth: widget.baseAuth,
        onSignedOut: _signedOut,
      );
    }
  }

}