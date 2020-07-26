import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepo {
  CollectionReference db;

  DataRepo.fromRepo(String name){
    this.db = Firestore.instance.collection(name);
  }

  DataRepo(String id, String name) {
    this.db = Firestore.instance.collection('users').document(id).collection(name);
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

<<<<<<< HEAD
  Future<DocumentReference> addDocAndID(iDatabaseable obj) async {
    DocumentReference docRef =  await db.add(obj.toJson());
    Map<String, dynamic> map = {"reference":docRef};
    docRef.setData(map, merge: true);
    return docRef;
  }
  
  Future<DocumentReference> addDocByID(String id, iDatabaseable obj) async {
    await db.document(id).setData(obj.toJson(), merge: true);
=======
  Future<void> setDoc(iDatabaseable obj) async {
    return await db.document(obj.reference.documentID).setData(obj.toJson(), merge: true);
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
  }

  void updateTime(DateTime date) {
    Map<String, dynamic> updates = new Map();
    updates['quizDate'] = Timestamp.fromDate(date);
    db.document("time").updateData(updates);
  }

<<<<<<< HEAD
  Future<void> setDoc(iDatabaseable obj) async {
    return await db.document(obj.reference.documentID)
        .setData(obj.toJson(), merge: true);
  }
  Future<void> setDocByID(String id, Map<String, dynamic> map) async {
    return await db.document(id)
        .setData(map, merge: true);
=======
  void addUncompletedQuizCount() async {
    Map<String, dynamic> updates = new Map();
    DocumentSnapshot snap = await db.document("main").get();
    updates['count'] = snap.data['count'] + 1;
    db.document("main").updateData(updates);
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
  }

  Future<List<DocumentReference>> getRefList() async {
    List<DocumentReference> listRef;
    await db.getDocuments().then((val)=> val.documents.map((x)=> listRef.add(x.reference)));
    return listRef;
  }

<<<<<<< HEAD
  decrementList(String documentID, String field, dynamic deletedItem) async {
    DocumentSnapshot value = await db.document(documentID).get();
    if (!value.exists) return 0;
    List<dynamic> newList = value.data[field].toList(growable: true);
    if(newList.length == 0) return 0;
    if(!newList.remove(deletedItem)) return 0;
    Map<String, dynamic> map = value.data;
    map[field] = newList;
    db.document(documentID).updateData(map);
    return 1;
=======
  Future<int> documentCount() async{
    return await db.getDocuments().then((val) => val.documents.length);
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
  }

  Future<void> delete(DocumentSnapshot doc) async{
    return await db.document(doc.documentID).delete();
  }

  updateDoc(iDatabaseable task) async {
    await db.document(task.reference.documentID).updateData(task.toJson());
  }

}