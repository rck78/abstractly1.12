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
        scaffoldBackgroundColor: Colors.purple.shade100,
        // colorScheme: ColorScheme(
        //     brightness: Brightness.light,
        //     primary: Color(0xFFFFFFFF),
        //     onPrimary: Colors.white,
        //     secondary: Colors.pinkAccent,
        //     onSecondary: Colors.white,
        //     error: Color(0xFF181A1B),
        //     onError: Colors.white,
        //     background: Color(0xFF0A0D21),
        //     onBackground: Colors.white,
        //     surface: Color(0xFF0A0D21),
        //     onSurface: Colors.white),
        // textTheme: TextTheme(
        //   bodyLarge: TextStyle(color: Colors.white),
        // ),
      ),
      // home: SplashScreen(),
      home: InputPage(),
    );
  }
}

