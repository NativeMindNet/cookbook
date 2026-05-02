class Paragraph {
  final String text;
  final String? styleName;
  final bool hasLargeCapital;
  final bool isHidden;

  const Paragraph({
    required this.text,
    this.styleName,
    this.hasLargeCapital = false,
    this.isHidden = false,
  });

  @override
  String toString() => text;
}
