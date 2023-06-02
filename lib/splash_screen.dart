import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'input_page.dart';
import 'package:page_transition/page_transition.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LimitedBox(
              maxHeight: 200, // Adjust the maximum height as needed
              maxWidth: double.infinity,
              child: Image.asset(
                'images/icon1.png',
              ),
            ),


            // ),
            SizedBox(height: 100),
            Text(
              'Abstractly',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      centered: true,
      splashIconSize: 50,
      nextScreen: InputPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      duration: 3000,
      backgroundColor: Color(0xFF0A0E21),
    );
  }

}



