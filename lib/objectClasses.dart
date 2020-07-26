import 'package:HyperBeam/attemptQuiz.dart';
import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Module implements iDatabaseable {
  String name;
  List<dynamic> quizList;
  List<dynamic> taskList;
  @override
  DocumentReference reference;

  Module(String name, {List<dynamic> quizList, List<dynamic> taskList}) {
    this.name = name;
    this.quizList = quizList;
    this.taskList= taskList;
  }

  //factory constructor
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(json['name'] as String,
        quizList: json['quizzes'] as List<dynamic>,
        taskList: json['tasks'] as List<dynamic>
    );
  }
  //factory constructor
  factory Module.fromSnapshot(DocumentSnapshot snapshot) {
    Module newModule = Module.fromJson(snapshot.data);
    newModule.reference = snapshot.reference;
    return newModule;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'name': this.name,
      'quizzes': this.quizList,
      'tasks': this.taskList,
    };
  }

  toString() {
    return "$name with a task list of $taskList";
  }
}

class Task implements iDatabaseable {
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

class Quiz implements iDatabaseable {
  bool private;
  String name;
  List<dynamic> questions;
  List<dynamic> answers;
  List<dynamic> attempts;
  Timestamp quizDate;
  String masterPdfUri;
  int score;
  int fullScore;
  String moduleName;
  String uid;

  @override
  DocumentReference reference;

<<<<<<< HEAD
  Quiz(this.name, {
    this.private,
    this.users,
    this.sets,
    this.reviewers,
=======
  Quiz(this.name, {this.questions,
    this.answers,
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
    this.attempts,
    this.quizDate,
    this.score,
    this.masterPdfUri,
    this.fullScore,
    this.moduleName,
    this.uid,
  });

  //factory constructor
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(json['name'] as String,
      questions: json['question'] as List<dynamic>,
      answers: json['answer'] as List<dynamic>,
      attempts: json['attempts'] as List<dynamic>,
      quizDate: json['quizDate'] as Timestamp,
      score: json['score'] ?? 0,
      fullScore: json['fullScore'] ?? 0,
      masterPdfUri: json['masterPdfUri'] ??  "",
      moduleName: json['moduleName'] as String,
      uid: json['uid'] as String,
      private: json['private'],
    );
  }
  //factory constructor
  factory Quiz.fromSnapshot(DocumentSnapshot snapshot) {
    Quiz newQuiz = Quiz.fromJson(snapshot.data);
    newQuiz.reference = snapshot.reference;
    return newQuiz;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'name' : this.name,
      'question': this.questions,
      'answer' : this.answers,
      'attempts' : this.attempts,
      'quizDate' : this.quizDate,
      'score' : this.score,
      'masterPdfUri' : this.masterPdfUri,
      'fullScore' : this.fullScore,
      'moduleName' : this.moduleName,
<<<<<<< HEAD
      'uid' : this.uid,
      'sets' : sets == null ? null : List<dynamic>.from(sets.map((x) => x.toJson())),
      'private' : this.private,
=======
      'uid' : this.uid
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
    };
  }

  toString(){
    return 'Quiz: $name with a score of $score';
  }
}

class QuizAttempt implements iDatabaseable {
  DateTime date;
  List<dynamic> givenAnswers;
  Quiz quiz;
  int score;
  @override
  DocumentReference reference;

  QuizAttempt({this.date,this.givenAnswers,this.quiz,this.score});

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    Quiz quiz = Quiz.fromSnapshot(json['quiz']);
    return QuizAttempt(
      date: json['date'] as DateTime,
      givenAnswers: json['givenAnswers'] as List<dynamic>,
      quiz: quiz,
      score: json['score'] as int,
    );
  }

  Future<QuizAttempt> fromReference(Map<String, dynamic> json) async {
    DocumentSnapshot snap = await json['data'].get();
    return QuizAttempt(
      date: json['date'] as DateTime,
      givenAnswers: json['givenAnswers'] as List<dynamic>,
      quiz: Quiz.fromSnapshot(snap),
      score: json['score'] as int,
    );
  }

  factory QuizAttempt.fromSnapshot(DocumentSnapshot snapshot) {
    QuizAttempt newAttempt = QuizAttempt.fromJson(snapshot.data);
    newAttempt.reference = snapshot.reference;
    return newAttempt;
  }
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'date' : this.date,
      'givenAnswers' : this.givenAnswers,
      'quiz' : this.quiz.reference,
      'score' : this.score,
    };
  }

  toString() {
    return "QuizAttempt: Attempted on $date. $givenAnswers with a score of $score";
  }
}
<<<<<<< HEAD

class ModulesList {
  final List<Module> mods;
  ModulesList({
    this.mods,
  });

  bool containsCode(String moduleCode) {
    for(Module mod in mods) {
      if (mod.moduleCode == moduleCode) return true;
    }
    return false;
  }

