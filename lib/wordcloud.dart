import 'package:http/http.dart' as http;

class WordCloudGenerator {
  static Future<String> generateWordCloud(String userInput) async {
    final String apiUrl = 'https://quickchart.io/wordcloud?text=';
    final response =
    await http.get(Uri.parse(apiUrl + Uri.encodeComponent(userInput)));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error generating word cloud: ${response.statusCode}');
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Word Cloud Generator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WordCloudScreen(),
//     );
//   }
// }
//
// class WordCloudScreen extends StatefulWidget {
//   @override
//   _WordCloudScreenState createState() => _WordCloudScreenState();
// }
//
// class _WordCloudScreenState extends State<WordCloudScreen> {
//   final TextEditingController _textInputController = TextEditingController();
//   String _wordCloudSvg = '';
//
//   @override
//   void dispose() {
//     _textInputController.dispose();
//     super.dispose();
//   }
//
//   void generateWordCloud(String userInput) async {
//     final String apiUrl = 'https://quickchart.io/wordcloud?text=';
//     final response =
//         await http.get(Uri.parse(apiUrl + Uri.encodeComponent(userInput)));
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _wordCloudSvg = response.body;
//       });
//     } else {
//       print('Error generating word cloud: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Word Cloud Generator'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _textInputController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Text',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 final userInput = _textInputController.text;
//                 generateWordCloud(userInput);
//               },
//               child: Text('Generate Word Cloud'),
//             ),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: _wordCloudSvg.isNotEmpty
//                   ? SvgPicture.string(
//                       _wordCloudSvg,
//                       fit: BoxFit.contain,
//                     )
//                   : Container(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
