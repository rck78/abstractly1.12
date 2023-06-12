import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'AIzaSyDlYuQbsjJSESiKPIKHEAwCoNuaBZQjwio';
const String baseUrl =
    'https://translation.googleapis.com/language/translate/v2';

class Translator {
  static Future<String> translateText(
      String text, String sourceLanguage, String targetLanguage) async {
    if (text.isEmpty) return '';

    // Construct the API request URL
    String requestUrl =
        '$baseUrl?key=$apiKey&source=$sourceLanguage&target=$targetLanguage&q=${Uri.encodeComponent(text)}';

    // Send the API request and receive the response
    http.Response response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      print('Error: ${response.statusCode}');
      return '';
    }
  }
}

//used like this
// void main() async {
//   String inputText = 'Hello, world!';
//   String sourceLanguage = 'en';
//   String targetLanguage = 'fr';
//
//   String translatedText = await Translator.translateText(
//     inputText,
//     sourceLanguage,
//     targetLanguage,
//   );
//
//   print('Translated Text: $translatedText');
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// const String apiKey = 'AIzaSyDlYuQbsjJSESiKPIKHEAwCoNuaBZQjwio';
// const String baseUrl = 'https://translation.googleapis.com/language/translate/v2';
//
// class TranslationApp extends StatefulWidget {
//   @override
//   _TranslationAppState createState() => _TranslationAppState();
// }
//
// class _TranslationAppState extends State<TranslationApp> {
//   TextEditingController _textEditingController = TextEditingController();
//   String _translatedText = '';
//
//   void _translateText() async {
//     String text = _textEditingController.text;
//     if (text.isEmpty) return;
//
//
//     String sourceLanguage = 'ml';
//     String targetLanguage = 'en'; // Target language code, e.g., 'en' for English
//
//     // Construct the API request URL
//     String requestUrl =
//         '$baseUrl?key=$apiKey&source=$sourceLanguage&target=$targetLanguage&q=${Uri
//         .encodeComponent(text)}';
//
//     // Send the API request and receive the response
//     http.Response response = await http.get(Uri.parse(requestUrl));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = jsonDecode(response.body);
//       setState(() {
//         _translatedText = data['data']['translations'][0]['translatedText'];
//       });
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Translation App'),
//         ),
//         body: Column(
//           children: [
//             TextField(
//               controller: _textEditingController,
//               decoration: InputDecoration(
//                 labelText: 'Enter text to translate',
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _translateText,
//               child: Text('Translate'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Translated Text:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(_translatedText),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(TranslationApp());
// }
// //
// //  class translator extends StatefulWidget {
// //    const translator({Key? key}) : super(key: key);
// //
// //    @override
// //    State<translator> createState() => _translatorState();
// //  }
// //
// //  class _translatorState extends State<translator> {
// //    @override
// //    Widget build(BuildContext context) {
// //      return const Placeholder();
// //    }
// //  }
// //
