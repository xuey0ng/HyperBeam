import 'dart:io';
import 'dart:typed_data';
import 'package:HyperBeam/createQuiz.dart';
import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/pastResultsPage.dart';
import 'package:HyperBeam/pdfViewer.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_reminder_service.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:HyperBeam/attemptQuiz.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_storage_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:HyperBeam/masterPDFFiles.dart';

class ModuleDetails extends StatefulWidget {
  String moduleCode;

  ModuleDetails(this.moduleCode);

  @override
  _ModuleDetailsState createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  var size;
  Module args; //Module>

  Widget buildQuizItem(DocumentReference docRef) { //docRef of a quiz
    return StreamBuilder<DocumentSnapshot> (
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          return QuizCard(snapshot.data, args);
        }
    );
  }

  Widget buildQuizList(DocumentSnapshot modSnapshot) {
    return SingleChildScrollView(
      child: Column(
          children: Module.fromSnapshot(modSnapshot)
              .quizList
              .map((e) => buildQuizItem(e))
              .toList(),
        ),
    );
  }

  Widget _quizList(Module args) {
    return StreamBuilder<DocumentSnapshot> (
        stream: args.reference.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          return buildQuizList(snapshot.data);
        }
    );
  }

  Widget buildTaskItem(DocumentReference docRef) {
    return StreamBuilder<DocumentSnapshot> (
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          return TaskCard(snapshot.data, args);
        }
    );
  }

  Widget buildTaskList(DocumentSnapshot modSnapshot) {
    print(modSnapshot.documentID);
    return SingleChildScrollView(
      child: Column(
        children: Module.fromSnapshot(modSnapshot)
            .taskList
            .map((e) => buildTaskItem(e))
            .toList(),
      ),
    );
  }

  Widget _taskList(Module args) {
    return StreamBuilder<DocumentSnapshot> (
        stream: args.reference.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          return buildTaskList(snapshot.data);
        }
    );
  }

  Widget examInfo(List<SemesterDatum> sems, var size){
    List<Widget> lst = List();
    for (SemesterDatum sem in sems) {
      if (sem.semester != null) {
        lst.add(Text("Semester ${sem.semester} Exam"));
      }
      if (sem.examDate != null){
        lst.add(Text("${DateFormat('yyyy-MM-dd – HH:mm')
            .format(sem.examDate
            )}"));
      }
      lst.add(Text("${sem.examDuration == null ? "TBC" : "${sem.examDuration} mins"}"));
    }
    return Container(
      width: size.width*0.45,
      child: Column(
        children: lst,
      )
    );
  }

  Widget workloadInfo(List<num> loads, var size) {
    int totalWorkload = 0;
    for(int load in loads){
      totalWorkload += load;
    }
    return Container(
      width: size.width*0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Workload - $totalWorkload hrs"),
          Text("Lec:  ${loads[0]} hrs"),
          Text("Tut:  ${loads[1]} hrs"),
          Text("Lab:  ${loads[2]} hrs"),
          Text("Proj: ${loads[3]} hrs"),
          Text("Prep: ${loads[4]} hrs"),
        ],
      )
    );
  }

  Widget preclusionInfo(String preclusion, var size) {
    return Text(
      "Preclusion: $preclusion",
      maxLines: 10,
    );
  }

  Widget suInfo(Attributes attri, var size) {
    if(attri == null) {
      return Text("No information on S/U");
    } else if (attri.su) {
      return Text("SU: allowed");
    } else {
      return Text("SU: not allowed");
    }
  }


  void uploadPDF(BuildContext context) async {
    //-------------------Upload PDF ----------------------
    final firebaseStorageReference = Provider.of<FirebaseStorageService>(context);
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
    final user = Provider.of<User>(context);
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    String getFileName(String path) {
      int lastSlash = 0;
      int lastDot = 0;
      for(int i = 0; i < path.length; i++) {
        if(path.codeUnitAt(i) == 47) lastSlash = i;
        if(path.codeUnitAt(i) == 46) lastDot = i;
      }
      if(lastDot < lastSlash){
        return path.substring(lastSlash+1);
      }
      return path.substring(lastSlash+1, lastDot);
    }// / is 47 , . is 46
    String fileName = getFileName(file.path);
    List<Quiz> quizList = await quizRepository.getCollectionRef()
        .where("uid", isEqualTo: user.id)
        .where("moduleName", isEqualTo: args.moduleCode)
        .getDocuments()
        .then((value) => value.documents.map((e) => Quiz.fromSnapshot(e)).toList());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          List<Widget> widgetList = List();
          bool firstTime = true;
          List<DocumentReference> output = List();
          return AlertDialog(
            title: Text(fileName),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                Widget _buildQuizItem(int i, Quiz quiz, bool checked) {
                  return Row(
                    children: <Widget>[
                      Text(quiz.name),
                      Spacer(),
                      Checkbox(
                        value: checked,
                        onChanged: (bool value) {
                          setState(() {
                            widgetList[i] = _buildQuizItem(i, quiz, !checked);
                            if(!checked) {
                              output.add(quiz.reference);
                            } else {
                              output.remove(quiz.reference);
                            }
                          });
                        },
                      )
                    ],
                  );
                }
                if(firstTime) {
                  for(int i = 0; i < quizList.length; i++){
                    widgetList.add(_buildQuizItem(i, quizList[i], false));
                  }
                  firstTime = false;
                }

                return Column(
                  children: [
                    RaisedButton(
                      child: Text("Preview file"),
                      onPressed: () async {
                        PDFDocument pdfDoc = await PDFDocument.fromFile(file);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfViewer(pdfDoc)
                            )
                        );
                      },
                    ),
                    SizedBox(height: 8,),
                    Text("Select quizzes pertinent to this PDF"),
                    SingleChildScrollView(
                      child: Column(
                        children: widgetList,
                      ),
                    ),
                  ]
                );
              }
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
              FlatButton(
                child: Text("Upload"),
                onPressed: () async {
                  final pdfUri = await firebaseStorageReference.uploadPdf(file: file,
                      modId: args.moduleCode, docId: fileName);
                  print("PDFURL is $pdfUri");
                  DataRepo myFilesRepo = DataRepo.fromInstance(
                      moduleRepository.getCollectionRef()
                          .document(args.moduleCode).collection("myPDFs")
                  );
                  MyPDFUpload pdfFile = MyPDFUpload(
                      name: fileName,
                      uri: pdfUri,
                      lastUpdated: Timestamp.fromDate(DateTime.now()),
                      quizRef: output,
                  );
                  myFilesRepo.addDocByID(fileName, pdfFile);

                  await file.delete();
                  Navigator.of(context).pop();
                }
              )
            ],
          );
        }
    );
  }

  Widget _buildItem(MyPDFUpload pdf) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(pdf.uri)) {
          await launch(pdf.uri);
        } else {
          throw 'Could not launch ${pdf.uri}';
        }
      },
      child: Container(
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
          margin: EdgeInsets.all(8),
          width: size.width,
          //height: size.height*0.16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 8,
                color: Color(0xFFD3D3D3).withOpacity(.88),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: kMediumText, fontWeight: FontWeight.bold),
                      text: " ${pdf.name}",
                    ),
                  ),
                  //Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: kSmallText),
                      text: "Last updated: \n ${DateFormat('dd-MM-yyyy  kk:mm').format(pdf.lastUpdated.toDate())}",
                    ),
                  ),
                ]
            ),
          )
      ),
    );
  }
