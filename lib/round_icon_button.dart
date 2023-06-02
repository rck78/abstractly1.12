import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton(this.icon,this.press);

  final IconData icon;
  final dynamic press;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(

      fillColor: Color(0xFF444355),
      elevation: 6.0,
      shape: CircleBorder(),
      constraints: BoxConstraints.tightFor(
        width: 56.0, height: 56.0,),
      onPressed: press,
      child: Icon(icon),
    );
  }

}