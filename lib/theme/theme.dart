import 'package:chatapp/theme/apppallet.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.transparentColor]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
      brightness: Brightness.dark,
      primaryColor: AppPallete.primaryColor,
      colorScheme: ColorScheme.dark(
          primary: AppPallete.accentColor,
          secondary: AppPallete.secondaryColor,
          surface: AppPallete.containerColor),
      scaffoldBackgroundColor: AppPallete.primaryColor,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppPallete.progressIndicator // or any other contrasting color
          ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppPallete.textColor),
        centerTitle: true,
        backgroundColor: AppPallete.primaryColor,
      ),
      chipTheme: const ChipThemeData(
        color: WidgetStatePropertyAll(
          AppPallete.backgroundColor,
        ),
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPallete.secondaryColor,
        contentPadding: const EdgeInsets.all(27),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(AppPallete.accentColor),
        errorBorder: _border(AppPallete.errorColor),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPallete.textColor,
          backgroundColor: Colors.transparent, // Background color
          padding: const EdgeInsets.symmetric(
              vertical: 16.0, horizontal: 24.0), // Padding
          textStyle: const TextStyle(
            fontSize: 16.0, // Font size
            fontWeight: FontWeight.bold, // Font weight
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Button border radius
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppPallete.textColor,
        ),
      )));

  static final lightThemeMode = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
    brightness: Brightness.light,
    primaryColor: LightTheme.primaryColor,
    colorScheme: ColorScheme.light(
        primary: LightTheme.accentColor,
        secondary: LightTheme.secondaryColor,
        surface: LightTheme.containerColor),
    scaffoldBackgroundColor: LightTheme.backgroundColor,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: LightTheme.progressIndicator,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: const TextStyle(
        color: LightTheme.textColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: LightTheme.backgroundColor,
      iconTheme: const IconThemeData(color: LightTheme.textColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightTheme.secondaryColor,
      contentPadding: const EdgeInsets.all(27),
      border: _border(LightTheme.primaryColor),
      enabledBorder: _border(),
      focusedBorder: _border(LightTheme.accentColor),
      errorBorder: _border(LightTheme.errorColor),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: LightTheme.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent, // Background color
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 24.0), // Padding
        textStyle: const TextStyle(
          fontSize: 16.0, // Font size
          fontWeight: FontWeight.bold, // Font weight
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Button border radius
        ),
      ),
    ),
  );
}
