import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepo {
  CollectionReference db;

  DataRepo.fromRepo(String name){
    this.db = Firestore.instance.collection(name);
  }

  DataRepo.fromInstance(CollectionReference db) {
    this.db = db;
  }

  DataRepo(String id, String name) {
    this.db = Firestore.instance.collection('users').document(id).collection(name);
  }

  test() {

  }

  CollectionReference getCollectionRef() {
    return db;
  }

  Query whereEqual(String field,  String val) {
    return db.where(field, isEqualTo: val);
  }

  Stream<QuerySnapshot> getStream() {
    return db.snapshots();
  }

  Future<QuerySnapshot> getQuery() async {
    return await db.getDocuments();
  }

  Future<DocumentReference> addDoc(iDatabaseable obj) async {
    return await db.add(obj.toJson());
  }

  Future<DocumentReference> addDocByID(String id, iDatabaseable obj) async {
    await db.document(id).setData(obj.toJson(), merge: true);
    return db.document(id);
  }

  Future<void> setDoc(iDatabaseable obj) async {
    return await db.document(obj.reference.documentID)
        .setData(obj.toJson(), merge: true);
  }
  Future<void> setDocByID(String id, Map<String, dynamic> map) async {
    print("Curr map is ${map.toString()}");
    return await db.document(id)
        .setData(map, merge: true);
  }

  incrementList(){}

  decrementList(){}

  Future<void> delete(DocumentSnapshot doc) async{
    return await db.document(doc.documentID).delete();
  }

  updateDoc(iDatabaseable task) async {
    await db.document(task.reference.documentID).updateData(task.toJson());
  }

  Future<int> documentCount() async{
    return await db.getDocuments().then((val) => val.documents.length);
  }
}