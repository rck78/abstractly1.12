import 'package:flutter/material.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'reusable_card.dart';
import 'constants.dart';
import 'results_page.dart';
import 'calculate_button.dart';
import 'text_input_field.dart';
import 'summarizer_engine.dart';
import 'translator_page.dart';
import 'package:clipboard/clipboard.dart';
import 'icon_button.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  double SliderNum = 40.0;
  TextEditingController inputController = TextEditingController();
  bool isTextPasted = false;

  void _processInput() async {
    String inputText = inputController.text;

    // Language detection
    String detectedLanguage = await detectLanguage(inputText);

    if (detectedLanguage == 'en') {
      // Input text is in English, proceed with summarization
      _summarizeText(inputText, detectedLanguage);
    } else {
      // Input text is not in English, translate the text to English
      print(inputText);
      String translatedText =
          await Translator.translateText(inputText, detectedLanguage, 'en');
      //print(translatedText);
      _summarizeText(translatedText, detectedLanguage);
    }
  }

  void _summarizeText(String text, String lang) {
    int summarySize = SliderNum.round();
    String detectedLangu = lang;

    TextSummarizer.summarizeText(text, summarySize).then((summary) {
      //print(summary);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            summary: summary,
            detectedLanguage: detectedLangu,
          ),
        ),
      );
    }).catchError((error) {
      //print('Error: $error');
    });
  }

  Future<String> detectLanguage(String inputText) async {
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    final language = await languageIdentifier.identifyLanguage(inputText);
    languageIdentifier.close();
    print(language);
    return language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/icon1.png',
                width: 24,
                height: 24,
              ),
              SizedBox(width: 5),
              Text('Abstractly'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReusableCard(
                kActiveCard,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              TextInput(inputController: inputController),
                              Positioned(
                                bottom: 20.0,
                                right: 8.0,
                                child: IconButton(
                                  color: Colors.purpleAccent,
                                  icon: isTextPasted
                                      ? Icon(Icons.close)
                                      : Icon(Icons.paste_rounded),
                                  onPressed: () {
                                    if (isTextPasted) {
                                      setState(() {
                                        inputController.clear();
                                        isTextPasted = false;
                                      });
                                    } else {
                                      FlutterClipboard.paste().then((value) {
                                        setState(() {
                                          inputController.text = value;
                                          isTextPasted = true;
                                        });
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.pinkAccent,
                              trackHeight: 5,
                              showValueIndicator: ShowValueIndicator.always,
                              valueIndicatorColor: Colors.purple.shade50,
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorTextStyle:
                                  TextStyle(color: Colors.black),
                              inactiveTrackColor: Colors.purple.shade50,
                              thumbColor: Colors.pinkAccent,
                              overlayColor: Colors.pinkAccent.withOpacity(0.25),
                            ),
                            child: Slider(
                              value: SliderNum.toDouble(),
                              min: 10.0,
                              max: 100.0,
                              label: SliderNum.round().toString(),
                              onChanged: (double new_value) {
                                setState(
                                  () {
                                    SliderNum = new_value.roundToDouble();
                                  },
                                );
                              },
                            ),
                          ),
                          Text("Summary Percent"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ReusableCard(
            Color(0xFF0A0E21),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 10.0),
                icon_buttons(
                    name: 'Camera', icons: Icons.camera_alt_outlined, size: 50),
              ],
            ),
          ),
          Button('Summarize', onTap: _processInput),
        ],
      ),
    );
  }
}
