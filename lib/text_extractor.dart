import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Extraction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextExtractionPage(),
    );
  }
}

class TextExtractionPage extends StatefulWidget {
  @override
  _TextExtractionPageState createState() => _TextExtractionPageState();
}

class _TextExtractionPageState extends State<TextExtractionPage> {
  File? _selectedImage;
  String _extractedText = '';
  bool _isImageLoaded = false;

  // Supported languages
  final List<String> supportedLanguages = [
    'eng', // English
    'mal', // Malayalam
    // Add more languages as needed
  ];

  String selectedLanguage = 'eng'; // Default language

  Future _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _isImageLoaded = true;
        _extractedText = '';
      });
    }
  }

  Future<String> _extractText() async {
    if (_selectedImage == null) return '';

    final text = await FlutterTesseractOcr.extractText(
      _selectedImage!.path,
      language: selectedLanguage,
    );

    return text;
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          selectedLanguage = newValue!;
        });
      },
      items: supportedLanguages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Extraction App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isImageLoaded
                ? Image.file(
              _selectedImage!,
              height: 200,
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choose Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final text = await _extractText();
                setState(() {
                  _extractedText = text;
                });
              },
              child: Text('Extract Text'),
            ),
            SizedBox(height: 20),
            Text(
              'Select Language:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildLanguageDropdown(),
            SizedBox(height: 20),
            Text(
              'Extracted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _extractedText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}