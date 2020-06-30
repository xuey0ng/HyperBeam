import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseModuleService {
  final String id;
  FirebaseModuleService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo(id, "Modules");
  }
}