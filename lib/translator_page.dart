// import 'package:flutter/material.dart';
// import 'reusable_card.dart';
// import 'constants.dart';
// import 'calculate_button.dart';
// import 'translation_engine.dart';
//
// class TranslationPage extends StatefulWidget {
//   final String inputText;
//
//   TranslationPage({required this.inputText});
//
//   @override
//   _TranslationPageState createState() => _TranslationPageState();
// }
//
// class _TranslationPageState extends State<TranslationPage> {
//   final TextEditingController _fromLanguageController = TextEditingController();
//   final TextEditingController _toLanguageController = TextEditingController();
//   String translatedText = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'images/icon1.png', // Path to your custom icon image
//                 width: 24, // Adjust the width as needed
//                 height: 24, // Adjust the height as needed
//               ),
//               SizedBox(width: 5), // Adjust the width as needed
//               Text('Translate Summary'),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ReusableCard(
//                 kActiveCard,
//                 SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         translatedText,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 16.0),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _fromLanguageController,
//               decoration: InputDecoration(
//                 labelText: 'From Language',
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _toLanguageController,
//               decoration: InputDecoration(
//                 labelText: 'To Language',
//               ),
//             ),
//           ),
//           Button('Translate', onTap: () {
//             String fromLanguage = _fromLanguageController.text;
//             String toLanguage = _toLanguageController.text;
//
//             TranslationService()
//                 .translateText(widget.inputText, fromLanguage, toLanguage)
//                 .then((translatedResult) {
//               if (translatedResult != null) {
//                 setState(() {
//                   translatedText = translatedResult.toString();
//                 });
//               }
//             }).catchError((error) {
//               print('Error: $error');
//             });
//           }),
//         ],
//       ),
//     );
//   }
// }
