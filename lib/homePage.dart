import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/viewQuizzes.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/fileHandler.dart';

class HomePage extends StatefulWidget {
  final BaseAuth baseAuth;
  final VoidCallback onSignedOut;
  final String userId;
  HomePage({this.baseAuth, this.onSignedOut, this.userId});

  @override
  State<StatefulWidget> createState() => _HomePageState(userId);
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  List<Task> taskList =  new List<Task>();
  String userId;
  TabController _tabController;
  List<Widget> _kTabPages;

  _HomePageState(String userId) {
    this.userId = userId;
    _kTabPages = <Widget> [
      ProgressChart(userId),
      ViewQuizzes(userId),
      UploadFile(),
    ];
    _tabController = TabController(
      length: _kTabPages.length,
      vsync: this,
    );
  }

  void _signOut() async {
    try {
      await widget.baseAuth.signOut();
      widget.onSignedOut();
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
  Widget build(BuildContext context) {
    print(_kTabPages.toString());
    return Scaffold(
      appBar: AppBar(
          title: Text("Dashboard"),
          actions: <Widget> [
            new FlatButton(
              child: new Text('Logout'),
              onPressed: _signOut,
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




