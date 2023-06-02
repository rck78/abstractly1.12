import 'package:flutter/material.dart';
import 'reusable_card.dart';
import 'constants.dart';
import 'calculate_button.dart';
import 'translator_page.dart';// Import the TranslationPage
import 'icon_button.dart';
import 'translation_engine.dart';
import 'package:translator/translator.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';


// class ResultPage extends StatelessWidget {
//   final String summary;
//
//   ResultPage({required this.summary});
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
//       body: Results(summary: summary),
//     );
//   }
// }

class Results extends StatefulWidget {
  final String summary;
   bool isPlaying= false;
  final FlutterTts flutterTts = FlutterTts();

  speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); // 0.5 - 1
    await flutterTts.speak(summary);// Pass the text you want to speak as an argument
    await flutterTts.setVolume(0.5);
    await flutterTts.pause();
  }

  // void main() async {
  //   final translator = GoogleTranslator();
  //
  //   final input = summary;
  //
  //   // translator.translate(input, from: 'ru', to: 'en').then(print);
  //   // prints Hello. Are you okay?
  //
  //   var translation = await translator.translate(input, to: 'ml');
  //   print(translation);
  //   // prints Dart jest bardzo fajny!
  //
  //   // print(await "example".translate(to: 'pt'));
  //   // prints exemplo
  // }

  Results({required this.summary});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  GoogleTranslator translator = GoogleTranslator();
  // String input = widget.summary;

  void translate(){
    translator.translate(widget.summary, to: 'ml');
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
      body:Column(
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
                        widget.summary,
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
                    icon_buttons(icons: Icons.share, size: 20,
                    onpress: (){
                      Share.share(widget.summary);
                    },),
                    icon_buttons(
                      icons: Icons.translate,
                      size: 20,
                      onpress: () {
                          translate();
                      },
                    ),
                    icon_buttons(icons: widget.isPlaying?Icons.square:Icons.volume_up, size: 20,
                    onpress: (){
                      if(widget.isPlaying){
                        setState(() {
                          widget.flutterTts.pause();
                          widget.isPlaying=false;
                        });
                      }
                      else{
                        setState(() {
                          widget.flutterTts.speak(widget.summary);
                          widget.isPlaying=true;
                        });
                      }


                    },),
                    icon_buttons(icons: Icons.copy, size: 20,
                    onpress: (){
                      FlutterClipboard.copy(widget.summary).then(( value ) =>print('copied'));
                    },),
                    icon_buttons(icons: Icons.picture_as_pdf, size: 20),
                    icon_buttons(icons: Icons.image, size: 20),
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

