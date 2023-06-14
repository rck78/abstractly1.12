import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

Future<void> generatePDF(
    BuildContext context, String heading, String text) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (heading.isNotEmpty)
              pw.Text(heading, style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 10),
            pw.Text(text),
          ],
        );
      },
    ),
  );

  final directory = await getExternalStorageDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final filePath = '${directory?.path}/example_$timestamp.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Show a dialog with the PDF file path
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('PDF Generated'),
        content: Text('PDF file saved at: $filePath'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await OpenFile.open(filePath, type: 'application/pdf');
            },
            child: Text('View PDF'),
          ),
        ],
      );
    },
  );
}