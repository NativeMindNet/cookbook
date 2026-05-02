import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final int pageNumber;
  final String? title;
  final DateTime createdAt;
  final String? note;

  const Bookmark({
    required this.pageNumber,
    this.title,
    required this.createdAt,
    this.note,
  });

  Bookmark copyWith({
    int? pageNumber,
    String? title,
    DateTime? createdAt,
    String? note,
  }) {
    return Bookmark(
      pageNumber: pageNumber ?? this.pageNumber,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      pageNumber: json['pageNumber'] as int,
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [pageNumber, title, createdAt, note];
}
