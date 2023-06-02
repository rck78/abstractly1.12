import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'reusable_card.dart';
import 'constants.dart';
//import 'round_icon_button.dart';
import 'results_page.dart';
import 'calculate_button.dart';
//import 'calculator_brain.dart';
import 'summarizer_engine.dart';
import 'package:clipboard/clipboard.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.inputController,
  });

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          border:
          Border.all(color: Colors.pinkAccent,width: 2.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: LimitedBox(
          maxHeight:
          200.0, // Adjust the maximum height as needed
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: TextField(
              controller: inputController,
              maxLines: null,
              cursorColor: kBottomContainerColour,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText:
                'Enter text', // Set the hint text
                hintStyle: TextStyle(
                  color: Colors
                      .grey, // Set the hint text color
                ),
                contentPadding:
                EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical:
                  8.0, // Adjust the padding as needed
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
