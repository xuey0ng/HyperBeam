import 'package:HyperBeam/objectClasses.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class ModuleQuery extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<String> _loadModulesAsset() async {
      return await rootBundle.loadString('assets/NUS/moduleInfo.json');
    }
    Future loadStudent() async {
      String jsonString = await _loadModulesAsset();
      final jsonResponse = json.decode(jsonString);
      ModulesList module = new ModulesList.fromJson(jsonResponse);
      print(module);
    }

    loadStudent();

    return Scaffold(
      body: Text("SS"),
    );
  }

}