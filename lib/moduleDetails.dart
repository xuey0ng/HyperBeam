import 'dart:io';
import 'dart:typed_data';
import 'package:HyperBeam/homePage.dart';
import 'package:HyperBeam/pastResultsPage.dart';
import 'package:HyperBeam/pdfViewer.dart';
import 'package:HyperBeam/routing_constants.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_task_service.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:HyperBeam/attemptQuiz.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/services/firebase_storage_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
class ModuleDetails extends StatefulWidget {
  @override
  _ModuleDetailsState createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  var size;
  Module args; //Module

  Widget buildQuizItem(DocumentReference docRef) {
    return StreamBuilder<DocumentSnapshot> (
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          print("NOW IT IS ${snapshot.data.documentID} , ${args}");
          return QuizCard(snapshot.data, args);
        }
    );
  }


  Widget buildQuizList(DocumentSnapshot modSnapshot) {
    print(modSnapshot.documentID);
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
        print("HIT");
        lst.add(Text("Semester ${sem.semester} Exam"));
      }
      if (sem.examDate != null){
        lst.add(Text("${DateFormat('yyyy-MM-dd – HH:mm').format(sem.examDate.add(Duration(hours: 8)))}"));
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
    return Container(
        width: size.width*0.45,
        child: Text(
          "Preclusion: $preclusion",
          maxLines: 10,
        )
    );
  }

  Widget suInfo(Attributes attri, var size) {
    Widget child() {
      if(attri == null) {
        return Text("No infomation on S/U");
      } else if (attri.su) {
        return Text("SU: allowed");
      } else {
        return Text("SU: not allowed");
      }
    }

    return Container(
      width: size.width*0.45,
      child: child(),
    );

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    args = ModalRoute.of(context).settings.arguments; //Module
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, HomeRoute);
        return true;
      },
      child: Scaffold(
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
                                        color: new Color(0xFFA0A0A0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: new EdgeInsets.only(right: 12.0, left: 8),
                                    child: Row(
                                      children: <Widget>[
                                        workloadInfo(args.workload, size),
                                        examInfo(args.semesterData, size)
                                      ],
                                    )
                                  ),
                                  Container(
                                      padding: new EdgeInsets.only(right: 12.0, left: 8),
                                      child: Row(
                                        children: <Widget>[
                                          preclusionInfo(args.preclusion, size),
                                          suInfo(args.attributes, size),
                                        ],
                                      )
                                  ),

                                ],
                              ),
                            ),
                          ]
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
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  DocumentSnapshot snapshot;
  Module module;
  TaskCard(this.snapshot, this.module);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                      height: 120,
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            child: Text("Delete"),
                            color:  kPrimaryColor,
                            onPressed: () async  {
                              final taskRepository = Provider.of<FirebaseTaskService>(context).getRepo();
                              final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                              taskRepository.delete(snapshot);
                              Module mod = module;
                              var newList = new List<DocumentReference>.from(mod.taskList);
                              newList.remove(snapshot.reference);
                              mod.taskList = newList;
                              moduleRepository.updateDoc(mod);
                              Navigator.pop(dialogContext);
                            },
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
                  text: " ${snapshot.data['name']}\n",
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
  DocumentSnapshot snapshot;
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

  void uploadPDF(BuildContext context) async {
    final firebaseStorageReference = Provider.of<FirebaseStorageService>(context);
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    final pdfUrl = await firebaseStorageReference.uploadPdf(file: file,
        docId: snapshot.documentID); //docID is quit id
    print("PDFURL is $pdfUrl");
    snapshot.data['masterPdfUri'] = pdfUrl;
    await quizRepository.updateDoc(Quiz.fromSnapshot(snapshot));
    await file.delete();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                          child: Text("Obtain Master PDF"),
                          color:  kAccentColor,
                          onPressed: () async {
                            obtainPDF(context);
                          }
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
                          child: Text("Upload PDF file"),
                          color: kAccentColor,
                          onPressed: () async {
                            uploadPDF(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: RaisedButton(
                          child: Text("Delete quiz"),
                          color: kAccentColor,
                          onPressed: () async {
                            final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
                            final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                            quizRepository.delete(snapshot);
                            print(module);
                            Module mod = module;
                            var newList = new List<DocumentReference>.from(mod.quizList);
                            newList.remove(snapshot.reference);
                            mod.quizList = newList;
                            moduleRepository.updateDoc(mod);
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
                    text: " ${snapshot.data == null ? "NOTHING":snapshot.data['name']} \n",
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
                  text: "Score: \n${snapshot.data['score'] == null ? "Not attempted" : "${snapshot.data['score']} out of ${snapshot.data['fullScore']}"} \n",
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
              onPressed: (){
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
    print("THIS PATH IS ${widget.path}");
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