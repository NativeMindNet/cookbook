import 'package:equatable/equatable.dart';
import '../../models/bookmark.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object?> get props => [];
}

class BookmarksLoadRequested extends BookmarksEvent {
  const BookmarksLoadRequested();
}

class BookmarkAdded extends BookmarksEvent {
  final int pageIndex;
  final String? title;
  final String? note;

  const BookmarkAdded({
    required this.pageIndex,
    this.title,
    this.note,
  });

  @override
  List<Object?> get props => [pageIndex, title, note];
}

class BookmarkRemoved extends BookmarksEvent {
  final String bookmarkId;

  const BookmarkRemoved(this.bookmarkId);

  @override
  List<Object?> get props => [bookmarkId];
}

class BookmarkUpdated extends BookmarksEvent {
  final Bookmark bookmark;

  const BookmarkUpdated(this.bookmark);

  @override
  List<Object?> get props => [bookmark];
}

class BookmarkToggled extends BookmarksEvent {
  final int pageIndex;
  final String? title;

  const BookmarkToggled({
    required this.pageIndex,
    this.title,
  });

  @override
  List<Object?> get props => [pageIndex, title];
}