  Module getModule(String moduleCode) {
    for(Module mod in mods) {
      if (mod.moduleCode == moduleCode) return mod;
    }
    return null;
  }

  factory ModulesList.fromJson(List<dynamic> parsedJson) {
    List<Module> mods = new List<Module>();
    mods = parsedJson.map((i)=>Module.fromJson(i)).toList();

    return new ModulesList(
      mods: mods,
    );
  }
}

class Module extends iDatabaseable{
  Module({
    this.moduleCode,
    this.title,
    this.quizList,
    this.taskList,
    this.description,
    this.moduleCredit,
    this.department,
    this.faculty,
    this.workload,
    this.preclusion,
    this.attributes,
    this.semesterData,
    this.pdfFiles,
    this.reference,
  });

  String moduleCode;
  String title;
  List<dynamic> quizList;
  List<dynamic> taskList;
  String description;
  String moduleCredit;
  String department;
  String faculty;
  List<num> workload;
  String preclusion;
  Attributes attributes;
  List<SemesterDatum> semesterData;
  String pdfFiles;
  DocumentReference reference;

  factory Module.fromJson(Map<String, dynamic> json) => json == null ? null : Module(
    moduleCode: json["moduleCode"] ?? "Unknown",
    title: json["title"] ?? "Unknown",
    quizList: json["quizzes"] ?? List<dynamic>(),
    taskList: json['tasks'] ?? List<dynamic>(),
    description: json["description"] ?? "Unknown",
    moduleCredit: json["moduleCredit"] ?? "Unknown",
    department: json["department"] ?? "Unknown",
    faculty: json["faculty"] ?? "Unknown",
    workload: json["workload"]== null ? List<num>(): json["workload"] is String ? List<num>() : List<num>.from(json["workload"].map((x) => x)),
    preclusion: json["preclusion"] ?? "No preclusion",
    attributes: json["attributes"] == null ? null : Attributes.fromJson(Map<String, dynamic>.from(json["attributes"])),
    semesterData: json["semesterData"] == null ? List() : List<SemesterDatum>
        .from(json["semesterData"]
        .map((x)=>SemesterDatum.fromJson(Map<String,dynamic>.from(x)))),
    pdfFiles: json["pdfFile"],
  );

  factory Module.fromSnapshot(DocumentSnapshot snapshot) {
    if(snapshot == null) return null;
    Module newModule = Module.fromJson(snapshot.data);
    newModule.reference = snapshot.reference;
    return newModule;
  }

  Map<String, dynamic> toJson() => {
    "moduleCode": moduleCode,
    "title": title,
    "quizzes": this.quizList,
    "tasks": this.taskList,
    "description": description,
    "moduleCredit": moduleCredit,
    "department": department,
    "faculty": faculty,
    "workload": workload ==null ? null : List<dynamic>.from(workload.map((x) => x)),
    "preclusion": preclusion,
    "attributes": attributes == null ? null : attributes.toJson(),
    "pdfFile" : pdfFiles,
    "semesterData": workload == null ? null : List<dynamic>
        .from(semesterData.map((x) => x.toJson())),
  };

  toString() {
    return "$title with a task list of $taskList";
  }
}

class Attributes {
  Attributes({this.su,});
  bool su;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    su: json["su"],
  );

  Map<String, dynamic> toJson() => {
    "su": su,
  };
}

class SemesterDatum {
  SemesterDatum({
    this.semester,
    this.examDate,
    this.examDuration,
  });

  int semester;
  DateTime examDate;
  int examDuration;

  factory SemesterDatum.fromJson(Map<String, dynamic> json) => SemesterDatum(
    semester: json["semester"],
    examDate: json["examDate"]==null? null : DateTime.parse(json["examDate"]),
    examDuration: json["examDuration"],
  );

  Map<String, dynamic> toJson() => {
    "semester": semester,
    "examDate": examDate == null ? null : examDate.toIso8601String(),
    "examDuration": examDuration,
  };
}

class MyPDFUpload extends iDatabaseable{
  String name;
  String uri;
  Timestamp lastUpdated;
  List<dynamic> quizRef;
  DocumentReference reference;

  MyPDFUpload({
    this.name,
    this.uri,
    this.lastUpdated,
    this.quizRef,
});

  factory MyPDFUpload.fromJson(Map<String, dynamic> json) => MyPDFUpload(
    name: json['name'],
    uri: json['uri'],
    lastUpdated: json['lastUpdated'],
    quizRef: json['quizRef'],
  );

  factory MyPDFUpload.fromSnapshot(DocumentSnapshot snapshot) {
    MyPDFUpload newAttempt = MyPDFUpload.fromJson(snapshot.data);
    newAttempt.reference = snapshot.reference;
    return newAttempt;
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "uri": uri,
    "lastUpdated": lastUpdated,
    "quizRef": quizRef,
  };
}
=======
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
