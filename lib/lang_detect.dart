import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

Future<String> detectLanguage(String inputText) async {
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  final language = await languageIdentifier.identifyLanguage(inputText);
  languageIdentifier.close();
  return language;
}

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Language Identifier',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Language Identifier'),
//         ),
//         body: LanguageIdentifierForm(),
//       ),
//     );
//   }
// }
//
// class LanguageIdentifierForm extends StatefulWidget {
//   @override
//   _LanguageIdentifierFormState createState() => _LanguageIdentifierFormState();
// }
//
// class _LanguageIdentifierFormState extends State<LanguageIdentifierForm> {
//   final TextEditingController _textController = TextEditingController();
//   String _identifiedLanguage = '';
//
//   void _handleDetectLanguage() async {
//     final inputText = _textController.text;
//     if (inputText.isNotEmpty) {
//       final language = await detectLanguage(inputText);
//       setState(() {
//         _identifiedLanguage = language;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextField(
//             controller: _textController,
//             decoration: InputDecoration(
//               labelText: 'Enter Text',
//             ),
//           ),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: _handleDetectLanguage,
//             child: Text('Detect Language'),
//           ),
//           SizedBox(height: 16.0),
//           Text(
//             'Identified Language: $_identifiedLanguage',
//             style: TextStyle(fontSize: 18.0),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
// import 'package:flutter/material.dart';
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Language Identifier',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LanguageIdentifierPage(),
//     );
//   }
// }
//
// class LanguageIdentifierPage extends StatefulWidget {
//   @override
//   _LanguageIdentifierPageState createState() => _LanguageIdentifierPageState();
// }
//
// class _LanguageIdentifierPageState extends State<LanguageIdentifierPage> {
//   final LanguageIdentifier _languageIdentifier =
//   LanguageIdentifier(confidenceThreshold: 0.5);
//
//   String _inputText = '';
//   String _identifiedLanguage = '';
//
//   void _identifyLanguage() async {
//     if (_inputText.isNotEmpty) {
//       final language = await _languageIdentifier.identifyLanguage(_inputText);
//       setState(() {
//         _identifiedLanguage = language;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _languageIdentifier.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Language Identifier'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   _inputText = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Enter Text',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _identifyLanguage,
//               child: Text('Identify Language'),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Identified Language: $_identifiedLanguage',
//               style: TextStyle(fontSize: 18.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
