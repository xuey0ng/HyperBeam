import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepo {
  CollectionReference db;

  DataRepo(String id, String name) {
    this.db = Firestore.instance.collection('users').document(id).collection(name);
  }

  CollectionReference getCollectionRef() {
    return db;
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

  void updateTime(DateTime date) {
    Map<String, dynamic> updates = new Map();
    updates['quizDate'] = Timestamp.fromDate(date);
    db.document("time").updateData(updates);
  }

  void addUncompletedQuizCount() async {
    Map<String, dynamic> updates = new Map();
    DocumentSnapshot snap = await db.document("main").get();
    updates['count'] = snap.data['count'] + 1;
    db.document("main").updateData(updates);
  }

  Future<List<DocumentReference>> getRefList() async {
    List<DocumentReference> listRef;
    await db.getDocuments().then((val)=> val.documents.map((x)=> listRef.add(x.reference)));
    return listRef;
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