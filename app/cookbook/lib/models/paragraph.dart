import 'package:flutter/material.dart';

enum TextAlignment { left, center, right, justify }

class Paragraph {
  final String text;
  final String? styleName;
  final bool hasLargeCapital;
  final bool isHidden;
  final Color? textColor;
  final Color? backgroundColor;
  final TextAlignment textAlignment;
  final double spacingAfter;

  const Paragraph({
    required this.text,
    this.styleName,
    this.hasLargeCapital = false,
    this.isHidden = false,
    this.textColor,
    this.backgroundColor,
    this.textAlignment = TextAlignment.left,
    this.spacingAfter = 12.0,
  });

  @override
  String toString() => text;
}
