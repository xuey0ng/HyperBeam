import 'package:cloud_firestore/cloud_firestore.dart';

//interface for classes that have its values stored in firebase
class iDatabaseable {
  DocumentReference reference;

  Map<String, dynamic> toJson() {}
}