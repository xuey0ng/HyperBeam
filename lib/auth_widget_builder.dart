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
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        final User user = snapshot.data;
        print('StreamBuilder: ${snapshot.connectionState} and ${user ==null? null : user.id} and ${user}');
        if(!snapshot.hasData) return MaterialApp(home: LinearProgressIndicator());
        return StreamBuilder<DocumentSnapshot> (
          stream: Firestore.instance.collection('users').document(user.id).snapshots(),
          builder: (context, snapshot2){
            if(snapshot2.data!= null){
              print("hit ${snapshot2.data== null}");
              //if (user != null) {
                return MultiProvider(
                  providers: [
                    /*
                    Provider<User>.value(value: User(id: user == null ?  "" : user.id,
                      name: snapshot2.data== null ? "" : snapshot2.data.data["name"],
                      email: snapshot2.data== null ? "" : snapshot2.data.data["email"],
                    )),*/

                    Provider<User>.value(value: user),
                    Provider<FirebaseMetadataService>.value(value: FirebaseMetadataService(id: user == null ? "" : user.id),
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
            //}
            return MaterialApp(home: LinearProgressIndicator());
          },
        );
      },
    );
  }
}