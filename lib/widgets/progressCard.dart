import 'package:HyperBeam/progressChart.dart';
import 'package:HyperBeam/quizHandler.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/moduleDetails.dart';
import '../routing_constants.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final int score;
  final int fullScore;
  final List<Quiz> quizList;
  final Size size;
  final List<Task> taskList;
  final Function pressCreateQuiz;
  final Function pressCreateTask;
  final DocumentSnapshot snapshot;

  const ProgressCard({
    Key key,
    this.title,
    this.score,
    this.fullScore,
    this.quizList,
    this.size,
    this.taskList,
    this.pressCreateQuiz,
    this.pressCreateTask,
    this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quizCount = snapshot.data['quizzes'].length;
    int taskCount = snapshot.data['tasks'].length;
    return GestureDetector(
      onTap: () async {
        List<dynamic> taskList = snapshot.data['tasks'];
        List<dynamic> taskSnapList = new List(taskList.length);
        List<dynamic> quizList = snapshot.data['quizzes'];
        List<dynamic> quizSnapList = new List(quizList.length);
        Future<void> getWidget() async {
          for(int i = 0; i< taskList.length; i++) {
            DocumentSnapshot taskSnap = await taskList[i].get();
            taskSnapList[i] = taskSnap;
          }
          for(int i = 0; i < quizList.length; i++){
            DocumentSnapshot quizSnap = await quizList[i].get();
            quizSnapList[i] = quizSnap;
          }
        }
        await getWidget();
        Args arg = new Args(quizList: quizSnapList,
            taskList: taskSnapList,
            moduleSnapshot: snapshot);
        Navigator.pushNamed(
            context,
            ModuleDetailsRoute,
            arguments: arg,
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, bottom: 40, right: 8),
        height: 304,
        width: 0.6*size.width,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                height: 304,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 16,
                      color: kShadowColor,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("WARNING"),
                          content: Text("Delete this module and all of its contents permanently?"),
                          actions: <Widget>[
                            FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                            ),
                            FlatButton(
                                child: Text("Delete"),
                                onPressed: () {
                                  final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                  moduleRepository.delete(snapshot);
                                  Navigator.of(context).pop();
                                }
                            )
                          ],
                        );
                      }
                    );
                  },
                  child: Icon(Icons.brightness_1, color: Colors.red),
              ),
            ),
            Positioned(
              top: 30,
              child: Container(
                width: size.width*0.6,
                height: 274,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: TextStyle(
                                fontSize: kBigText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        )
                      )
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: "Tasks:",
                                        style: TextStyle(
                                          fontSize: kSmallText,
                                        ),
                                      ),
                                    ]
                                )
                            )
                        ),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: Text("$taskCount"),
                        ),
                      ]
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: "Quizzes:", //todo: uncompleted quiz
                                        style: TextStyle(
                                          fontSize: kSmallText,
                                        ),
                                      ),
                                    ]
                                )
                            )
                        ),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: Text("$quizCount"),
                        ),
                      ],
                    ),
                    /*
                    Spacer(),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: "Completed quiz:",
                                        style: TextStyle(
                                          fontSize: kSmallText,
                                        ),
                                      ),
                                    ]
                                )
                            )
                        ),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: Text("$quizCount"),
                        ),
                      ]
                    ),

                     */
                    Spacer(),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: LeftTwoSideRoundedButton(text:"Create task", press: pressCreateTask)
                        ),
                        Expanded(
                            child: RightTwoSideRoundedButton(text:"Create quiz", press: pressCreateQuiz)
                        ),
                      ],
                    )
                  ],
                )
              )
            )
          ],
        ),
      ),
    );
  }
}


class ProgressAdditionCard extends StatefulWidget {
  final Size size;
  const ProgressAdditionCard({
    this.size,
  });

  @override
  State<StatefulWidget> createState() => _ProgressAdditionCardState();
}

class _ProgressAdditionCardState extends State<ProgressAdditionCard> {
  String moduleName;
  final moduleFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return showDialog(
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
                    Spacer(),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                          text: "Add a new module",
                        )
                    ),
                    Spacer(),
                    Form(
                      key: moduleFormKey,
                      autovalidate: true,
                      child: Container(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            TextFormField(
                              autofocus: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter a module name",
                              ),
                              onSaved: (text) {
                                setState(() {
                                  moduleName = text;
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
                                  onPressed: () {
                                    moduleFormKey.currentState.save();
                                    final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                    Module newModule = Module(moduleName, taskList: List(), quizList: List());
                                    Navigator.of(context).pop();
                                    moduleRepository.addDoc(newModule);
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
          },

        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, bottom: 40, right: 8),
        height: 304,
        width: 0.6*widget.size.width,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                child: Center(
                  child: Icon(Icons.add),
                ),
                height: 288,
                decoration: BoxDecoration(
                  color: Color(0x88FFFFFF),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 33,
                      color: kShadowColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightTwoSideRoundedButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function press;
  const RightTwoSideRoundedButton({
    Key key,
    this.text,
    this.radius = 24,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: kAccentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
class LeftTwoSideRoundedButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function press;
  const LeftTwoSideRoundedButton({
    Key key,
    this.text,
    this.radius = 24,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class Args{
  List<dynamic> quizList;
  List<dynamic> taskList;
  DocumentSnapshot moduleSnapshot;

  Args({this.quizList,this.taskList,this.moduleSnapshot});
  @override
  toString() {
    return "${quizList.length} and  ${taskList.length} and ${moduleSnapshot.toString}";
  }
}
