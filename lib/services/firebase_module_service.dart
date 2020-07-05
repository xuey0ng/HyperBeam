import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class FirebaseModuleService {
  String id;
  ModulesList nusModules;
  FirebaseModuleService({@required id}) {
    assert(id != null);
    this.id = id;
  }
  Future<void> initModulesList() async {
    await loadStudent();
  }

  Future<String> _loadModulesAsset() async {
    return await rootBundle.loadString('assets/NUS/moduleInfo.json');
  }
  Future loadStudent() async {
    String jsonString = await _loadModulesAsset();
    final jsonResponse = json.decode(jsonString);
    nusModules = new ModulesList.fromJson(jsonResponse);
  }


  DataRepo getRepo() {
    return DataRepo(id, "Modules");
  }
}