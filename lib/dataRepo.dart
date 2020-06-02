import 'package:HyperBeam/progressChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepo {
  final CollectionReference tasksCollection = Firestore.instance.collection('Tasks');

  Stream<QuerySnapshot> getStream() {
    return tasksCollection.snapshots();
  }
  Future<DocumentReference> addTask(Task task) {
    return tasksCollection.add(task.toJson());
  }
  Future<int> documentCount() async{
    return await tasksCollection.getDocuments().then((val) => val.documents.length);
  }

  updatePet(Task task) async {
    await tasksCollection.document(task.reference.documentID).updateData(task.toJson());
  }
}