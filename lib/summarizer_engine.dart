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
