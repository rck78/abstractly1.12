import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'reusable_card.dart';
import 'constants.dart';
//import 'round_icon_button.dart';
import 'results_page.dart';
import 'calculate_button.dart';
import 'text_input_field.dart';
import 'summarizer_engine.dart';
import 'package:clipboard/clipboard.dart';
import'icon_button.dart';

class InputPage extends StatefulWidget {
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  // final inputController = TextEditingController();
  // String summary='';
  double SliderNum = 40.0;
  String pasteValue = '';
  TextEditingController inputController = TextEditingController();
  bool isTextPasted = false;

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
                'images/icon1.png', // Path to your custom icon image
                width: 24, // Adjust the width as needed
                height: 24, // Adjust the height as needed
              ),
              SizedBox(width: 5), // Adjust the width as needed
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
                      child: Container(
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
                                        // Clear the text
                                        setState(() {
                                          inputController.clear();
                                          isTextPasted = false;
                                        });
                                      } else {
                                        // Paste the text from clipboard
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   textBaseline: TextBaseline.alphabetic,
                            //   crossAxisAlignment: CrossAxisAlignment.baseline,
                            //   children: [
                            //     Text(SliderNum.toString(), style: kNumberStyle),
                            //     Text(
                            //       'percent',
                            //       style: kLabelStyle,
                            //     ),
                            //   ],
                            // ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:Colors.pinkAccent,
                                trackHeight: 5,
                                showValueIndicator: ShowValueIndicator.always,
                                valueIndicatorColor: Colors.purple.shade50,
                                valueIndicatorShape:PaddleSliderValueIndicatorShape(),
                                valueIndicatorTextStyle: TextStyle(color: Colors.black),
                                inactiveTrackColor:Colors.purple.shade50,
                                thumbColor: Colors.pinkAccent,
                                overlayColor: Colors.pinkAccent.withOpacity(0.25),
                              ),
                              child:Slider(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(height: 20.0),
          ReusableCard(
            Color(0xFF0A0E21),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                icon_buttons(name:'Gallery', icons:Icons.image,size: 50,),
                SizedBox(width: 10.0,),
                icon_buttons(name: 'Camera', icons:Icons.camera_alt_outlined,size: 50),
              ],
            ),
          ),
          Button(
            'Summarize',
            onTap: () {
              String inputText = inputController.text;
              int summarySize = SliderNum.round();

              TextSummarizer.summarizeText(inputText, summarySize)
                  .then((summary) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Results(
                     summary: summary,
                    ),
                  ),
                );
              }).catchError((error) {
                print('Error: $error');
              });
            },
          ),
        ],
      ),
      // ),
    );
  }
}
