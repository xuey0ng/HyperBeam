import 'package:HyperBeam/loginPage.dart';
import 'package:HyperBeam/moduleDetails.dart';
<<<<<<< HEAD
import 'package:HyperBeam/widgets/designConstants.dart';
=======
import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/services/firebase_metadata_service.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'homePage.dart';
import 'package:HyperBeam/services/firebase_storage_service.dart';
import 'package:HyperBeam/router.dart' as router;
import 'package:HyperBeam/routing_constants.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
        if (userSnapshot.connectionState == ConnectionState.active) {
<<<<<<< HEAD
            if(userSnapshot.hasData){
              if(userSnapshot.data.verified){
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Hyper Beam',
                  onGenerateRoute: router.generateRoute,
                  initialRoute: HomeRoute,
                );
              } else {
                return LoginPage();
              }
            } else {
              return LoginPage();
            }
=======
            return userSnapshot.hasData ?

            MaterialApp(
              routes: {
                ModuleDetailsRoute: (context) => ModuleDetails(),
              },
              title: 'Hyper Beam',
              onGenerateRoute: router.generateRoute,
              initialRoute: HomeRoute,
            )
                : LoginPage();
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
