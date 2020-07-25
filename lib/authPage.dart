import 'package:HyperBeam/homePage.dart';
import 'package:HyperBeam/loginPage.dart';
import 'package:HyperBeam/moduleDetails.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/router.dart' as router;
import 'package:HyperBeam/routing_constants.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
        if (userSnapshot.connectionState == ConnectionState.active) {
            if(userSnapshot.hasData){
              if(userSnapshot.data.verified){
                return MaterialApp(
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
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
