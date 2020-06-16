import 'package:HyperBeam/auth_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/authPage.dart';
import 'package:HyperBeam/main.dart';
import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => MyApp());
    case AuthWidgetRoute:
      var loginArgument = settings.arguments;
      return MaterialPageRoute( builder: (context) => AuthWidgetBuilder(builder: loginArgument)
      );
    case CreateQuizRoute:
      return MaterialPageRoute(builder: (context) => CreateQuiz());
    default:
      return MaterialPageRoute(builder: (context) => AuthPage());
  }
}