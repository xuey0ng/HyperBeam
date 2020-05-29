import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/authPage.dart';
import 'package:HyperBeam/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyper Beam',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: AuthPage(baseAuth: new Auth()),
    );
  }
}
