import 'package:HyperBeam/auth.dart';
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
  void initState() {
    super.initState();
    setState(() {
      _kTabPages = <Widget> [
        ProgressChart(widget.userId),
        ViewQuizzes(widget.userId),
        UploadFile(widget.userId),
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




