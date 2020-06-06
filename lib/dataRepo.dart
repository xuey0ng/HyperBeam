import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepo {
  CollectionReference db;

  DataRepo(String id, String name) {
    this.db = Firestore.instance.collection('users').document(id).collection(name);
  }

  Stream<QuerySnapshot> getStream() {
    return db.snapshots();
  }
  Future<DocumentReference> addDoc(iDatabaseable obj) {
    return db.add(obj.toJson());
  }
  Future<int> documentCount() async{
    return await db.getDocuments().then((val) => val.documents.length);
  }

  Future<void> delete(DocumentSnapshot doc) async{
    return await db.document(doc.documentID).delete();
  }

  updateDoc(iDatabaseable task) async {
    await db.document(task.reference.documentID).updateData(task.toJson());
  }
}