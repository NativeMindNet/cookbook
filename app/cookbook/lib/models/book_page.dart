import 'package:flutter/material.dart';
import 'paragraph.dart';
import 'animation_config.dart';
import 'control_info.dart';

class BookPage {
  final int number;
  final List<Paragraph> paragraphs;
  final String? backgroundImagePath;
  final Color? backgroundColor;
  final bool showPageNumber;
  final String? audioUrl;
  final bool autoplayAudio;
  final bool loopAudio;
  final String? comments;
  final List<AnimationConfig> animations;
  final List<ControlInfo> controls;

  const BookPage({
    required this.number,
    this.paragraphs = const [],
    this.backgroundImagePath,
    this.backgroundColor,
    this.showPageNumber = true,
    this.audioUrl,
    this.autoplayAudio = false,
    this.loopAudio = false,
    this.comments,
    this.animations = const [],
    this.controls = const [],
  });

  String get plainText => paragraphs.map((p) => p.text).join('\n');

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  bool get hasAnimations => animations.isNotEmpty;

  bool get hasBackground => backgroundImagePath != null && backgroundImagePath!.isNotEmpty;

  String? get title {
    if (paragraphs.isEmpty) return null;
    final firstParagraph = paragraphs.first.text;
    if (firstParagraph.length > 50) {
      return '${firstParagraph.substring(0, 50)}...';
    }
    return firstParagraph;
  }
}
