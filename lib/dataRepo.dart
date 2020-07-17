import 'package:HyperBeam/iDatabaseable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepo {
  CollectionReference db;

  DataRepo.fromRepo(String name){
    this.db = Firestore.instance.collection(name);
  }

  DataRepo.fromChildRepo(String parentColName, String parentDocName,
      String childColName) {
    this.db = Firestore.instance.collection(parentColName).document(childColName)
        .collection(childColName);
  }

  DataRepo.fromInstance(CollectionReference db) {
    this.db = db;
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

  Future<DocumentReference> addDocAndID(iDatabaseable obj) async {
    print("HIT1");
    DocumentReference docRef =  await db.add(obj.toJson());
    print("HIT2");
    Map<String, dynamic> map = {"reference":docRef};
    docRef.setData(map, merge: true);
    return docRef;
  }
  
  Future<DocumentReference> addDocByID(String id, iDatabaseable obj) async {
    await db.document(id).setData(obj.toJson(), merge: true);
  }

  Future<bool> documentExists(String documentID) async {
    return await db.document(documentID).get().then((value){
      if(value.exists) return true;
      return false;
    });
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

  incrementList(String documentID, String field, dynamic newItem) async {
    DocumentSnapshot value = await db.document(documentID).get();
    if (!value.exists) return 0;
    var newList = value.data[field].toList(growable: true);
    newList.add(newItem);
    Map<String, dynamic> map = value.data;
    map[field] = newList;
    db.document(documentID).updateData(map);
    return 1;
  }

  decrementList(String documentID, String field, dynamic deletedItem) async {
    DocumentSnapshot value = await db.document(documentID).get();
    print("IT ISSSS ${value.data[field][0].path}");
    print("THE ITEM TO BE DELETED IS ${deletedItem}");
    print(" THE LENGTH IS ${value.data[field].length}");

    if (!value.exists) return 0;
    List<dynamic> newList = value.data[field].toList(growable: true);
    print(newList);
    print(" IT CONTAINS ${newList.contains(deletedItem)}");
    if(newList.length == 0) return 0;
    if(!newList.remove(deletedItem)) return 0;
    Map<String, dynamic> map = value.data;
    map[field] = newList;
    db.document(documentID).updateData(map);
    return 1;
  }

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