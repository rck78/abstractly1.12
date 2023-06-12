import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'icon_button.dart';
import 'reusable_card.dart';
import 'constants.dart';
import 'translator_page.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';

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
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                          translatedText.isNotEmpty // Display the translated text if available
                              ? translatedText
                              : widget.summary,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0),
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
                  kInactiveCard,
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      icon_buttons(
                        icons: Icons.share,
                        size: 20,
                        onpress: () {
                          Share.share(widget.summary);
                        },
                      ),
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
                        icons: Icons.copy,
                        size: 20,
                        onpress: () {
                          FlutterClipboard.copy(widget.summary).then((value) => print('copied'));
                        },
                      ),
                      //icon_buttons(icons: Icons.picture_as_pdf, size: 20),
                      //icon_buttons(icons: Icons.image, size: 20),
                      icon_buttons(icons: Icons.cloud, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LanguageSelectionOverlay extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  LanguageSelectionOverlay({
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  final List<String> languages = [
    'ml', // Malayalam
    'es', // Spanish
    'ta', // Tamil
    'en', // English
    // Add more languages here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              languages[index],
              style: TextStyle(
                color: languages[index] == currentLanguage
                    ? Colors.blue // Highlight the selected language
                    : Colors.black,
              ),
            ),
            onTap: () {
              onLanguageSelected(languages[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

// import 'icon_button.dart';
// import 'package:flutter/material.dart';
// import 'reusable_card.dart';
// import 'constants.dart';
// import 'translator_page.dart';
// import 'translation_engine.dart';
// import 'package:clipboard/clipboard.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:share_plus/share_plus.dart';
//
// class ResultsPage extends StatefulWidget {
//   final String summary;
//
//   ResultsPage({required this.summary});
//
//   @override
//   _ResultsPageState createState() => _ResultsPageState();
// }
//
// class _ResultsPageState extends State<ResultsPage> {
//   bool isPlaying = false;
//   final FlutterTts flutterTts = FlutterTts();
//
//   String translatedText = ''; // Variable to store the translated text
//   String targetLanguage = 'ml'; // Default target language
//
//   void translateText() async {
//     translatedText = await Translator.translateText(
//       widget.summary,
//       'en',
//       targetLanguage,
//     );
//     setState(() {}); // Update the UI with the translated text
//   }
//
//   void changeTargetLanguage(String language) {
//     targetLanguage = language;
//   }
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
//                 'images/icon1.png',
//                 width: 24,
//                 height: 24,
//               ),
//               SizedBox(width: 5),
//               Text('Your Summary'),
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
//                       Padding(
//                         padding: const EdgeInsets.all(9.0),
//                         child: Text(
//                           translatedText.isNotEmpty // Display the translated text if available
//                               ? translatedText
//                               : widget.summary,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: ReusableCard(
//                   kInactiveCard,
//                   Wrap(
//                     alignment: WrapAlignment.spaceEvenly,
//                     children: [
//                       icon_buttons(
//                         icons: Icons.share,
//                         size: 20,
//                         onpress: () {
//                           Share.share(widget.summary);
//                         },
//                       ),
//                       icon_buttons(
//                         icons: Icons.translate,
//                         size: 20,
//                         onpress: () {
//                           showModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return LanguageSelectionOverlay(
//                                 currentLanguage: targetLanguage,
//                                 onLanguageSelected: (String language) {
//                                   changeTargetLanguage(language);
//                                   translateText();
//                                 },
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       icon_buttons(
//                         icons: isPlaying ? Icons.square : Icons.volume_up,
//                         size: 20,
//                         onpress: () {
//                           if (isPlaying) {
//                             setState(() {
//                               flutterTts.pause();
//                               isPlaying = false;
//                             });
//                           } else {
//                             setState(() {
//                               flutterTts.speak(widget.summary);
//                               isPlaying = true;
//                             });
//                           }
//                         },
//                       ),
//                       icon_buttons(
//                         icons: Icons.copy,
//                         size: 20,
//                         onpress: () {
//                           FlutterClipboard.copy(widget.summary).then((value) => print('copied'));
//                         },
//                       ),
//                       //icon_buttons(icons: Icons.picture_as_pdf, size: 20),
//                       //icon_buttons(icons: Icons.image, size: 20),
//                       icon_buttons(icons: Icons.cloud, size: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class LanguageSelectionOverlay extends StatelessWidget {
//   final String currentLanguage;
//   final Function(String) onLanguageSelected;
//
//   LanguageSelectionOverlay({
//     required this.currentLanguage,
//     required this.onLanguageSelected,
//   });
//
//   final List<String> languages = [
//     'ml', // Malayalam
//     'es', // Spanish
//     //'fr', // French
//     'ta', // Tamil
//     // Add more languages here
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//         itemCount: languages.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(
//               languages[index],
//               style: TextStyle(
//                 color: languages[index] == currentLanguage
//                     ? Colors.blue // Highlight the selected language
//                     : Colors.black,
//               ),
//             ),
//             onTap: () {
//               onLanguageSelected(languages[index]);
//               Navigator.pop(context);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// // import 'icon_button.dart';
// // import 'package:flutter/material.dart';
// // import 'reusable_card.dart';
// // import 'constants.dart';
// // import 'translator_page.dart';
// // import 'translation_engine.dart';
// // import 'package:clipboard/clipboard.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:share_plus/share_plus.dart';
// //
// // class ResultsPage extends StatefulWidget {
// //   final String summary;
// //
// //   ResultsPage({required this.summary});
// //
// //   @override
// //   _ResultsPageState createState() => _ResultsPageState();
// // }
// //
// // class _ResultsPageState extends State<ResultsPage> {
// //   bool isPlaying = false;
// //   final FlutterTts flutterTts = FlutterTts();
// //
// //   String translatedText = ''; // Variable to store the translated text
// //   String targetLanguage = 'ml'; // Default target language
// //
// //   void translateText() async {
// //     translatedText = await Translator.translateText(
// //       widget.summary,
// //       'en',
// //       targetLanguage,
// //     );
// //     setState(() {}); // Update the UI with the translated text
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Center(
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Image.asset(
// //                 'images/icon1.png',
// //                 width: 24,
// //                 height: 24,
// //               ),
// //               SizedBox(width: 5),
// //               Text('Your Summary'),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: ReusableCard(
// //                 kActiveCard,
// //                 SingleChildScrollView(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.all(9.0),
// //                         child: Text(
// //                           translatedText.isNotEmpty // Display the translated text if available
// //                               ? translatedText
// //                               : widget.summary,
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(fontSize: 20.0),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: ReusableCard(
// //                   kInactiveCard,
// //                   Wrap(
// //                     alignment: WrapAlignment.spaceEvenly,
// //                     children: [
// //                       icon_buttons(
// //                         icons: Icons.share,
// //                         size: 20,
// //                         onpress: () {
// //                           Share.share(widget.summary);
// //                         },
// //                       ),
// //                       icon_buttons(
// //                         icons: Icons.translate,
// //                         size: 20,
// //                         onpress: () {
// //                           translateText(); // Invoke the translation method
// //                         },
// //                       ),
// //                       icon_buttons(
// //                         icons: isPlaying ? Icons.square : Icons.volume_up,
// //                         size: 20,
// //                         onpress: () {
// //                           if (isPlaying) {
// //                             setState(() {
// //                               flutterTts.pause();
// //                               isPlaying = false;
// //                             });
// //                           } else {
// //                             setState(() {
// //                               flutterTts.speak(widget.summary);
// //                               isPlaying = true;
// //                             });
// //                           }
// //                         },
// //                       ),
// //                       icon_buttons(
// //                         icons: Icons.copy,
// //                         size: 20,
// //                         onpress: () {
// //                           FlutterClipboard.copy(widget.summary).then((value) => print('copied'));
// //                         },
// //                       ),
// //                       icon_buttons(icons: Icons.picture_as_pdf, size: 20),
// //                       icon_buttons(icons: Icons.image, size: 20),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // //code2
// // // import 'package:flutter/material.dart';
// // // import 'reusable_card.dart';
// // // import 'constants.dart';
// // // import 'translator_page.dart';
// // // import 'translation_engine.dart';
// // // import 'package:clipboard/clipboard.dart';
// // // import 'package:flutter_tts/flutter_tts.dart';
// // // import 'package:share_plus/share_plus.dart';
// // // import 'icon_button.dart';
// // //
// // // class Results extends StatefulWidget {
// // //   final String summary;
// // //   bool isPlaying = false;
// // //   final FlutterTts flutterTts = FlutterTts();
// // //
// // //   String translatedText = ''; // Variable to store the translated text
// // //   String targetLanguage = 'en'; // Default target language
// // //
// // //   void translateText() async {
// // //     translatedText = await Translator.translateText(
// // //       summary,
// // //       'en',
// // //       targetLanguage,
// // //     );
// // //     setState(() {}); // Update the UI with the translated text
// // //   }
// // //
// // //   Results({required this.summary});
// // //
// // //   @override
// // //   State<Results> createState() => _ResultsState();
// // // }
// // //
// // // class _ResultsState extends State<Results> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Center(
// // //           child: Row(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               Image.asset(
// // //                 'images/icon1.png',
// // //                 width: 24,
// // //                 height: 24,
// // //               ),
// // //               SizedBox(width: 5),
// // //               Text('Your Summary'),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //       body: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.stretch,
// // //         children: [
// // //           Expanded(
// // //             child: Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: ReusableCard(
// // //                 kActiveCard,
// // //                 SingleChildScrollView(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                     children: [
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(9.0),
// // //                         child: Text(
// // //                           widget.translatedText
// // //                                   .isNotEmpty // Display the translated text if available
// // //                               ? widget.translatedText
// // //                               : widget.summary,
// // //                           textAlign: TextAlign.center,
// // //                           style: TextStyle(fontSize: 20.0),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           Row(
// // //             children: [
// // //               Expanded(
// // //                 child: ReusableCard(
// // //                   kInactiveCard,
// // //                   Wrap(
// // //                     alignment: WrapAlignment.spaceEvenly,
// // //                     children: [
// // //                       icon_buttons(
// // //                         icons: Icons.share,
// // //                         size: 20,
// // //                         onpress: () {
// // //                           Share.share(widget.summary);
// // //                         },
// // //                       ),
// // //                       icon_buttons(
// // //                         icons: Icons.translate,
// // //                         size: 20,
// // //                         onpress: () {
// // //                           widget
// // //                               .translateText(); // Invoke the translation method
// // //                         },
// // //                       ),
// // //                       icon_buttons(
// // //                         icons:
// // //                             widget.isPlaying ? Icons.square : Icons.volume_up,
// // //                         size: 20,
// // //                         onpress: () {
// // //                           if (widget.isPlaying) {
// // //                             setState(() {
// // //                               widget.flutterTts.pause();
// // //                               widget.isPlaying = false;
// // //                             });
// // //                           } else {
// // //                             setState(() {
// // //                               widget.flutterTts.speak(widget.summary);
// // //                               widget.isPlaying = true;
// // //                             });
// // //                           }
// // //                         },
// // //                       ),
// // //                       icon_buttons(
// // //                         icons: Icons.copy,
// // //                         size: 20,
// // //                         onpress: () {
// // //                           FlutterClipboard.copy(widget.summary)
// // //                               .then((value) => print('copied'));
// // //                         },
// // //                       ),
// // //                       icon_buttons(icons: Icons.picture_as_pdf, size: 20),
// // //                       icon_buttons(icons: Icons.image, size: 20),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // // import 'package:flutter/material.dart';
// // // import 'reusable_card.dart';
// // // import 'constants.dart';
// // // //import 'calculate_button.dart';
// // // import 'translator_page.dart';// Import the TranslationPage
// // // import 'icon_button.dart';
// // // import 'translation_engine.dart';
// // // // import 'package:translator/translator.dart';
// // // import 'package:clipboard/clipboard.dart';
// // // import 'package:flutter_tts/flutter_tts.dart';
// // // import 'package:share_plus/share_plus.dart';
// // //
// // //
// // // // class ResultPage extends StatelessWidget {
// // // //   final String summary;
// // // //
// // // //   ResultPage({required this.summary});
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Center(
// // // //           child: Row(
// // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // //             children: [
// // // //               Image.asset(
// // // //                 'images/icon1.png',
// // // //                 width: 24,
// // // //                 height: 24,
// // // //               ),
// // // //               SizedBox(width: 5),
// // // //               Text('Your Summary'),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       body: Results(summary: summary),
// // // //     );
// // // //   }
// // // // }
// // //
// // // class Results extends StatefulWidget {
// // //   final String summary;
// // //    bool isPlaying= false;
// // //   final FlutterTts flutterTts = FlutterTts();
// // //
// // //   speak() async {
// // //     await flutterTts.setLanguage("en-US");
// // //     await flutterTts.setPitch(1); // 0.5 - 1
// // //     await flutterTts.speak(summary);// Pass the text you want to speak as an argument
// // //     await flutterTts.setVolume(0.5);
// // //     await flutterTts.pause();
// // //   }
// // //
// // //   // void main() async {
// // //   //   final translator = GoogleTranslator();
// // //   //
// // //   //   final input = summary;
// // //   //
// // //   //   // translator.translate(input, from: 'ru', to: 'en').then(print);
// // //   //   // prints Hello. Are you okay?
// // //   //
// // //   //   var translation = await translator.translate(input, to: 'ml');
// // //   //   print(translation);
// // //   //   // prints Dart jest bardzo fajny!
// // //   //
// // //   //   // print(await "example".translate(to: 'pt'));
// // //   //   // prints exemplo
// // //   // }
// // //
// // //   Results({required this.summary});
// // //
// // //   @override
// // //   State<Results> createState() => _ResultsState();
// // // }
// // //
// // // class _ResultsState extends State<Results> {
// // //
// // //   //GoogleTranslator translator = GoogleTranslator();
// // //   // String input = widget.summary;
// // //
// // //   // void translate(){
// // //   //   translator.translate(widget.summary, to: 'ml');}
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Center(
// // //           child: Row(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               Image.asset(
// // //                 'images/icon1.png',
// // //                 width: 24,
// // //                 height: 24,
// // //               ),
// // //               SizedBox(width: 5),
// // //               Text('Your Summary'),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //       body:Column(
// // //       crossAxisAlignment: CrossAxisAlignment.stretch,
// // //       children: [
// // //         Expanded(
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(8.0),
// // //             child: ReusableCard(
// // //               kActiveCard,
// // //               SingleChildScrollView(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.center,
// // //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                   children: [
// // //                     Padding(
// // //                       padding: const EdgeInsets.all(9.0),
// // //                       child: Text(
// // //                         widget.summary,
// // //                         textAlign: TextAlign.center,
// // //                         style: TextStyle(fontSize: 20.0),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //         Row(
// // //           children: [
// // //             Expanded(
// // //               child: ReusableCard(
// // //                 kInactiveCard,
// // //                 Wrap(
// // //                   alignment: WrapAlignment.spaceEvenly,
// // //                   children: [
// // //                     icon_buttons(icons: Icons.share, size: 20,
// // //                     onpress: (){
// // //                       Share.share(widget.summary);
// // //                     },),
// // //                     icon_buttons(
// // //                       icons: Icons.translate,
// // //                       size: 20,
// // //                       onpress: () {
// // //                           // translate();
// // //                           },
// // //                     ),
// // //                     icon_buttons(icons: widget.isPlaying?Icons.square:Icons.volume_up, size: 20,
// // //                     onpress: (){
// // //                       if(widget.isPlaying){
// // //                         setState(() {
// // //                           widget.flutterTts.pause();
// // //                           widget.isPlaying=false;
// // //                         });
// // //                       }
// // //                       else{
// // //                         setState(() {
// // //                           widget.flutterTts.speak(widget.summary);
// // //                           widget.isPlaying=true;
// // //                         });
// // //                       }
// // //
// // //
// // //                     },),
// // //                     icon_buttons(icons: Icons.copy, size: 20,
// // //                     onpress: (){
// // //                       FlutterClipboard.copy(widget.summary).then(( value ) =>print('copied'));
// // //                     },),
// // //                     icon_buttons(icons: Icons.picture_as_pdf, size: 20),
// // //                     icon_buttons(icons: Icons.image, size: 20),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ],
// // //     ),
// // //     );
// // //   }
// // // }
// // //
