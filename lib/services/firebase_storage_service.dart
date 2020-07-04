import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:HyperBeam/services/firestore_path.dart';

class FirebaseStorageService {
  FirebaseStorageService({@required this.id}) : assert(id != null);
  final String id;

  Future<String> uploadPdf({
    @required File file,
    @required String docId
  }) async =>
      await upload(
        file: file,
        path: FirestorePath.pdf(id,docId) + '.pdf',
        contentType: 'application/pdf',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(
        file);
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    // Url used to download file/image
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }

  Future<void> setAvatarReference(){

  }

}
