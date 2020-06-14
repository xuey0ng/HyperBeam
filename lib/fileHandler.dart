import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class UploadFile extends StatelessWidget{
  final String userId;

  UploadFile(this.userId);

  Widget currentFiles() {
    return Container(
      height: 100,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 200,
          color: Color(0xFFE3F2FD),
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Text("Current files"),
              Expanded(
                child: currentFiles(),
              )
            ],
          )
        ),
        RaisedButton(
          child: Text("Upload File"),
          onPressed: () async{
          File file = await FilePicker.getFile(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        StorageReference firebaseStorageReference = FirebaseStorage.instance
            .ref().child(userId + "/pdf/myPDF");
        final StorageUploadTask task = firebaseStorageReference.putFile(file);
        /*Navigator.push(context,
              MaterialPageRoute(builder: (context){
                //Todo //file preview
              }),
            );*/
        },
        )
      ],
    );
  }
}