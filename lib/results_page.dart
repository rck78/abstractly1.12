import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'icon_button.dart';
import 'reusable_card.dart';
import 'constants.dart';
import 'translator_page.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'wordcloud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'lang_selector.dart';
import 'pdf_gen.dart';

class ResultsPage extends StatefulWidget {
  final String summary;
  final String detectedLanguage;

  ResultsPage({required this.summary, required this.detectedLanguage});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool isPlaying = false;
  final FlutterTts flutterTts = FlutterTts();
  bool isWordCloudVisible = false;
  bool isSummaryVisible = true;
  String wordCloudImage =
      ''; // Variable to store the generated word cloud image

  String translatedText = ''; // Variable to store the translated text
  String targetLanguage = 'ml'; // Default target language
  String sourceLanguage = 'en'; // Default source language as English

  @override
  void initState() {
    super.initState();
    detectSourceLanguage(); // Detect the source language on page initialization
  }

  void detectSourceLanguage() async {
    String detectedLanguage = widget.detectedLanguage;
    print(detectedLanguage);
    //String detectedLanguage = await detectLanguage(widget.detectedLanguage);
    setState(() {
      sourceLanguage = detectedLanguage;
      print(sourceLanguage);
    });
    translateSummary(); // Translate the summary if the source language is not English
  }

  void translateSummary() async {
    if (sourceLanguage != 'en') {
      translatedText = await Translator.translateText(
        widget.summary,
        'en',
        sourceLanguage,
      );
      setState(() {}); // Update the UI with the translated text
    }
  }

  void translateSummary2() async {
    translatedText = await Translator.translateText(
      widget.summary,
      'en',
      targetLanguage,
    );
    setState(() {}); // Update the UI with the translated text
  }

  void generateWordCloud() async {
    try {
      // Generate the word cloud using the summary
      String generatedImage =
          await WordCloudGenerator.generateWordCloud(widget.summary);

      setState(() {
        wordCloudImage = generatedImage;
      });
    } catch (e) {
      // Handle any errors that occur during word cloud generation
      print('Error generating word cloud: $e');
    }
  }

  void changeTargetLanguage(String language) {
    setState(() {
      targetLanguage = language;
    });
    translateSummary2(); // Translate the summary when the target language is changed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text('Your Summary'),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReusableCard(
                kActiveCard,
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Visibility(
                        visible: isSummaryVisible,
                        child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              translatedText
                                      .isNotEmpty // Display the translated text if available
                                  ? translatedText
                                  : widget.summary,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                      ),
                      Visibility(
                        visible: isWordCloudVisible,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: WordCloudOverlay(image: wordCloudImage),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ReusableCard(
                  // kInactiveCard,
    Color(0xFF0A0D21),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [

                      icon_buttons(
                        icons: Icons.translate,
                        size: 20,
                        onpress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return LanguageSelectionOverlay(
                                currentLanguage: targetLanguage,
                                onLanguageSelected: (String language) {
                                  changeTargetLanguage(language);
                                  //translateSummary();
                                },
                              );
                            },
                          );
                        },
                      ),
                      icon_buttons(
                        icons: isPlaying ? Icons.square : Icons.volume_up,
                        size: 20,
                        onpress: () {
                          if (isPlaying) {
                            setState(() {
                              flutterTts.pause();
                              isPlaying = false;
                            });
                          } else {
                            setState(() {
                              flutterTts.speak(widget.summary);
                              isPlaying = true;
                            });
                          }
                        },
                      ),
                      icon_buttons(
                          icons: Icons.cloud,
                          size: 20,
                          onpress: () {
                            setState(() {
                              isSummaryVisible = !isSummaryVisible;
                              isWordCloudVisible = !isWordCloudVisible;
                            });
                            if (isWordCloudVisible) {
                              generateWordCloud();
                            }
                          },
                      ),

                      icon_buttons(
                        icons: Icons.share,
                        size: 20,
                        onpress: () {
                          Share.share(widget.summary);
                        },
                      ),

                      icon_buttons(icons: Icons.picture_as_pdf_rounded, size: 20,
                      // onpress: code to generate pdf of summary
                        onpress: () {
                        generatePDF(context, 'Summary', widget.summary,);
                        },

                      ),
                      // icon_buttons(
                      //   icons: Icons.copy,
                      //   size: 20,
                      //   onpress: () {
                      //     FlutterClipboard.copy(widget.summary)
                      //         .then((value) => print('copied'));
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Word Cloud Overlay
          // if (isWordCloudVisible)
          //   GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         isWordCloudVisible = false;
          //       });
          //     },
          //     child: Container(
          //       color: Colors.black54,
          //       child: Center(
          //         child: WordCloudOverlay(image: wordCloudImage),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class WordCloudOverlay extends StatelessWidget {
  final String image;

  WordCloudOverlay({required this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: image.isNotEmpty
          ? SvgPicture.string(
        image,
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
      )
          : SizedBox(
              height:
                  12.0), // Or any other widget to display when the SVG string is empty
    );
  }
}
