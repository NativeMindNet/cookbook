import 'package:flutter/material.dart';
import 'book_page.dart';
import 'book_section.dart';
import 'paragraph_style.dart';
import 'control_info.dart';

class Person {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? nickname;
  final String? email;

  const Person({
    this.firstName,
    this.middleName,
    this.lastName,
    this.nickname,
    this.email,
  });

  String get fullName {
    final parts = <String>[];
    if (firstName != null) parts.add(firstName!);
    if (middleName != null) parts.add(middleName!);
    if (lastName != null) parts.add(lastName!);
    return parts.join(' ');
  }
}

class PublishInfo {
  final String? publisher;
  final String? city;
  final int? year;

  const PublishInfo({
    this.publisher,
    this.city,
    this.year,
  });
}

enum BookOrientation {
  portrait,
  landscape,
  both,
}

class BookHeader {
  final String? id;
  final String title;
  final String? language;
  final String? sourceLanguage;
  final String? isbn;
  final String? genre;
  final BookOrientation orientation;
  final List<Person> authors;
  final List<Person> translators;
  final PublishInfo? publishInfo;
  final List<ControlInfo> globalControls;

  const BookHeader({
    this.id,
    required this.title,
    this.language,
    this.sourceLanguage,
    this.isbn,
    this.genre,
    this.orientation = BookOrientation.both,
    this.authors = const [],
    this.translators = const [],
    this.publishInfo,
    this.globalControls = const [],
  });
}

class BookBody {
  final List<BookPage> pages;
  final List<BookSection> sections;
  final Map<String, ParagraphStyle> styles;

  const BookBody({
    this.pages = const [],
    this.sections = const [],
    this.styles = const {},
  });
}

class Book {
  final BookHeader header;
  final BookBody body;

  const Book({
    required this.header,
    required this.body,
  });

  String get title => header.title;

  int get totalPages => body.pages.length;

  List<BookSection> get sections => body.sections;

  List<BookPage> get pages => body.pages;

  BookPage? getPage(int pageNumber) {
    if (pageNumber < 0 || pageNumber >= body.pages.length) {
      return null;
    }
    return body.pages[pageNumber];
  }

  ParagraphStyle? getStyle(String? styleName) {
    if (styleName == null) return null;
    return body.styles[styleName];
  }

  List<ControlInfo> get globalControls => header.globalControls;
}
