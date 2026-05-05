import 'package:flutter/cupertino.dart';

class MealWeightPalette {
  const MealWeightPalette({
    required this.bg,
    required this.card,
    required this.border,
    required this.text,
    required this.muted,
    required this.accent,
    required this.buttonText,
    required this.resultBg,
    required this.resultBorder,
    required this.noteBg,
    required this.noteBorder,
    required this.noteColor,
    required this.deleteBg,
    required this.deleteBorder,
    required this.accentDim,
    required this.textDim,
  });

  final Color bg;
  final Color card;
  final Color border;
  final Color text;
  final Color muted;
  final Color accent;
  final Color buttonText;
  final Color resultBg;
  final Color resultBorder;
  final Color noteBg;
  final Color noteBorder;
  final Color noteColor;
  final Color deleteBg;
  final Color deleteBorder;
  final Color accentDim;
  final Color textDim;
}

class ThemeOption {
  const ThemeOption({
    required this.id,
    required this.name,
    required this.isFree,
    required this.dark,
    required this.light,
  });

  final String id;
  final String name;
  final bool isFree;
  final MealWeightPalette dark;
  final MealWeightPalette light;
}
