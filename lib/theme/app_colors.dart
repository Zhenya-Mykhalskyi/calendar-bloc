import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 141, 80, 188);
  static const Color backgraundColor = Color(0xFF1B1B1B);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color errorColor = Colors.red;
  static const Color cardColor = Color.fromARGB(119, 45, 45, 45);
}

class MyThemes {
  static final darkTheme = ThemeData(
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark(),
    canvasColor: AppColors.backgraundColor,
    scaffoldBackgroundColor: AppColors.backgraundColor,
    appBarTheme: const AppBarTheme(
      color: AppColors.backgraundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        visualDensity: VisualDensity.comfortable,
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.primaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    ),
    cardColor: const Color.fromARGB(255, 46, 46, 46),
  );
}
