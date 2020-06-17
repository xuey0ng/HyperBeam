import 'dart:io';
import 'package:HyperBeam/services/firebase_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadFile extends StatelessWidget{
  Widget currentFiles() {
    return Container(
      height: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStorageReference = Provider.of<FirebaseStorageService>(context);
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
          final pdfUrl = firebaseStorageReference.uploadPdf(file: file);
          //todo: add reference to firebase
          /*final database = Provider.of<FirestoreService>(context, listen: false);
          await database.setAvatarReference(AvatarReference(downloadUrl));*/
          await file.delete();
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