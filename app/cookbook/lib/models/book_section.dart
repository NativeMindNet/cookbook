import 'paragraph.dart';

class BookSection {
  final String? id;
  final Paragraph? title;
  final Paragraph? contentTitle;
  final List<dynamic> content; // Can be Paragraph or BookSection
  final int? startPage;

  const BookSection({
    this.id,
    this.title,
    this.contentTitle,
    this.content = const [],
    this.startPage,
  });

  String? get titleText => title?.text ?? contentTitle?.text;

  List<Paragraph> get allParagraphs {
    final paragraphs = <Paragraph>[];
    for (final item in content) {
      if (item is Paragraph) {
        paragraphs.add(item);
      } else if (item is BookSection) {
        paragraphs.addAll(item.allParagraphs);
      }
    }
    return paragraphs;
  }
}
