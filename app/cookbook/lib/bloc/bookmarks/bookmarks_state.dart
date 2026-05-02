import 'package:equatable/equatable.dart';
import '../../models/bookmark.dart';

enum BookmarksStatus { initial, loading, loaded, error }

class BookmarksState extends Equatable {
  final BookmarksStatus status;
  final List<Bookmark> bookmarks;
  final String? errorMessage;

  const BookmarksState({
    this.status = BookmarksStatus.initial,
    this.bookmarks = const [],
    this.errorMessage,
  });

  int get count => bookmarks.length;

  bool isPageBookmarked(int pageIndex) {
    return bookmarks.any((b) => b.pageIndex == pageIndex);
  }

  Bookmark? getBookmarkForPage(int pageIndex) {
    return bookmarks.where((b) => b.pageIndex == pageIndex).firstOrNull;
  }

  List<Bookmark> get sortedByDate {
    final sorted = List<Bookmark>.from(bookmarks);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  List<Bookmark> get sortedByPage {
    final sorted = List<Bookmark>.from(bookmarks);
    sorted.sort((a, b) => a.pageIndex.compareTo(b.pageIndex));
    return sorted;
  }

  BookmarksState copyWith({
    BookmarksStatus? status,
    List<Bookmark>? bookmarks,
    String? errorMessage,
  }) {
    return BookmarksState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookmarks, errorMessage];
}
