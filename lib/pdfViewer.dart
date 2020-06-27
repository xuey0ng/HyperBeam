import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewer extends StatelessWidget {
  PDFDocument doc;
  PdfViewer(this.doc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document'),
      ),
      body: Center(
          child: PDFViewer(document: doc)
      ),

      /*
            body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: doc)),

       */
    );
  }
}