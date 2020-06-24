import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String name;
  List<dynamic> questions;
  List<dynamic> answers;
  Timestamp quizDate;
  String masterPdfUri;
  int score;
  int fullScore;

  @override
  DocumentReference reference;

  Quiz(this.name, {this.questions, this.answers, this.quizDate, this.score, this.masterPdfUri, this.fullScore});

  //factory constructor
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(json['name'] as String,
      questions: json['question'] as List<dynamic>,
      answers: json['answer'] as List<dynamic>,
      quizDate: json['quizDate'] as Timestamp,
      score: json['score'] ?? 0,
      fullScore: json['fullScore'] ?? 0,
      masterPdfUri: json['masterPdfUri'] ??  "",
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
      'quizDate' : this.quizDate,
      'score' : this.score,
      'masterPdfUri' : this.masterPdfUri,
      'fullScore' : this.fullScore,
    };
  }

  toString(){
    return 'Quiz: $name with a score of $score';
  }
}

