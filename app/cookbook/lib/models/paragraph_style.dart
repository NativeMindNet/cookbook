import 'package:flutter/material.dart';
import 'paragraph.dart';

class ParagraphStyle {
  final String name;
  final String fontFamily;
  final double fontSize;
  final TextAlignment textAlignment;
  final Color textColor;
  final Color? backgroundColor;
  final FontWeight fontWeight;
  final bool isItalic;
  final EdgeInsets padding;

  const ParagraphStyle({
    required this.name,
    this.fontFamily = 'Roboto',
    this.fontSize = 16.0,
    this.textAlignment = TextAlignment.left,
    this.textColor = Colors.black,
    this.backgroundColor,
    this.fontWeight = FontWeight.normal,
    this.isItalic = false,
    this.padding = EdgeInsets.zero,
  });

  TextStyle toTextStyle() {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor,
      backgroundColor: backgroundColor,
      fontWeight: fontWeight,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
    );
  }

  static TextAlignment parseAlignment(String? alignment) {
    switch (alignment?.toLowerCase()) {
      case 'center':
        return TextAlignment.center;
      case 'right':
        return TextAlignment.right;
      case 'justify':
        return TextAlignment.justify;
      default:
        return TextAlignment.left;
    }
  }
}
