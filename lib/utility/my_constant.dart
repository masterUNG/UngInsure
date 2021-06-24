import 'package:flutter/material.dart';

class MyConstant {
  // General
  static String appName = 'Ung Insure';
  static String domain = 'https://ea1438038cff.ngrok.io';

  // Route
  static String routeListInsure = '/listInsure';
  static String routeCheckPin = '/checkPin';

  // Color
  static Color primary = Color(0xff274486);
  static Color dark = Color(0xff001e58);
  static Color light = Color(0xff5b6fb6);

  // Style
  BoxDecoration myBoxDecoration() => BoxDecoration(
        gradient: RadialGradient(
            colors: [MyConstant.light, MyConstant.dark],
            radius: 0.7,
            center: Alignment(0, -0.3)),
      );
}
