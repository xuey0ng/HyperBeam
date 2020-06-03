import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/viewQuizzes.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/createQuiz.dart';

class HomePage extends StatefulWidget {
  final BaseAuth baseAuth;
  final VoidCallback onSignedOut;
  HomePage({this.baseAuth, this.onSignedOut});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<Task> taskList =  new List<Task>();
  final DataRepo taskRepository = DataRepo();

  void _signOut() async {
    try {
      await widget.baseAuth.signOut();
      widget.onSignedOut();
    } catch (err) {
      print(err);
    }
  }
  void _handleProgressChanged(){
    AlertDialogWidget dialogWidget = AlertDialogWidget();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add module"),
          content: dialogWidget,
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                Navigator.of(context).pop();
                Task newTask = Task(dialogWidget.taskName, completed: dialogWidget.taskCompleted);
                taskRepository.addTask(newTask);
              }
            )
          ]
        );
      }
    );
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
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ProgressChart(),
              UpdateProgress(onChanged: _handleProgressChanged),
              ViewQuizzes(),
              RaisedButton(
                child: Text("Create Quiz"),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return Scaffold(
                        appBar: AppBar(
                          title: Text("Create Quiz"),
                        ),
                        body: CreateQuiz(),
                        floatingActionButton: FloatingActionButton(
                          onPressed: ()=>{},
                          child: const Icon(Icons.assignment_turned_in),
                        ),
                      );
                    }),
                  );
                },
              ),
              UploadFile(),
            ],
          )
      ),
    );
  }
}

class UpdateProgress extends StatelessWidget{
  final VoidCallback onChanged;

  UpdateProgress({Key key, @required this.onChanged}): super(key: key);

  void _handleTap(){
    onChanged();
  }
  @override
  Widget build(BuildContext context) {
      return RaisedButton(
        child: Text("Update Progress"),
        onPressed: _handleTap,
      );
  }
}

class UploadFile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Upload File"),
      onPressed: (){
        // TODO Upload file from phone
      },
    );
  }
}
