import 'package:HyperBeam/dataRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseMasterPDFService {
  //final String id;
  //FirebaseMasterPDFService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo.fromRepo("MasterPDFs");
  }

  DataRepo getRepoByMod(String moduleCode) {
    return DataRepo.fromInstance(
      Firestore.instance.collection("MasterPDFMods").document(moduleCode)
          .collection("PDFs")
    );
  }
}