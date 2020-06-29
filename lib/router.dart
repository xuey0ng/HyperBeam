import 'package:HyperBeam/auth_widget_builder.dart';
import 'package:HyperBeam/homePage.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/authPage.dart';
import 'package:HyperBeam/main.dart';
import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/moduleDetails.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:HyperBeam/pastResultsPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case CreateQuizRoute:
      return MaterialPageRoute(builder: (context) => CreateQuiz());
    case ModuleDetailsRoute:
      return MaterialPageRoute(builder: (context) => ModuleDetails());
    case PastResultsRoute:
      return MaterialPageRoute(builder: (context) => PastResultsPage());
    default:
      return MaterialPageRoute(builder: (context) => AuthPage());
  }
}