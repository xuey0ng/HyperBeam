import 'dart:core';
import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:getflutter/getflutter.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:HyperBeam/widgets/progressCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:HyperBeam/services/firebase_metadata_service.dart';

class ProgressChart extends StatefulWidget {
  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart>{
  @override
  Widget build(BuildContext context) {
    final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
    return StreamBuilder<QuerySnapshot>(
        stream: moduleRepository.getStream(), //stream<QuerySnapshot>
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildList(context, snapshot.data.documents)
          );
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshots) {
    var size = MediaQuery.of(context).size;
    List<Widget> lst = snapshots.map((data) => _buildListItem(context, data, size))
        .toList();
    lst.add(ProgressAdditionCard(size: size));
    return Row(
      children: lst,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot, Size size) {
    Module module = Module.fromSnapshot(snapshot);
    return ProgressCard(
        moduleCode: module.moduleCode,
        title: module.title,
        size: size,
        pressCreateQuiz: () {
          _createQuiz(module);
        },
        pressCreateTask: () {
          _createTask(module);
        },
      snapshot: snapshot,
    );
  }


  Widget _createQuiz(Module module) {
    String quizName;
    final quizFormKey = new GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(20.0)
            ),
            backgroundColor: kSecondaryColor,
            child: Container(
              height: 300,
              child: Column(
                  children: [
                    Form(
                        key: quizFormKey,
                        autovalidate: true,
                        child: Container(
                          height:300,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Spacer(),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                                    text: "Add a new Quiz",
                                  )
                              ),
                              Spacer(),
                              TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter a quiz name",
                                ),
                                onSaved: (text) {
                                  setState(() {
                                    quizName = text;
                                  });
                                },
                              ),
                              SizedBox(height: 80),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                  ),
                                  RaisedButton(
                                    child: Text("Add"),
                                    color: kAccentColor,
                                    onPressed: () async {
                                      quizFormKey.currentState.save();
                                      //Navigator.pushNamed(context, TestRoute);
                                      //Navigator.pushNamed(context, HomeRoute);
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context){
                                          return QuizForm(quizName: quizName, module: module,);
                                        }),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        )
                    ),
                  ]
              ),
            ),
          );
        }
    );
  }

  Widget _createTask(Module module) {
    String taskName;
    final taskFormKey = new GlobalKey<FormState>();
    BuildContext dialogContext;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(20.0)
            ),
            backgroundColor: kSecondaryColor,
            child: Container(
              height: 300,
              child: Column(
                  children: [
                    Form(
                        key: taskFormKey,
                        autovalidate: true,
                        child: Container(
                          height: 300,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Spacer(),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                                    text: "Add a new Task",
                                  )
                              ),
                              Spacer(),
                              TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter a task name",
                                ),
                                onSaved: (text) {
                                  setState(() {
                                    taskName = text;
                                  });
                                },
                              ),
                              SizedBox(height: 80),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                  ),
                                  RaisedButton(
                                    child: Text("Add"),
                                    color: kAccentColor,
                                    onPressed: () async {
                                      Navigator.pop(dialogContext);
                                      taskFormKey.currentState.save();
                                      final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                      final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
                                      Task newTask = Task(taskName);
                                      var newList = module.taskList.toList(growable: true);
                                      DocumentReference docRef;
                                      await taskRepository.addDoc(newTask).then((value) => {
                                        docRef = value,
                                      });
                                      newList.add(docRef);
                                      module.taskList = newList;
                                      moduleRepository.updateDoc(module);
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        )
                    ),
                  ]
              ),
            ),
          );
        }
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