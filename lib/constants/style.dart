import 'package:flutter/material.dart';

class AppText {
  static const TextStyle h1 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 44 / 34,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 34 / 24,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 30 / 20,
  );
  static const TextStyle one = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 26 / 16,
  );
  static const TextStyle two = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 26 / 16,
  );
  static const TextStyle three = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 24 / 14,
  );
  static const TextStyle four = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 20 / 12,
  );
}

class AppColor {
  static const Color main = Color(0xFF2BB368);

  static const Color black = Color(0xFF252525);
  static const Color gray = Color(0xFF9E9B9B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFE21A1A);

  static const Color bgBlack = Color(0xFF252627);
  static const Color bgGray = Color(0xFFF5F5F5);
  static const Color bgGreen = Color(0xFFF3FFF7);

  static const Color lineGray = Color(0xFFDCDCDC);
}

class AppShadow {
  static const BoxShadow one = BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 2),
    blurRadius: 10,
    spreadRadius: 0,
  );

  static const BoxShadow two = BoxShadow(
    color: Color(0x40000000),
    offset: Offset(0, 4),
    blurRadius: 4,
    spreadRadius: 0,
  );

  static const BoxShadow nav = BoxShadow(
    color: Color(0x338F9BB3),
    offset: Offset(0, -5),
    blurRadius: 16,
    spreadRadius: 0,
  );
}
