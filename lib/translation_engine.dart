import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//
// class TranslationService {
//   final String url = 'https://rapid-translate-multi-traduction.p.rapidapi.com/t';
//
//   Future<String?> translateText(String text, String fromLanguage, String toLanguage) async {
//     final Map<String, String> headers = {
//       'content-type': 'application/json',
//       'X-RapidAPI-Key': '24d27a04b8msh5189ec1de21cc35p12fb0djsn92a9dde36f7b',
//       'X-RapidAPI-Host': 'rapid-translate-multi-traduction.p.rapidapi.com',
//     };
//
//     final Map<String, dynamic> data = {
//       'from': fromLanguage,
//       'to': toLanguage,
//       'q': text,
//     };
//
//     try {
//       final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = json.decode(response.body);
//         if (responseData.isNotEmpty) {
//           return responseData[0].toString(); // Return the translated text
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//     return null;
//   }
// }
// import 'package:translator/translator.dart';
import 'input_page.dart';
import 'summarizer_engine.dart';
//
// void main() async {
//   final translator = GoogleTranslator();
//
//   final input = summary;
//
//   translator.translate(input, from: 'ru', to: 'en').then(print);
//   // prints Hello. Are you okay?
//
//   var translation = await translator.translate("Dart is very cool!", to: 'pl');
//   print(translation);
//   // prints Dart jest bardzo fajny!
//
//   print(await "example".translate(to: 'pt'));
//   // prints exemplo
// }
// import 'package:translator/translator.dart';
// import 'results_page.dart';
//
// void main() async {
//   final translator = GoogleTranslator();
//   final input = widget.summary;
//
//   // Using the Future API
//   translator
//       .translate(input, to: 'en')
//       .then((result) => print("Source: $input\nTranslated: $result"));
//
//   // Passing the translation to a variable
//   var translation = await translator
//       .translate("I would buy a car, if I had money.", from: 'en', to: 'it');
//
//   // You can also call the extension method directly on the input
//   print('Translated: ${await input.translate(to: 'en')}');
//
//   // For countries that default base URL doesn't work
//   translator.baseUrl = "translate.google.cn";
//   translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn');
//   //prints 这意味着用中文'测试'
//
//   print("translation: $translation");
//   // prints translation: Vorrei comprare una macchina, se avessi i soldi.
// }