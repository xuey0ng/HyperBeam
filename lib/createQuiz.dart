import 'package:HyperBeam/homePage.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/services/firebase_reminder_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';

class QuizForm extends StatefulWidget{
  String quizName;
  Module module;
  QuizForm({this.quizName, this.module});

  @override
  State<StatefulWidget> createState() => _QuizFormState();
}

enum FormType{
  MCQ,
  openEnded,
}

class _QuizFormState extends State<QuizForm> {
  final quizFormKey = new GlobalKey<FormState>();
  List<ProblemSet> problemSets = List();
  int questionNumber;
  Quiz newQuiz;
  DateTime reminderDate;
  bool checked = false;
  FormType type = FormType.openEnded;
  int _radioValue1;
  FocusNode f1;
  FocusNode f2;
  FocusNode f3;
  FocusNode f4;
  FocusNode f5;

  ProblemSet newSet = ProblemSet(options: List(4));
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();
  var controller5 = TextEditingController();


  @override
  void initState() {
    super.initState();
    questionNumber = 1;
    f1 = FocusNode();
    f2 = FocusNode();
    f3 = FocusNode();
    f4 = FocusNode();
    f5 = FocusNode();
  }

  Widget Page(int num) {
    newSet.number = num;
    newSet.MCQ = checked;
    return Form(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width:400,
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline3,
                        children: [
                          TextSpan(text: "Question "),
                          TextSpan(text: "$num",
                              style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                        ]
                    )
                ),
                SizedBox(height: 40),
                Row(
                    children: [
                      Text("MCQ"),
                      SizedBox(width: 8),
                      Checkbox(
                          value: checked,
                          onChanged: (bool value) {
                            setState(() {
                              if(!value) {
                                type = FormType.openEnded;
                                checked = false;
                                newSet.MCQ = false;
                              } else {
                                type = FormType.MCQ;
                                checked = true;
                                newSet.MCQ = true;
                              }
                            });
                          }
                      ),
                      Spacer(),
                    ]
                ),
                TextFormField(
                  autofocus: true,
                  focusNode: f1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: num.toString() + '   Enter your question here'
                  ),
                  onChanged: (val){
                    newSet.question = val;
                  },
                  controller: controller1,
                ),
                SizedBox(height: 40),
                if (type == FormType.openEnded) TextFormField(
                  focusNode: f2,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: num.toString() + '   Enter your answer here'
                  ),
                  onChanged: (val) => newSet.answer = val,
                  controller: controller2,
                ) else Column(
                  children: <Widget>[
                    Row(
                        children: [
                          Text("1)"),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              focusNode: f2,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your answer here'
                              ),
                              onChanged: (val){
                                newSet.options[0] = val;
                              } ,
                              controller: controller2,
                            ),
                          ),

                          Radio(
                            value: 0,
                            groupValue: _radioValue1,
                            onChanged: (value){
                              setState(() {
                                _radioValue1 = value;
                                newSet.answer = newSet.options[value];
                              });
                            },
                          )
                        ]
                    ),
                    Row(
                        children: [
                          Text("2)"),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              focusNode: f3,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your answer here'
                              ),
                              onChanged: (val) => newSet.options[1] = val,
                              controller: controller3,
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: _radioValue1,
                            onChanged: (value){
                              setState(() {
                                _radioValue1 = value;
                                newSet.answer = newSet.options[value];
                              });
                            },
                          )
                        ]
                    ),
                    Row(
                        children: [
                          Text("3)"),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              focusNode: f4,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your answer here'
                              ),
                              onChanged: (val) => newSet.options[2] = val,
                              controller: controller4,
                            ),
                          ),
                          Radio(
                            value: 2,
                            groupValue: _radioValue1,
                            onChanged: (value){
                              setState(() {
                                _radioValue1 = value;
                                newSet.answer = newSet.options[value];
                              });
                            },
                          )
                        ]
                    ),
                    Row(
                        children: [
                          Text("4)"),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              focusNode: f5,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your answer here'
                              ),
                              onChanged: (val) => newSet.options[3] = val,
                              controller: controller5,
                            ),
                          ),
                          Radio(
                            value: 3,
                            groupValue: _radioValue1,
                            onChanged: (value){
                              setState(() {
                                _radioValue1 = value;
                                newSet.answer = newSet.options[value];
                              });
                            },
                          )
                        ]
                    ),
                  ],
                )
                ,
                SizedBox(height: 40),
                RaisedButton(
                  color: kSecondaryColor,
                  child: Text("Next Question"),
                  onPressed: () {
                    setState(() {
                      newSet.MCQ = checked;
                      problemSets.add(newSet);
                      questionNumber++;
                      newSet = ProblemSet(
                        number: questionNumber,
                        MCQ: checked,
                        options: List(4),
                      );
                      _radioValue1 = null;
                      controller1.clear();
                      controller2.clear();
                      controller3.clear();
                      controller4.clear();
                      controller5.clear();
                      f1.requestFocus();
                    });
                  },
                ),
              ],
            ),
          ),
        )
    );
  }

  Future<void> validateAndSetQuiz(BuildContext context, bool private) async {
    final user = Provider.of<User>(context, listen: false);
    final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    final reminderRepository = Provider.of<FirebaseReminderService>(context).getRepo();
    quizFormKey.currentState.save();
    if(newSet.question != null && newSet.question != "") {
      problemSets.add(newSet);
      questionNumber++;
    }
    newQuiz = Quiz(
      widget.quizName,
      private: private,
      dateCreated: Timestamp.now(),
      fullScore: questionNumber-1,
      moduleName: widget.module.moduleCode,
      uid: user.id,
      sets: problemSets,
      users: List(),
    );
    DocumentReference docRef;
    await quizRepository.addDocAndID(newQuiz).then((value) => docRef = value);
    await moduleRepository.incrementList(widget.module.reference.documentID, 'quizzes', docRef);
    String documentID = reminderDate.toString() + user.id;
    Reminder rem = Reminder(
        uid: user.id,
        quizName: newQuiz.name,
        moduleName: newQuiz.moduleName,
        quizDocRef: docRef,
        date: reminderDate
    );
    reminderRepository.addDocByID(documentID, rem);
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i < problemSets.length; i++){
      print("curr problemSet is ${problemSets[i]} and $questionNumber");
    }

    return Scaffold(
      body: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg1.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SingleChildScrollView(
                child: Page(questionNumber)
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                bool checked2 = false;
                return AlertDialog(
                    title: const Text("Schedule a reminder"),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState){
                        return Form(
                            key: quizFormKey,
                            autovalidate: true,
                            child: Column(
                              children: <Widget>[
                                FormBuilderDateTimePicker(
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
                                SizedBox(height: 24),
                                Row(
                                  children: [
                                    Text('Private quiz: '),
                                    Checkbox(
                                      value: checked2,
                                      onChanged: (bool value) {
                                        setState(() {
                                          checked2 = !checked2;
                                        });
                                      },
                                    ),
                                  ]
                                ),
                                SizedBox(height: 24),
                                RaisedButton(
                                  color: kAccentColor,
                                  child: Text("Set Quiz"),
                                  onPressed: () async {
                                    quizFormKey.currentState.save();
                                    if(reminderDate.difference(DateTime.now()).inSeconds < 3520) {
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
                                      await validateAndSetQuiz(context, checked2);
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context){
                                          return HomePage();
                                        }),
                                      );
                                    }
                                  },
                                )
                              ],
                            )
                        );
                      }
                    )
                );
              }
          ),
        },
        child: const Icon(Icons.assignment_turned_in),
      ),
    );
  }
}

class CreateQuiz extends StatefulWidget {
  DocumentSnapshot snapshot;
  CreateQuiz({this.snapshot});

  @override
  State<StatefulWidget> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  @override
  Widget build(BuildContext context) {
    QuizDialogWidget dialogWidget = QuizDialogWidget();
    return Scaffold(
      appBar:  AppBar(title: Text("Create Quiz")),
      body:
        AlertDialog(
            title: const Text("Create quiz"),
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
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                    return QuizForm(quizName: dialogWidget.quizName);
                  }),
                );
                }
              )
            ]
          ),
    );
  }
}


const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

class QuizDialogWidget extends StatefulWidget {
  String quizName;

  @override
  _QuizDialogWidgetState createState() => _QuizDialogWidgetState();
}

class _QuizDialogWidgetState extends State<QuizDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter a quiz name",
              ),
              onChanged: (val) => widget.quizName = val,
            ),
          ],
        )
    );
  }
}