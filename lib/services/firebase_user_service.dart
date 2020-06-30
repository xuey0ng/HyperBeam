import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseUserService {
  final String id;
  FirebaseUserService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo(id, "Quizzes");
  }
}