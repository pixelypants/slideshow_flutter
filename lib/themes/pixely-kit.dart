import 'package:flutter/material.dart';

PixelyKit currentTheme = PixelyKit();

class PixelyKit with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  static Color gradientColorA = Colors.teal.shade600;
  static Color gradientColorB = Colors.purple;
  static Color iconColor = Colors.teal;
  static Color cardBackgroundColor = Colors.white;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;

    gradientColorA = _isDarkTheme ? Colors.purple : Colors.teal.shade600;
    gradientColorB = _isDarkTheme ? Colors.teal.shade600 : Colors.purple;
    iconColor = _isDarkTheme ? Colors.purple : Colors.teal;
    cardBackgroundColor = _isDarkTheme ? Colors.purple.shade200 : Colors.white;

    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.purple,
      accentColor: Colors.purpleAccent,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      // fontFamily: 'Inter',
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        headline2: TextStyle(
          fontSize: 40.0,
          color: Colors.black,
        ),
        bodyText1: TextStyle(
          color: Colors.teal.shade900,
          fontSize: 20.0,
        ),
        bodyText2: TextStyle(
          fontSize: 16.0,
          color: Colors.teal.shade100,
          letterSpacing: 5.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.purple.shade800,
      accentColor: Colors.purple.shade400,
      backgroundColor: Colors.grey,
      scaffoldBackgroundColor: Colors.grey,
      fontFamily: 'Source Sans Pro',
      textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.purple,
            fontSize: 20.0,
          ),
          bodyText2: TextStyle(
            fontSize: 16.0,
            color: Colors.purple.shade300,
            letterSpacing: 5.5,
            fontWeight: FontWeight.bold,
          ),
          headline1: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 40.0,
            color: Colors.purple.shade100,
          )),
    );
  }
}
