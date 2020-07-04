import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_metadata_service.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/services/firebase_quizAttempt_service.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/services/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
    print('AuthWidgetBuilder rebuild');
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        print(snapshot.toString());
        final User user = snapshot.data;
        print('StreamBuilder: ${snapshot.connectionState} and ${user ==null? null : user.id}');
        if(!snapshot.hasData) return builder(context, snapshot);
        return StreamBuilder<DocumentSnapshot> (
          stream: Firestore.instance.collection('users').document(user.id).snapshots(),
          builder: (context, snapshot2){
            print(' it is ${snapshot2.hasData? snapshot2.data.data:null}');
            //final User user = User.fromSnapshot(snapshot2.data);
           // print('StreamBuilder: ${snapshot.connectionState} and ${user ==null? null : user.id}');
            if (user != null) {
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
                  Provider<FirebaseModuleService>.value(value: FirebaseModuleService(id: user ==null ? "" : user.id)),
                  Provider<FirebaseQuizAttemptService>.value(value: FirebaseQuizAttemptService(id: user ==null ? "" : user.id)),
                ],
                child: builder(context, snapshot),
              );
            }
            return builder(context, snapshot);
          },
        );
      },
    );
  }
}