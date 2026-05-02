import 'package:flutter/material.dart';
import '../../models/paragraph.dart';
import '../../models/paragraph_style.dart';

class PageContent extends StatelessWidget {
  final List<Paragraph> paragraphs;
  final Map<String, ParagraphStyle>? styles;

  const PageContent({
    super.key,
    required this.paragraphs,
    this.styles,
  });

  @override
  Widget build(BuildContext context) {
    if (paragraphs.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: paragraphs
            .where((p) => !p.isHidden)
            .map((p) => ParagraphWidget(
                  paragraph: p,
                  style: _getStyle(p.styleName),
                ))
            .toList(),
      ),
    );
  }

  ParagraphStyle? _getStyle(String? styleName) {
    if (styleName == null || styles == null) return null;
    return styles![styleName];
  }
}

class ParagraphWidget extends StatelessWidget {
  final Paragraph paragraph;
  final ParagraphStyle? style;

  const ParagraphWidget({
    super.key,
    required this.paragraph,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: paragraph.spacingAfter),
      child: Container(
        width: double.infinity,
        padding: style?.padding ?? EdgeInsets.zero,
        decoration: _buildDecoration(),
        child: Text(
          paragraph.text,
          style: _buildTextStyle(context),
          textAlign: _getTextAlign(),
        ),
      ),
    );
  }

  BoxDecoration? _buildDecoration() {
    final bgColor = paragraph.backgroundColor ?? style?.backgroundColor;
    if (bgColor == null) return null;

    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(4),
    );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();

    return baseStyle.copyWith(
      fontSize: style?.fontSize ?? 16,
      fontWeight: style?.fontWeight ?? FontWeight.normal,
      fontStyle: style?.isItalic == true ? FontStyle.italic : FontStyle.normal,
      color: style?.textColor ?? paragraph.textColor ?? Colors.brown.shade900,
      height: 1.5,
    );
  }

  TextAlign _getTextAlign() {
    final alignment = style?.textAlignment ?? paragraph.textAlignment;

    switch (alignment) {
      case TextAlignment.left:
        return TextAlign.left;
      case TextAlignment.center:
        return TextAlign.center;
      case TextAlignment.right:
        return TextAlign.right;
      case TextAlignment.justify:
        return TextAlign.justify;
    }
  }
}
