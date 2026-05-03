import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_section.dart';
import '../models/paragraph.dart';
import '../models/book_page.dart';
import 'database_service.dart';

class BookRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<BookSection>> getSections() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sections',
      orderBy: 'sort_order',
    );

    return List.generate(maps.length, (i) {
      return BookSection(
        id: maps[i]['id'],
        title: Paragraph(text: maps[i]['title']),
        startPage: maps[i]['start_page'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getReplacements() async {
    final jsonContent = await rootBundle.loadString('assets/data/replacements.json');
    final List<dynamic> list = json.decode(jsonContent);
    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getMeasures() async {
    final jsonContent = await rootBundle.loadString('assets/data/measures.json');
    return json.decode(jsonContent);
  }

  Future<List<Map<String, dynamic>>> getFamousVegetarians() async {
    final jsonContent = await rootBundle.loadString('assets/data/famous_vegetarians.json');
    return json.decode(jsonContent);
  }

  // Placeholder for pages until XML parser is ready
  Future<List<BookPage>> getPages() async {
    // For now, let's create a few empty pages to avoid crashes
    return List.generate(100, (i) => BookPage(
      number: i,
      backgroundImagePath: 'assets/images/content/${(i % 50 + 1).toString().padLeft(3, '0')}.png',
    ));
  }
}
