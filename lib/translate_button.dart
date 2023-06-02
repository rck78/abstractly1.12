import 'package:flutter/material.dart';
import 'constants.dart';

class TranslateButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const TranslateButton({Key? key, required this.child, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        height: kBottomContainer,
        width: double.infinity,
        color: Colors.pinkAccent,
        child: Center(child: child),
      ),
    );
  }
}

