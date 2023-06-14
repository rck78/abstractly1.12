import 'package:flutter/material.dart';

class LanguageSelectionOverlay extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  LanguageSelectionOverlay({
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  final List<String> languages = [
    'ml', // Malayalam
    'hi',
    'ta', // Tamil
    'en', // English
    'mr', 'ar', 'es', 'ja', 'ko',
    // Add more languages here
  ];

  final List<String> languagesName = [
    'Malayalam', // Malayalam
    'Hindi',
    'Tamil', // Tamil
    'English', 'Marathi', 'Arabic', 'Spanish', 'Japanese', 'Korean',
    // Add more languages here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              languagesName[index],
              style: TextStyle(
                color: languages[index] == currentLanguage
                    ? Colors.blue // Highlight the selected language
                    : Colors.black,
              ),
            ),
            onTap: () {
              onLanguageSelected(languages[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
