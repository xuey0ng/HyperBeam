import 'package:HyperBeam/explorePage.dart';
import 'package:HyperBeam/moduleQuery.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/widgets/atAGlance.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/progressChart.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_pushNotification_service.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'objectClasses.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  PageController _controller = PageController(
    initialPage: 0,
  );

  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context);
      await auth.signOut();
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<User>(context, listen: false);
    PushNotificationService(user: user, context: context).initialise();

    Future<String> _loadModulesAsset() async {
      return await rootBundle.loadString('assets/NUS/moduleInfo.json');
    }
    Future loadModule() async {
      String jsonString = await _loadModulesAsset();
      final jsonResponse = json.decode(jsonString);
      NUS_MODULES = new ModulesList.fromJson(jsonResponse);
    }
    if(NUS_MODULES == null)  {
      loadModule();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//hides the app bar above
    var size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context, listen: false);
    final mod = Provider.of<FirebaseModuleService>(context).getRepo();
    return WillPopScope(
      onWillPop: () async {
        //navigatorKey.currentState.maybePop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg2-2.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            PageView(
                scrollDirection: Axis.vertical,
                controller: _controller,
                children: [
                  Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle),
                                      new Text('${user.name}'),
                                    ]
                                  ),
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
                              SizedBox(height: size.height * .01),
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
                              AtAGlance(screenHeight: size.height, screenWidth: size.width),
                              SizedBox(height: size.height * .02),
                            ],
                          )
                      )
                  ),
                  ExplorePage(),
                ]
            ),
          ]
        ),
      ),
    );
  }
}