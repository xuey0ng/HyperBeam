import 'dart:core';
import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getflutter/getflutter.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:HyperBeam/widgets/progressCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:HyperBeam/services/firebase_metadata_service.dart';
import 'package:intl/intl.dart';


class ProgressChart extends StatefulWidget {
  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart>{
  DateTime reminderDate;

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
                                autovalidate: true,
                                validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
                                onSaved: (text) {
                                  setState(() {
                                    quizName = text;
                                  });
                                },
                              ),
                              Spacer(),
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
                                      if(quizFormKey.currentState.validate()){
                                        quizFormKey.currentState.save();
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return QuizForm(quizName: quizName, module: module,);
                                          }),
                                        );
                                      }
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
              height: 320,
              child: Column(
                  children: [
                    Form(
                        key: taskFormKey,
                        autovalidate: true,
                        child: Container(
                          height: 320,
                          width: 220,
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
                                autovalidate: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter a task name",
                                ),
                                validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
                                onSaved: (text) {
                                  setState(() {
                                    taskName = text;
                                  });
                                },
                              ),
                              SizedBox(height: 24),
                              FormBuilderDateTimePicker(
                                initialEntryMode: DatePickerEntryMode.calendar,
                                initialValue: DateTime.now().add(Duration(hours: 8)),
                                attribute: "date",
                                inputType: InputType.both,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Enter a Date',
                                    labelText: "Pick a date"),
                                onSaved: (text) async {
                                  setState(() {
                                    reminderDate = text.subtract(Duration(hours: 8));
                                  });
                                },
                              ),
                              SizedBox(height: 32),
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
                                      taskFormKey.currentState.validate();
                                      taskFormKey.currentState.save();
                                      if(!taskFormKey.currentState.validate()){

                                      } else if(reminderDate.difference(DateTime.now()).inSeconds < 3520) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              final dialogContext = context;
                                              return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:  BorderRadius.circular(20.0)
                                                  ),
                                                  backgroundColor: kSecondaryColor,
                                                  child: Container(
                                                    height: 320,
                                                    child: Column(
                                                        children: [
                                                          Spacer(),
                                                          RichText(
                                                            textAlign: TextAlign.center,
                                                            text: TextSpan(
                                                              style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                                              text: "Please set reminder to be at least 1 hour later",
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          RaisedButton(
                                                            child: Text("Ok"),
                                                            color: kAccentColor,
                                                            onPressed: () {
                                                              Navigator.pop(dialogContext);
                                                            },
                                                          ),
                                                          Spacer(),
                                                        ]
                                                    ),
                                                  )
                                              );
                                            }
                                        );
                                      } else {
                                        Navigator.pop(dialogContext);
                                        final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                        final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
                                        User user = Provider.of<User>(context);
                                        Map<String, dynamic> map = new Map();
                                        map["date"] = reminderDate;
                                        map["taskName"] = taskName;
                                        map['uid'] = user.id;
                                        map['moduleCode'] = module.moduleCode;
                                        Firestore.instance.collection("TaskReminders").document(user.id+module.moduleCode+taskName).setData(map);
                                        Task newTask = Task(taskName);
                                        var newList = module.taskList.toList(growable: true);
                                        DocumentReference docRef;
                                        await taskRepository.addDoc(newTask).then((value) => {
                                          docRef = value,
                                        });
                                        newList.add(docRef);
                                        module.taskList = newList;
                                        moduleRepository.updateDoc(module);
                                      }
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