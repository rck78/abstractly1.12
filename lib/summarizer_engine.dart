import 'dart:convert';
import 'package:http/http.dart' as http;

class TextSummarizer {
  static Future<String> summarizeText(String inputText, int summarySize) async {
    final headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': '1900073303mshba18e8ea5258f56p160f11jsnd1f52724eaec',
      'X-RapidAPI-Host': 'text-analysis12.p.rapidapi.com',
    };

    final parameters = {
      'language': 'english',
      'summary_percent': summarySize,
      'text': inputText,
    };

    final postData = jsonEncode(parameters);

    final response = await http.post(
      Uri.parse('https://text-analysis12.p.rapidapi.com/summarize-text/api/v1.1'),
      headers: headers,
      body: postData,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final summaryText = responseData['summary'];

      final summaryResponse = jsonDecode(response.body);
      //final summaryText = summaryResponse['summary'];
      return summaryText;
    } else {
      throw Exception('Failed to summarize text: ${response.statusCode}');
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:async';
//
// class TextSummarizer {
//   static final _client = http.Client();
//   static const _baseUrl = 'https://api.openai.com/v1/completions';
//   static const _maxAttempts = 3;
//   static const _retryDelayMilliseconds = 1000;
//   static const _maxTokens = 4096;
//
//   static Future<String> summarizeText(String inputText, int summarySize) async {
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer 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', // Replace with your OpenAI API key
//     };
//
//     final prompt = 'Summarize the following text in $summarySize percent:\n$inputText';
//
//     final requestBody = {
//       'model': 'text-davinci-003',
//       'prompt': prompt,
//       'temperature': 0.7,
//       'max_tokens': _maxTokens,
//       'top_p': 1,
//       'frequency_penalty': 0,
//       'presence_penalty': 0
//     };
//
//     final response = await _makeRequest(headers, jsonEncode(requestBody));
//     final responseData = jsonDecode(response.body);
//
//     if (response.statusCode == 200) {
//       final choices = responseData['choices'] as List<dynamic>;
//       final summaryText = choices.isNotEmpty ? choices[0]['text'].toString().trim() : '';
//
//       // Check if summary exceeds token limit
//       if (summaryText.length > _maxTokens) {
//         final truncatedSummary = summaryText.substring(0, _maxTokens);
//         return _truncateSentence(truncatedSummary);
//       }
//
//       return summaryText;
//     } else {
//       throw Exception('Failed to summarize text: ${responseData['error']}');
//     }
//   }
//
//   static Future<http.Response> _makeRequest(
//       Map<String, String> headers, String body) async {
//     var attempts = 0;
//     while (attempts < _maxAttempts) {
//       try {
//         return await _client.post(Uri.parse(_baseUrl), headers: headers, body: body);
//       } catch (e) {
//         attempts++;
//         await Future.delayed(Duration(milliseconds: _retryDelayMilliseconds));
//       }
//     }
//     throw Exception('Failed to make the API request after $_maxAttempts attempts.');
//   }
//
//   static String _truncateSentence(String text) {
//     final lastPeriodIndex = text.lastIndexOf('.');
//     return lastPeriodIndex >= 0 ? text.substring(0, lastPeriodIndex + 1) : text;
//   }
// }



