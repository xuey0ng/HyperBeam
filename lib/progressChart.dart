import 'package:firebase_auth/firebase_auth.dart';
import 'package:getflutter/getflutter.dart';
import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:HyperBeam/auth.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:HyperBeam/services/firebase_metadata_service.dart';

class ProgressChart extends StatefulWidget {
  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart>{

  Widget currentTasks(BuildContext context) {
    final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
    return StreamBuilder<QuerySnapshot>(
        stream: taskRepository.getStream(), //stream<QuerySnapshot>
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshots) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshots.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final Task task = Task.fromSnapshot(snapshot);
    final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
    if (task == null) {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child:
          Material(
            borderRadius: BorderRadius.circular(10),
            color: task.completed ? Color(0xFF00f0f0) : Color(0xFFf1948a),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(task.name == null ? "" : task.name),
                    )
                  ),
                  task.completed ? IconButton(
                    icon: Icon(
                      Icons.check,
                    ),
                    onPressed: (){},
                  ) :
                  IconButton(
                    icon: Icon(
                      Icons.check_box_outline_blank,
                    ),
                    onPressed: (){},
                  ),

                ],
              ),
              onTap: () {
                Task currTask = Task.fromSnapshot(snapshot);
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(currTask.name ?? "No name given"),
                        actions: <Widget>[
                          FlatButton(
                              child: Text("Delete"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                taskRepository.delete(snapshot);
                              }
                          ),
                          FlatButton(
                              child: Text("Update"),
                              onPressed: () {
                              //todo
                                Navigator.of(context).pop();
                              }
                          )
                        ]
                    );
                  }
                );
              },
            )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 300,
            color: Color(0xFFE3F2FD),
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(0.0),
            child:
              Column(
                    children: [
                      Text("ProgressChart"),
                      new CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 5.0,
                        percent: 1.0,
                        //center: new Text("${taskRepository.documentCount()}"),
                        progressColor: Colors.red,
                      ),
                      Expanded(
                        child: currentTasks(context),
                      ),
                    ]
                )
            ),
            UpdateProgress(),
          ]
        );
    }
}

class AlertDialogWidget extends StatefulWidget {
  String taskName;
  bool taskCompleted = false;

  @override
  _AlertDialogWidgetState createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter a task name",
            ),
            onChanged: (val) => widget.taskName = val,
          ),
          Row(
            children: <Widget>[
              Text("Completed"),
              Checkbox(
                value: widget.taskCompleted,
                onChanged: (bool value) {
                  setState(() {
                    widget.taskCompleted = value;
                  });
                }
              )
            ],
          )
        ],
      )
    );
  }
}

class Task implements iDatabaseable{
  final String name;
  bool completed;

  @override
  DocumentReference reference;

  Task(this.name, {this.completed: false});

  //factory constructor
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(json['name'] as String, completed: json['completed'] as bool);
  }
  //factory constructor
  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    Task newTask = Task.fromJson(snapshot.data);
    newTask.reference = snapshot.reference;
    return newTask;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'name': this.name,
      'completed': this.completed,
    };
  }

  toString(){
    return name;
  }
}

class UpdateProgress extends StatelessWidget{
  void _handleProgressChanged(BuildContext context) {
    final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
    final metaDataRepository = Provider.of<FirebaseMetadataService>(context).getRepo();
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
                      taskRepository.addDoc(newTask);
                    }
                )
              ]
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GFButton(
        onPressed:() {
          _handleProgressChanged(context);
        },
        text: "Add task",
        shape: GFButtonShape.pills,
        color: Color(0xFFfce8e8),
        textStyle: TextStyle(fontSize: 30, color: Colors.black),
      )
    );
  }
}