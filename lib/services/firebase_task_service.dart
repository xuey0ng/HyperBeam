import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseTaskService {
  final String id;
  FirebaseTaskService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo(id, "Tasks");
  }
}