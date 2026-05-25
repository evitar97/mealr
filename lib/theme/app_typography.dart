import 'package:flutter/cupertino.dart';

class MealText {
  static const family = 'Nunito Sans';

  static TextStyle largeTitle(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 29,
    fontWeight: FontWeight.w700,
    height: 1.08,
  );

  static TextStyle title(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 23,
    fontWeight: FontWeight.w700,
    height: 1.14,
  );

  static TextStyle sheetTitle(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.16,
  );

  static TextStyle cardTitle(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle body(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    height: 1.28,
  );

  static TextStyle bodyStrong(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.24,
  );

  static TextStyle callout(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    height: 1.24,
  );

  static TextStyle caption(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.22,
  );

  static TextStyle captionStrong(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle section(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.55,
    height: 1.15,
  );

  static TextStyle navLabel(Color color, {required bool active}) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 11.3,
    fontWeight: active ? FontWeight.w700 : FontWeight.w600,
    height: 1.05,
  );

  static TextStyle button(Color color) => TextStyle(
    color: color,
    fontFamily: family,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.16,
  );
}
