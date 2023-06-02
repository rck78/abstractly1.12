import 'package:flutter/material.dart';
import 'constants.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const Button(this.text, {Key? key, required this.onTap}) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.reset();
        _animationController.forward();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color:Colors.pinkAccent),
            margin: EdgeInsets.all(20),
            height: kBottomContainer,
            width: double.infinity,
            child: _animationController.isAnimating
                ? Center(
              child: CircularProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
                : Center(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
