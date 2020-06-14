import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:HyperBeam/viewQuizzes.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/fileHandler.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<Task> taskList =  new List<Task>();
  String userId = "";
  TabController _tabController;
  List<Widget> _kTabPages = <Widget> [
    Text("loading"),
    Text("loading"),
    Text("loading"),
  ];

  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context);
      await auth.signOut();
    } catch (err) {
      print(err);
    }
  }

  List<Widget> _kTabs = <Tab>[
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.lightbulb_outline), text: 'Quiz'),
    Tab(icon: Icon(Icons.insert_drive_file), text: 'File'),
  ];

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
    );
  }
}




