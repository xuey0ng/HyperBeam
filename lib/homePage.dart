import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/fileHandler.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context);
      await auth.signOut();
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg2.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: new Text('Logout'),
                        onPressed: () => _signOut(context),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              style: Theme.of(context).textTheme.headline5,
                              children: [
                                TextSpan(text: "What are you \ndoing "),
                                TextSpan(text: "today?", style: TextStyle(fontWeight: FontWeight.bold))
                              ]
                          )
                      )
                  ),
                  SizedBox(height: size.height * .02),
                  ProgressChart(),
                  SizedBox(height: size.height * .02),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              style: Theme.of(context).textTheme.headline5,
                              children: [
                                TextSpan(text: "At a "),
                                TextSpan(text: "glance...", style: TextStyle(fontWeight: FontWeight.bold))
                              ]
                          )
                      )
                  ),
                  SizedBox(height: size.height * .02),
                ],
              )
            ),
          ],
        )
      ),
    );
  }
}