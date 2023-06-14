import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class PdfConverter {
  static Future<String?> pickAndConvertPdfToText() async {
    final url = 'https://pdf-to-text-converter.p.rapidapi.com/api/pdf-to-text/convert';
    final apiKey = '24d27a04b8msh5189ec1de21cc35p12fb0djsn92a9dde36f7b';
    final apiHost = 'pdf-to-text-converter.p.rapidapi.com';

    try {
      // Allow the user to pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        // Get the PDF file path
        final pdfFile = File(result.files.single.path!);

        // Create a multipart request
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['X-RapidAPI-Key'] = apiKey;
        request.headers['X-RapidAPI-Host'] = apiHost;
        request.files.add(await http.MultipartFile.fromPath('file', pdfFile.path));
        request.fields['page'] = '1';

        // Send the request
        final response = await http.Response.fromStream(await request.send());

        // Process the response
        if (response.statusCode == 200) {
          return response.body;
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } else {
        print('No file selected');
      }
    } catch (error) {
      print('Error picking file: $error');
    }

    return null;
  }
}
