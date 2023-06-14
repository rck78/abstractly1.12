import 'package:flutter/material.dart';
import'input_page.dart';
import 'splash_screen.dart';

void main() {
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.purple.shade100,
        scaffoldBackgroundColor: const Color(0xFF0A0D21),
        colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFF0A0E21),
            onPrimary: Colors.white,
            secondary: Colors.pinkAccent,
            onSecondary: Colors.white,
            error: Color(0xFF181A1B),
            onError: Colors.white,
            background: Color(0xFF0A0D21),
            onBackground: Colors.white,
            surface: Color(0xFF0A0D21),
            onSurface: Colors.white),

      ),
      home: InputPage(),
      // home: SplashScreen(),
      //
    );
  }
}

