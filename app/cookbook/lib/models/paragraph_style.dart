import 'package:flutter/material.dart';

class ParagraphStyle {
  final String name;
  final String fontFamily;
  final double fontSize;
  final TextAlign textAlignment;
  final Color textColor;
  final Color? backgroundColor;

  const ParagraphStyle({
    required this.name,
    this.fontFamily = 'Roboto',
    this.fontSize = 16.0,
    this.textAlignment = TextAlign.left,
    this.textColor = Colors.black,
    this.backgroundColor,
  });

  TextStyle toTextStyle() {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor,
      backgroundColor: backgroundColor,
    );
  }

  static TextAlign parseAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}
