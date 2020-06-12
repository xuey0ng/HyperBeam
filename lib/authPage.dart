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
  @override
  Widget build(BuildContext context) {
    final authService =
    Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        final user = snapshot.data;
        print('StreamBuilder: ${snapshot.connectionState} and ${user ==null? null : user.id}');
        if (snapshot.connectionState == ConnectionState.active) {
          return MultiProvider(
            providers: [
              Provider<User>.value(value: user),
              Provider<FirebaseMetadataService>.value(value: FirebaseMetadataService(id: user ==null ? "" : user.id),
              ),
              Provider<FirebaseQuizService>.value(value: FirebaseQuizService(id: user ==null ? "" : user.id),
              ),
              Provider<FirebaseTaskService>.value(value: FirebaseTaskService(id: user ==null ? "" : user.id),
              ),
              Provider<FirebaseStorageService>.value(value: FirebaseStorageService(id: user ==null ? "" : user.id),
              ),
            ],
            child: user != null ? HomePage() : LoginPage(),
          );
          return user != null ? HomePage() : HomePage();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
