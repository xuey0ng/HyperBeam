import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseQuizAttemptService {
  final String id;
  FirebaseQuizAttemptService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo(id, "QuizAttempts");
  }
}