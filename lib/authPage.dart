import 'package:HyperBeam/loginPage.dart';
import 'package:HyperBeam/moduleDetails.dart';
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
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
