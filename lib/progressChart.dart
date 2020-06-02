import 'package:HyperBeam/dataRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressChart extends StatefulWidget {
  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart>{
  final DataRepo taskRepository = DataRepo();

  Widget currentTasks() {
    return   StreamBuilder<QuerySnapshot>(
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
    if (task == null) {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child:
          Material(
            color: task.completed ? Color(0xFF00f0f0) : Color(0xFFf1948a),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(task.name == null ? "" : task.name)),
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
                //Todo: details of task
              },
            )
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
      return Container(
          height: 200,
          color: Color(0xFFE3F2FD),
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(0.0),
          child:
          Expanded(
              child: Column(
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
                      child: currentTasks(),
                    ),
                  ]
              )
          )
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

class Task {
  final String name;
  bool completed;
  DocumentReference reference;

  Task(this.name, {this.completed: false});

  //factory constructor
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(json['code'] as String, completed: json['completed'] as bool);
  }
  //factory constructor
  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    Task newTask = Task.fromJson(snapshot.data);
    newTask.reference = snapshot.reference;
    return newTask;
  }

  Map<String, dynamic> toJson() {
    print("HIT");
    return <String, dynamic> {
      'code': this.name,
      'completed': this.completed,
    };
  }

  toString(){
    return name;
  }
}