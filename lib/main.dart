import 'package:HyperBeam/authPage.dart';
import 'package:HyperBeam/auth_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/router.dart' as router;
import 'package:HyperBeam/routing_constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot){
        return MaterialApp(
          title: 'Hyper Beam',
          theme: ThemeData(primarySwatch: Colors.cyan),
          home: AuthPage(userSnapshot: userSnapshot),
        );
      }),
    );
  }
}
