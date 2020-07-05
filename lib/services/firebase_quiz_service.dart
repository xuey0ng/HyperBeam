import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseQuizService {
  final String id;
  FirebaseQuizService({@required this.id}) : assert(id != null);


  DataRepo getRepo() {
    return DataRepo.fromRepo("Quizzes");
  }
}