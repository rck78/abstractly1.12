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
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'text_extractor.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'wordcloud.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'pdf_conversion.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  double sliderNum = 40.0;
  TextEditingController inputController = TextEditingController();
  bool isTextPasted = false;
  bool isImageSelected = false;
  String _wordCloudSvg = '';
  String _conversionResult = '';

  Future<void> selectImageAndRecognizeText() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final text = await extractTextFromImage(pickedImage.path);
      setState(() {
        inputController.text = text;
        isImageSelected = true;
      });
    }
  }

  Future<void> selectPdfAndRecognizeText() async {
    String? convertedText = await PdfConverter.pickAndConvertPdfToText();
    if (convertedText != null) {
      // Handle the converted text
      setState(() {
        inputController.text = convertedText;
        isImageSelected = true;
      });
    } else {
      // Handle conversion failure or no file selected
      print('Conversion failed or no file selected');
    }


    // final imagePicker = ImagePicker();
    // final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    // if (pickedImage != null) {
    //   final text = await extractTextFromImage(pickedImage.path);
    //   setState(() {
    //     inputController.text = text;
    //     isImageSelected = true;
    //   });
    // }
  }

  Future<String> extractTextFromImage(String imagePath) async {
    final text = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'eng', // Specify the language as needed
    );
    return text;
  }


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
    int summarySize = sliderNum.round();
    String detectedLangu = lang;

    TextSummarizer.summarizeText(text, summarySize).then((summary) {
      final userInput = summary;
      generateWordCloud(userInput);
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
  void generateWordCloud(String userInput) async {
    try {
      String wordCloudSvg = await WordCloudGenerator.generateWordCloud(userInput);
      setState(() {
        _wordCloudSvg = wordCloudSvg;
      });
    } catch (e) {
      print('Error generating word cloud: $e');
    }
  }
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
                                      : isTextPasted
                                          ? Icon(Icons.photo_album_outlined)
                                          : Icon(Icons.paste_rounded),
                                  onPressed: () {
                                    if (isTextPasted) {
                                      setState(() {
                                        inputController.clear();
                                        isTextPasted = false;
                                      });
                                    } else if (isImageSelected) {
                                      setState(() {
                                        inputController.clear();
                                        isImageSelected = false;
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
                              value: sliderNum.toDouble(),
                              min: 10.0,
                              max: 100.0,
                              divisions: 9,
                              label: sliderNum.round().toString(),
                              onChanged: (double new_value) {
                                setState(
                                  () {
                                    sliderNum = new_value.roundToDouble();
                                  },
                                );
                              },
                            ),
                          ),
                          Text("Desired Summary Percent"),
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
                icon_buttons(
                  name: 'Summarize from PDF',
                  icons: Icons.picture_as_pdf_outlined,
                  size: 50,
                  onpress: selectPdfAndRecognizeText,
                  // isTextPasted = true,
                ),
                SizedBox(width: 10.0),
                icon_buttons(
                  name: 'Summarize from Image',
                  icons: Icons.photo_album_rounded,
                  size: 50,
                  onpress: selectImageAndRecognizeText,
                    // isTextPasted = true,
                ),
              ],
            ),
          ),
          Button('Summarize', onTap: _processInput),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'reusable_card.dart';
// import 'constants.dart';
// //import 'round_icon_button.dart';
// import 'results_page.dart';
// import 'calculate_button.dart';
// import 'text_input_field.dart';
// import 'summarizer_engine.dart';
// import 'package:clipboard/clipboard.dart';
// import'icon_button.dart';
//
// class InputPage extends StatefulWidget {
//   @override
//   State<InputPage> createState() => _InputPageState();
// }
//
// class _InputPageState extends State<InputPage> {
//   // final inputController = TextEditingController();
//   // String summary='';
//   double SliderNum = 40.0;
//   String pasteValue = '';
//   TextEditingController inputController = TextEditingController();
//   bool isTextPasted = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
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
//               Text('Abstractly'),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ReusableCard(
//                 kActiveCard,
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 TextInput(inputController: inputController),
//                                 Positioned(
//                                   bottom: 20.0,
//                                   right: 8.0,
//                                   child: IconButton(
//                                     color: Colors.purpleAccent,
//                                     icon: isTextPasted
//                                         ? Icon(Icons.close)
//                                         : Icon(Icons.paste_rounded),
//                                     onPressed: () {
//                                       if (isTextPasted) {
//                                         // Clear the text
//                                         setState(() {
//                                           inputController.clear();
//                                           isTextPasted = false;
//                                         });
//                                       } else {
//                                         // Paste the text from clipboard
//                                         FlutterClipboard.paste().then((value) {
//                                           setState(() {
//                                             inputController.text = value;
//                                             isTextPasted = true;
//                                           });
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             SizedBox(height: 30.0),
//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.center,
//                             //   textBaseline: TextBaseline.alphabetic,
//                             //   crossAxisAlignment: CrossAxisAlignment.baseline,
//                             //   children: [
//                             //     Text(SliderNum.toString(), style: kNumberStyle),
//                             //     Text(
//                             //       'percent',
//                             //       style: kLabelStyle,
//                             //     ),
//                             //   ],
//                             // ),
//                             SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 activeTrackColor:Colors.pinkAccent,
//                                 trackHeight: 5,
//                                 showValueIndicator: ShowValueIndicator.always,
//                                 valueIndicatorColor: Colors.purple.shade50,
//                                 valueIndicatorShape:PaddleSliderValueIndicatorShape(),
//                                 valueIndicatorTextStyle: TextStyle(color: Colors.black),
//                                 inactiveTrackColor:Colors.purple.shade50,
//                                 thumbColor: Colors.pinkAccent,
//                                 overlayColor: Colors.pinkAccent.withOpacity(0.25),
//                               ),
//                               child:Slider(
//                                 value: SliderNum.toDouble(),
//                                 min: 10.0,
//                                 max: 100.0,
//                                 label: SliderNum.round().toString(),
//                                 onChanged: (double new_value) {
//                                   setState(
//                                     () {
//                                       SliderNum = new_value.roundToDouble();
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // SizedBox(height: 20.0),
//           ReusableCard(
//             Color(0xFF0A0E21),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children:[
//                 icon_buttons(name:'Gallery', icons:Icons.image,size: 50,),
//                 SizedBox(width: 10.0,),
//                 icon_buttons(name: 'Camera', icons:Icons.camera_alt_outlined,size: 50),
//               ],
//             ),
//           ),
//           Button(
//             'Summarize',
//             onTap: () {
//               String inputText = inputController.text;
//               int summarySize = SliderNum.round();
//
//               TextSummarizer.summarizeText(inputText, summarySize)
//                   .then((summary) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ResultsPage(
//                      summary: summary,
//                     ),
//                   ),
//                 );
//               }).catchError((error) {
//                 print('Error: $error');
//               });
//             },
//           ),
//         ],
//       ),
//       // ),
//     );
//   }
// }
