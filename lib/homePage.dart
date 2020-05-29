import 'package:HyperBeam/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final BaseAuth baseAuth;
  final VoidCallback onSignedOut;

  HomePage({this.baseAuth, this.onSignedOut});

  void _signOut() async {
    try {
      await baseAuth.signOut();
      onSignedOut();
    } catch (err) {
      print(err);
    }
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
      body: new Center(
        child: Column(
          children: <Widget>[
            ProgressChart(),
            Spacer(flex:2),
            Text("Upload file"),
            Spacer(flex:10),
          ],
        )
      ),
    );
  }

}

class ProgressChart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
