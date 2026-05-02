import 'package:flutter_bloc/flutter_bloc.dart';
import 'bookmarks_event.dart';
import 'bookmarks_state.dart';
import '../../models/bookmark.dart';
import '../../services/bookmark_storage_service.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final BookmarkStorageService _storageService;

  BookmarksBloc({required BookmarkStorageService storageService})
      : _storageService = storageService,
        super(const BookmarksState()) {
    on<BookmarksLoadRequested>(_onLoadRequested);
    on<BookmarkAdded>(_onAdded);
    on<BookmarkRemoved>(_onRemoved);
    on<BookmarkUpdated>(_onUpdated);
    on<BookmarkToggled>(_onToggled);
  }

  Future<void> _onLoadRequested(
    BookmarksLoadRequested event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(status: BookmarksStatus.loading));

    try {
      final bookmarks = await _storageService.loadBookmarks();
      emit(state.copyWith(
        status: BookmarksStatus.loaded,
        bookmarks: bookmarks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarksStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAdded(
    BookmarkAdded event,
    Emitter<BookmarksState> emit,
  ) async {
    final bookmark = Bookmark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pageIndex: event.pageIndex,
      title: event.title ?? 'Страница ${event.pageIndex + 1}',
      note: event.note,
      createdAt: DateTime.now(),
    );

    final updatedBookmarks = [...state.bookmarks, bookmark];
    emit(state.copyWith(bookmarks: updatedBookmarks));

    await _storageService.saveBookmarks(updatedBookmarks);
  }

  Future<void> _onRemoved(
    BookmarkRemoved event,
    Emitter<BookmarksState> emit,
  ) async {
    final updatedBookmarks = state.bookmarks
        .where((b) => b.id != event.bookmarkId)
        .toList();

    emit(state.copyWith(bookmarks: updatedBookmarks));
    await _storageService.saveBookmarks(updatedBookmarks);
  }

  Future<void> _onUpdated(
    BookmarkUpdated event,
    Emitter<BookmarksState> emit,
  ) async {
    final updatedBookmarks = state.bookmarks.map((b) {
      return b.id == event.bookmark.id ? event.bookmark : b;
    }).toList();

    emit(state.copyWith(bookmarks: updatedBookmarks));
    await _storageService.saveBookmarks(updatedBookmarks);
  }

  Future<void> _onToggled(
    BookmarkToggled event,
    Emitter<BookmarksState> emit,
  ) async {
    final existing = state.getBookmarkForPage(event.pageIndex);

    if (existing != null) {
      add(BookmarkRemoved(existing.id));
    } else {
      add(BookmarkAdded(
        pageIndex: event.pageIndex,
        title: event.title,
      ));
    }
  }
}