//page builder
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final modRepo = Provider.of<FirebaseModuleService>(context, listen: false).getRepo();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, HomeRoute);
        return true;
      },
      child: FutureBuilder<DocumentSnapshot>(
        future: modRepo.getCollectionRef().document(widget.moduleCode).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.data == null) return LinearProgressIndicator();
          args = Module.fromSnapshot(snapshot.data);
          return Scaffold(
              body: Stack(
                  children: <Widget> [
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: size.height * .03),
                              height: size.height * .1,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                                  text: " ${args.moduleCode}",
                                ),
                              ),
                            ),
                            Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(text: "${args.title ?? "\n"}", style: TextStyle(fontSize: kBigText,fontWeight: FontWeight.bold, color: Colors.black)),
                                  ),
                                  ExpandChild(
                                    expandArrowStyle: ExpandArrowStyle.icon,
                                    child: Column(
                                      children: <Widget>[
                                        RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                style: Theme.of(context).textTheme.headline5,
                                                children: [
                                                  TextSpan(text: "${args.department ?? ""}\u00B7", style: TextStyle(fontSize: kMediumText)),
                                                  TextSpan(text: "${args.faculty ?? ""}\u00B7", style: TextStyle(fontSize: kMediumText)),
                                                  TextSpan(text: "${args.moduleCredit ?? ""} MCs", style: TextStyle(fontSize: kMediumText))
                                                ]
                                            )
                                        ),
                                        Container(
                                          padding: new EdgeInsets.only(right: 12.0, left: 8),
                                          child: Text(
                                            args.description,
                                            maxLines: 118,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: new Color(0xFF060606),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8,),
                                        Container(
                                          height: size.height*0.18,
                                            padding: new EdgeInsets.only(right: 8.0, left: 8),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: kSecondaryColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  height: size.height*0.18,
                                                  width: size.width*0.5-8,
                                                  child: SingleChildScrollView(child: workloadInfo(args.workload, size)),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  height: size.height*0.18,
                                                  width: size.width*0.5-8,
                                                  child: SingleChildScrollView(child: examInfo(args.semesterData, size)),
                                                )
                                              ],
                                            ),
                                        ),
                                        Container(
                                          height: size.height*0.12,
                                          padding: new EdgeInsets.only(right: 8.0, left: 8),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  height: size.height*0.12,
                                                width: size.width*0.5-8,
                                                child: SingleChildScrollView(child: preclusionInfo(args.preclusion, size))
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: kSecondaryColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                ),
                                                height: size.height*0.12,
                                                width: size.width*0.5-8,
                                                child: SingleChildScrollView(child: suInfo(args.attributes, size)),
                                              )
                                            ],
                                          )
                                        ),

                                      ],
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(left: size.width*0.1),
                              width: size.width * 0.8,
                              child: OutlineButton(
                                splashColor: Colors.grey,
                                onPressed: () async {
                                  await uploadPDF(context);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                highlightElevation: 0,
                                borderSide: BorderSide(color: Colors.grey),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Upload PDF',
                                          style: TextStyle(
                                            fontSize: kMediumText,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(left: size.width*0.1),
                              width: size.width * 0.8,
                              child: OutlineButton(
                                splashColor: Colors.grey,
                                onPressed: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return MasterPDFFiles(module: args);
                                      })
                                  );
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                highlightElevation: 0,
                                borderSide: BorderSide(color: Colors.grey),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'View master PDFs',
                                          style: TextStyle(
                                            fontSize: kMediumText,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(left: size.width*0.1),
                              width: size.width * 0.8,
                              child: OutlineButton(
                                splashColor: Colors.grey,
                                onPressed: () async {
                                  //Loading phase
                                  final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                  final pdfRepo = moduleRepository.getCollectionRef()
                                      .document(args.moduleCode).collection("myPDFs");
                                  List<MyPDFUpload> files = await pdfRepo.getDocuments()
                                      .then((value) => value.documents
                                      .map((e) => MyPDFUpload.fromSnapshot(e)).toList());
                                  List<Widget> widgetList = List();
                                  for(MyPDFUpload pdf in files) {
                                    widgetList.add(_buildItem(pdf));
                                  }
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
                                              child: Column(
                                                  children: [
                                                    SizedBox(height: 8),
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                                        text: "My PDFs",
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: widgetList,
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            )
                                        );
                                      }
                                  );
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                highlightElevation: 0,
                                borderSide: BorderSide(color: Colors.grey),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'My PDFs',
                                          style: TextStyle(
                                            fontSize: kMediumText,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: size.width*0.01),
                              child: Container(
                                  width: size.width*0.98,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 2.0, color: Colors.black)),
                                  ),
                                  child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.headline5,
                                          children: [
                                            TextSpan(text: "Tasks", style: TextStyle(fontWeight: FontWeight.bold, ))
                                          ]
                                      )
                                  )
                              ),
                            ),
                            _taskList(args),
                            Padding(
                              padding: EdgeInsets.only(left: size.width*0.01, top: 8),
                              child: Container(
                                  width: size.width*0.98,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 2.0, color: Colors.black)),
                                  ),
                                  child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.headline5,
                                          children: [
                                            TextSpan(text: "Quizzes", style: TextStyle(fontWeight: FontWeight.bold, ))
                                          ]
                                      )
                                  )
                              ),
                            ),
                            _quizList(args),
                            SizedBox(height: 30),
                          ],
                        )
                    ),
                  ]
              )
          );
        }
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  DocumentSnapshot snapshot;
  Module module;
  TaskCard(this.snapshot, this.module);

  final taskFormKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DateTime newDate;
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        Timestamp currReminder = await Firestore.instance.collection("TaskReminders")
            .document(user.id + module.moduleCode + snapshot.data['name'])
            .get().then((value) => value == null ? Timestamp.now() : value.data["date"]);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              final dialogContext = context;
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(20.0)
                  ),
                  backgroundColor: kSecondaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      height: 152,
                      child: Column(
                        children: <Widget>[
                          RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: kMediumText),
                                text: "Next reminder on: \n${"${DateFormat('dd-MM-yyyy  kk:mm').format(currReminder.toDate())}"}",
                              )
                          ),
                          SizedBox(
                            width: 180,
                            child: RaisedButton(
                              child: Text("Change schedule"),
                              color:  kAccentColor,
                              onPressed: () async  {
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
                                                    key: taskFormKey,
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
                                                                text: "Change reminder to",
                                                              )
                                                          ),
                                                          Spacer(),
                                                          FormBuilderDateTimePicker(
                                                            initialEntryMode: DatePickerEntryMode.calendar,
                                                            initialValue: DateTime.now(),
                                                            attribute: "date",
                                                            inputType: InputType.both,
                                                            decoration: textInputDecoration.copyWith(
                                                                hintText: 'Enter a Date',
                                                                labelText: "Pick a date"),
                                                            onSaved: (text) async {
                                                              newDate = text;
                                                            },
                                                          ),
                                                          Spacer(),
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
                                                                child: Text("Change"),
                                                                color: kAccentColor,
                                                                onPressed: () async {
                                                                  taskFormKey.currentState.save();
                                                                  if(newDate.difference(DateTime.now()).inSeconds < 3520) {
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
                                                                    Map<String,dynamic> map = new Map();
                                                                    map['date'] = newDate;
                                                                    Firestore.instance.collection("TaskReminders")
                                                                        .document(user.id + module.moduleCode + snapshot.data['name'])
                                                                        .setData(map, merge: true);
                                                                    Navigator.pop(context);
                                                                    Navigator.pop(context);
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
                              },
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: RaisedButton(
                              child: Text("Delete"),
                              color:  kAccentColor,
                              onPressed: () async  {
                                final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
                                final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                User user = Provider.of<User>(context);
                                taskRepository.delete(snapshot);
                                await moduleRepository.decrementList(module.moduleCode ,"tasks",snapshot.reference);
                                Firestore.instance.collection("TaskReminders")
                                    .document(user.id+module.moduleCode+snapshot.data['name']).delete();
                                Navigator.pop(dialogContext);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              );
            }
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
        margin: EdgeInsets.all(8),
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 8,
              color: Color(0xFFD3D3D3).withOpacity(.88),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:20, left: 15),
              child: RichText(
                text: TextSpan(
                  text: " ${snapshot.data == null ? "": snapshot.data['name']}\n",
                  style: TextStyle(
                    fontSize: kMediumText,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onPressed: (){},
            )
          ],
        ),
      ),
    );
  }
}
class QuizCard extends StatelessWidget {
  DocumentSnapshot snapshot; //json of quiz
  Module module;
  QuizCard(this.snapshot, this.module);
  void obtainPDF(BuildContext context) async {
    final user = Provider.of<User>(context, listen: false);
    String Url = snapshot.data['masterPdfUri'].toString();
    print("Obtaining $Url}");
    final storageReference = FirebaseStorage.instance.ref()
        .child("/pdf/${user.id}/link.txt");
    Uint8List data =  await storageReference.getData(128)
        .catchError((e) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("File does not exist"),
              content: Text("Please come back in a while"),
              actions: <Widget>[
                FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            );
          }
      );
    }).then((value) => value);
    if(data != null) {
      File file = File.fromRawPath(data);
      final uri = file.uri.toFilePath();
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    final quizFormKey = new GlobalKey<FormState>();
    final quiz = Quiz.fromSnapshot(snapshot);
    final reminderRepository = Provider.of<FirebaseReminderService>(context).getRepo();
    var size = MediaQuery.of(context).size;
    if(snapshot.data == null) return Container();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final dialogContext = context;
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(20.0)
              ),
              backgroundColor: kSecondaryColor,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 180,
                        child: RaisedButton(
                          child: Text("Set reminder"),
                          color:  kAccentColor,
                          onPressed: () async  {
                            DateTime reminderDate;
                            showDialog(
                                context: context,
                              builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                          title: const Text("Schedule a reminder"),
                                          content: Form(
                                              key: quizFormKey,
                                              autovalidate: true,
                                              child: Column(
                                                children: <Widget>[
                                                  FormBuilderDateTimePicker(
                                                    initialEntryMode: DatePickerEntryMode.calendar,
                                                    initialValue: DateTime.now(),
                                                    attribute: "date",
                                                    inputType: InputType.both,
                                                    decoration: textInputDecoration.copyWith(
                                                        hintText: 'Enter a Date',
                                                        labelText: "Pick a date"),
                                                    onSaved: (text) async {
                                                      setState(() {
                                                        reminderDate = text;
                                                      });
                                                    },
                                                  ),
                                                  RaisedButton(
                                                    color: kAccentColor,
                                                    child: Text("Set reminder"),
                                                    onPressed: () {
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
                                                        String documentID = reminderDate.toString() + user.id + quiz.moduleName + quiz.name;
                                                        Reminder rem = Reminder(
                                                            uid: user.id,
                                                            quizName: quiz.name,
                                                            moduleName: quiz.moduleName,
                                                            quizDocRef: quiz.reference,
                                                            date: reminderDate
                                                        );
                                                        reminderRepository.addDocByID(documentID, rem);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  )
                                                ],
                                              )
                                          )
                                      );
                                    }
                                  );
                              }
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: RaisedButton(
                          child: Text("View reminders set"),
                          color:  kAccentColor,
                          onPressed: () async  {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final dialogContext = context;
                                return StreamBuilder<QuerySnapshot> (
                                    stream: Firestore.instance.collection("Reminders")
                                        .where("uid", isEqualTo: user.id)
                                        .where("quizDocRef", isEqualTo: quiz.reference)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return LinearProgressIndicator();
                                      List<Widget> colItems = snapshot.data.documents.map((e){
                                        var timeDisplayed = DateFormat('dd-MM-yyyy  kk:mm').format(e.data['date'].toDate());
                                        return Container(
                                            padding: EdgeInsets.only(top: 0, bottom: 0, left: 8),
                                            margin: EdgeInsets.all(8),
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 4),
                                                  blurRadius: 8,
                                                  color: Color(0xFFD3D3D3).withOpacity(.88),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                  children: [
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(color: Colors.black, fontSize: kMediumText, fontWeight: FontWeight.bold),
                                                        text: " ${timeDisplayed}",
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () async {
                                                        await Firestore.instance.collection("Reminders").document(e.documentID).delete();
                                                      },
                                                    ),
                                                  ]
                                              ),
                                            )
                                        );
                                      }).toList();
                                      return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:  BorderRadius.circular(20.0)
                                          ),
                                          backgroundColor: kSecondaryColor,
                                          child: Column(
                                              children: [
                                                SizedBox(height: 12),
                                                RichText(
                                                  overflow: TextOverflow.fade,
                                                  text: TextSpan(
                                                    text: "Reminders set",
                                                    style: TextStyle(
                                                      fontSize: kBigText,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: colItems,
                                                  ),
                                                ),
                                              ]
                                          )
                                      );
                                    }
                                );
                              }
                            );

                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: RaisedButton(
                          child: Text("View past results"),
                          color:  kAccentColor,
                          onPressed: () async  {
                            Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                              new PastResultsPage(quizSnapshot: snapshot),
                            ));
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: RaisedButton(
                          child: Text("Delete quiz"),
                          color: kAccentColor,
                          onPressed: () async {
                            final user = Provider.of<User>(context);
                            final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
                            //DataRepo reminderRepo = DataRepo.fromInstance(Firestore.instance.collection("Reminders"));
                            final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                            if(snapshot.data["uid"] == user.id) {
                              DocumentSnapshot snap = await quizRepository.getCollectionRef().document(snapshot.documentID).get();
                              List<dynamic> userList = List.from(snap.data["users"]);
                              for(var user in userList){
                                DataRepo repo = DataRepo.fromInstance(Firestore.instance.collection('users').document(user)
                                    .collection("Modules"));
                                await repo.decrementList(module.moduleCode, "quizzes", quiz.reference);
                              }
                              await moduleRepository.decrementList(module.reference.documentID, "quizzes", snapshot.reference);
                              await quizRepository.delete(snapshot);
                            } else {
                              await moduleRepository.decrementList(module.reference.documentID, "quizzes", snapshot.reference);
                              await quizRepository.decrementList(snapshot.documentID, "users", user.id);
                            }
                            Navigator.pop(dialogContext);
                            List<String> lst = await Firestore.instance.collection("Reminders")
                                .where("quizDocRef", isEqualTo: quiz.reference)
                                .getDocuments().then((value) => value.documents.map((e) => e.documentID).toList());
                            for(String docId in lst) {
                              Firestore.instance.collection("Reminders").document(docId).delete();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            );
          }
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        margin: EdgeInsets.all(16),
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(38.5),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 8),
              blurRadius: 8,
              color: Color(0xFFD3D3D3).withOpacity(.84),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:20, left: 15),
              child: Container(
                width: size.width*0.4,
                child: RichText(
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                    text: " ${snapshot.data == null ? "NOTHING" : snapshot.data['name']} \n",
                    style: TextStyle(
                      fontSize: kMediumText,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top:10, right: 15),
              child: RichText(
                overflow: TextOverflow.fade,
                text: TextSpan(
                  text: "Score: \n${snapshot.data['score'] == null ? "Not attempted" :
                  "${snapshot.data['score']} out of ${snapshot.data['fullScore']}"} \n",
                  style: TextStyle(
                    fontSize: kSmallText,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return AttemptQuiz(snapshot: snapshot, module: module);
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Document"),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Offstage()
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton.extended(
            backgroundColor: Colors.red,
            label: Text("Go to ${_currentPage - 1}"),
            onPressed: () {
              _currentPage -= 1;
              _pdfViewController.setPage(_currentPage);
            },
          )
              : Offstage(),
          _currentPage+1 < _totalPages
              ? FloatingActionButton.extended(
            backgroundColor: Colors.green,
            label: Text("Go to ${_currentPage + 1}"),
            onPressed: () {
              _currentPage += 1;
              _pdfViewController.setPage(_currentPage);
            },
          )
              : Offstage(),
        ],
      ),
    );
  }
}