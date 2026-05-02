import 'package:equatable/equatable.dart';
import '../../models/book.dart';
import '../../models/book_page.dart';

enum BookStatus { initial, loading, loaded, error }

class BookState extends Equatable {
  final BookStatus status;
  final Book? book;
  final int currentPageIndex;
  final String? errorMessage;

  const BookState({
    this.status = BookStatus.initial,
    this.book,
    this.currentPageIndex = 0,
    this.errorMessage,
  });

  BookPage? get currentPage {
    if (book == null || book!.pages.isEmpty) return null;
    if (currentPageIndex < 0 || currentPageIndex >= book!.pages.length) {
      return null;
    }
    return book!.pages[currentPageIndex];
  }

  int get totalPages => book?.totalPages ?? 0;

  bool get canGoNext => currentPageIndex < totalPages - 1;

  bool get canGoPrevious => currentPageIndex > 0;

  double get progress {
    if (totalPages == 0) return 0;
    return (currentPageIndex + 1) / totalPages;
  }

  BookState copyWith({
    BookStatus? status,
    Book? book,
    int? currentPageIndex,
    String? errorMessage,
  }) {
    return BookState(
      status: status ?? this.status,
      book: book ?? this.book,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, book, currentPageIndex, errorMessage];
}
