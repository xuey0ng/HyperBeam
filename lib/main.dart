import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/authPage.dart';
import 'package:HyperBeam/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';

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
      child: MaterialApp(
        title: 'Hyper Beam',
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: AuthPage(),
      ),
    );
  }
}
