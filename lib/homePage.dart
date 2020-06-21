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
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

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
    return Scaffold(
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
                /*
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                    ],
                  )
                ),*/
              ],
            )
          ),
        ],
      )
    );
  }
}

/*
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<Task> taskList =  new List<Task>();
  String userId = "";
  TabController _tabController;
  List<Widget> _kTabPages = <Widget> [
    Text("loading"),
    Text("loading"),
    Text("loading"),
  ];
  List<Widget> _kTabs = <Tab>[
    Tab(icon: Icon(Icons.home, color: Color(0xFF0000FF)), text: 'Home'),
    Tab(icon: Icon(Icons.lightbulb_outline, color: Color(0xFF0000FF)), text: 'Quiz'),
    Tab(icon: Icon(Icons.insert_drive_file, color: Color(0xFF0000FF)), text: 'File'),
  ];

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
    setState(() {
      _kTabPages = <Widget> [
        ProgressChart(),
        QuizHandler(),
        UploadFile(),
      ];
      _tabController = TabController(
        length: _kTabPages.length,
        vsync: this,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Container(
      //  width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.jpg"),
            fit: BoxFit.fill,
          ),
        ),
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
                        TextSpan(text: "Welcome back, \n"),
                        TextSpan(text: "User", style: TextStyle(fontWeight: FontWeight.bold))
                      ]
                  )
              )
            ),

          ],

      ),/*
      bottomNavigationBar: Material(
          color: Color(0xFFFFFFFF),
          child: TabBar(
            tabs: _kTabs,
            controller: _tabController,
          )*/
      ),
    );


    /*
    return Scaffold(
      appBar: AppBar(
          title: Text("Dashboard"),
          actions: <Widget> [
            new FlatButton(
              child: new Text('Logout'),
              onPressed: () => _signOut(context),
            )
          ]
      ),
      body: TabBarView(
        children: _kTabPages,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Color(0xFFFFFFFF),
        child: TabBar(
          tabs: _kTabs,
          controller: _tabController,
        )
      ),
    );*/
  }
}*/




