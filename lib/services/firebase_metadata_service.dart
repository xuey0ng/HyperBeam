import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseMetadataService {
  final String id;
  FirebaseMetadataService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo(id, "Metadata");
  }
}