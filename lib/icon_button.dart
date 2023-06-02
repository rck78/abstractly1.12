import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'reusable_card.dart';
import 'constants.dart';
import 'results_page.dart';
import 'calculate_button.dart';
import 'text_input_field.dart';
import 'summarizer_engine.dart';
import 'package:clipboard/clipboard.dart';
class icon_buttons extends StatefulWidget {
  icon_buttons({this.name = '', required this.icons, required this.size, this.onpress});

  String name; // Make the name parameter nullable
  IconData icons;
  double size;
  dynamic onpress;

  @override
  State<icon_buttons> createState() => _icon_buttonsState();
}

class _icon_buttonsState extends State<icon_buttons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          child: Container(
            child: IconButton(
              style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.blueAccent.shade100),),
              icon: Icon(widget.icons, color: Colors.white),
              iconSize: widget.size,
              onPressed: () {
                setState(() {
                  // Call the callback function if provided
                  if (widget.onpress != null) {
                    widget.onpress();
                  }
                });
              },
            ),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent.shade100),
          ),
        ),
        Text(widget.name),
      ],
    );
  }
}


//
// class icon_buttons extends StatelessWidget {
//   icon_buttons({this.name = '', required this.icons,required this.size,this.onpress});
//
//   String name; // Make the name parameter nullable
//   IconData icons;
//   double size;
//   dynamic onpress;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
//           child: Container(
//             child: IconButton(
//               icon: Icon(icons,color: Colors.white,),
//               iconSize: size,
//               onPressed: (){
//                 setState
//               }
//             ),
//             decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent.shade100,),
//           ),
//         ),
//         Text(name),
//       ],
//     );
//   }
// }
//
