import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final int pageIndex;
  final String? title;
  final DateTime createdAt;
  final String? note;

  const Bookmark({
    required this.id,
    required this.pageIndex,
    this.title,
    required this.createdAt,
    this.note,
  });

  Bookmark copyWith({
    String? id,
    int? pageIndex,
    String? title,
    DateTime? createdAt,
    String? note,
  }) {
    return Bookmark(
      id: id ?? this.id,
      pageIndex: pageIndex ?? this.pageIndex,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageIndex': pageIndex,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      pageIndex: json['pageIndex'] as int? ?? json['pageNumber'] as int? ?? 0,
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, pageIndex, title, createdAt, note];
}
