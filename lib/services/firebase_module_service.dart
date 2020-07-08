import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class FirebaseModuleService {
  String id;

  FirebaseModuleService({@required id}) {
    assert(id != null);
    this.id = id;
  }

  DataRepo getRepo() {
    return DataRepo(id, "Modules");
  }
}