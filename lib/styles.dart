import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  //My Asset
  static const sunIcon = 'assets/sun.png';
  static const moonIcon = 'assets/moon.png';

  //My Color
  static const myBlue = Color.fromRGBO(0, 76, 254, 1);
  static const myBlack = Color.fromRGBO(17, 18, 25, 1);
  static const myLightGrey = Color.fromRGBO(136, 136, 140, 1);
  static const myLightDarkBlue = Color.fromRGBO(74, 88, 117, 1);
  static const myYellow = Color.fromRGBO(254, 170, 26, 1);
  static const myLightOrange = Color.fromRGBO(243, 189, 178, 1);
  static const myDarkOrange = Color.fromRGBO(73, 32, 27, 1);
  static const myOrange = Color.fromRGBO(255, 79, 45, 1);
  static const myLightGreen = Color.fromRGBO(169, 221, 193, 1);
  static const myDarkGreen = Color.fromRGBO(16, 57, 39, 1);
  static const myGreen = Color.fromRGBO(23, 179, 90, 1);

  //Light Theme Configuration
  static const lightTheme = CupertinoThemeData(
      brightness: Brightness.light,
      barBackgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: myLightGrey,
      textTheme: CupertinoTextThemeData(
          primaryColor: Colors.red,
          textStyle: TextStyle(
              color: myBlack,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              overflow: TextOverflow.ellipsis)));

  //Dark Theme Configuration
  static const dartTheme = CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: myBlack,
      scaffoldBackgroundColor: myBlack,
      primaryColor: myLightDarkBlue,
      textTheme: CupertinoTextThemeData(
          primaryColor: Colors.red,
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              overflow: TextOverflow.ellipsis)));
}
