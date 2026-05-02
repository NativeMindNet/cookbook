import 'package:flutter/material.dart';

enum ControlType {
  prevPage,
  nextPage,
  bookmarks,
  addBookmark,
  playSound,
  stopSound,
  togglePlayer,
  search,
  pageLink,
  toggleAnimations,
  unknown,
}

class ControlInfo {
  final ControlType type;
  final String? normalImagePath;
  final String? highlightedImagePath;
  final String? disabledImagePath;
  final int? targetPage;
  final bool isDraggable;
  final Offset position;
  final Size size;
  final String? argument;

  const ControlInfo({
    required this.type,
    this.normalImagePath,
    this.highlightedImagePath,
    this.disabledImagePath,
    this.targetPage,
    this.isDraggable = false,
    this.position = Offset.zero,
    this.size = const Size(44, 44),
    this.argument,
  });

  static ControlType parseType(String? typeString) {
    switch (typeString?.toLowerCase()) {
      case 'prev-page':
        return ControlType.prevPage;
      case 'next-page':
        return ControlType.nextPage;
      case 'bookmarks':
        return ControlType.bookmarks;
      case 'add-bookmark':
        return ControlType.addBookmark;
      case 'play-sound':
        return ControlType.playSound;
      case 'stop-sound':
        return ControlType.stopSound;
      case 'toggle-player':
        return ControlType.togglePlayer;
      case 'search':
        return ControlType.search;
      case 'page-link':
        return ControlType.pageLink;
      case 'toggle-animations':
        return ControlType.toggleAnimations;
      default:
        return ControlType.unknown;
    }
  }
}
