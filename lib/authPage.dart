import 'package:HyperBeam/loginPage.dart';
import 'package:HyperBeam/services/firebase_metadata_service.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'homePage.dart';
import 'package:HyperBeam/services/firebase_storage_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
        if (userSnapshot.connectionState == ConnectionState.active) {
            return userSnapshot.hasData ? HomePage() : LoginPage();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
