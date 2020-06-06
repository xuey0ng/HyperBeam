import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class UploadFile extends StatelessWidget{



  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Upload File"),
      onPressed: () async{
        File file = await FilePicker.getFile(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        StorageReference firebaseStorageReference = FirebaseStorage.instance.ref().child("mypdf");
        final StorageUploadTask task = firebaseStorageReference.putFile(file);
        /*Navigator.push(context,
          MaterialPageRoute(builder: (context){
            //Todo //file preview
          }),
        );*/
      },
    );
  }

}