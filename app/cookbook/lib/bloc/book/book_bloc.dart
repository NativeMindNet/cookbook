import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_event.dart';
import 'book_state.dart';
import '../../models/book.dart';
import '../../services/book_repository.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;

  BookBloc({required this.repository}) : super(const BookState()) {
    on<BookLoadRequested>(_onLoadRequested);
    on<BookPageChanged>(_onPageChanged);
    on<BookNextPageRequested>(_onNextPage);
    on<BookPreviousPageRequested>(_onPreviousPage);
    on<BookJumpToPage>(_onJumpToPage);
    on<BookSectionSelected>(_onSectionSelected);
  }

  Future<void> _onLoadRequested(
    BookLoadRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(state.copyWith(status: BookStatus.loading));

    try {
      final sections = await repository.getSections();
      final pages = await repository.getPages();

      final book = Book(
        header: const BookHeader(
          id: '1',
          title: 'Вегетарианская кухня Востока',
          language: 'ru',
          sourceLanguage: 'ru',
          orientation: BookOrientation.portrait,
        ),
        body: BookBody(
          pages: pages,
          sections: sections,
          styles: {},
        ),
      );

      emit(state.copyWith(
        status: BookStatus.loaded,
        book: book,
        currentPageIndex: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onPageChanged(
    BookPageChanged event,
    Emitter<BookState> emit,
  ) {
    if (state.book == null) return;

    final pageIndex = event.pageNumber.clamp(0, state.totalPages - 1);
    emit(state.copyWith(currentPageIndex: pageIndex));
  }

  void _onNextPage(
    BookNextPageRequested event,
    Emitter<BookState> emit,
  ) {
    if (!state.canGoNext) return;
    emit(state.copyWith(currentPageIndex: state.currentPageIndex + 1));
  }

  void _onPreviousPage(
    BookPreviousPageRequested event,
    Emitter<BookState> emit,
  ) {
    if (!state.canGoPrevious) return;
    emit(state.copyWith(currentPageIndex: state.currentPageIndex - 1));
  }

  void _onJumpToPage(
    BookJumpToPage event,
    Emitter<BookState> emit,
  ) {
    if (state.book == null) return;

    final pageIndex = event.pageNumber.clamp(0, state.totalPages - 1);
    emit(state.copyWith(currentPageIndex: pageIndex));
  }

  void _onSectionSelected(
    BookSectionSelected event,
    Emitter<BookState> emit,
  ) {
    if (state.book == null) return;

    // Find section's first page
    final section = state.book!.sections.where(
      (s) => s.id == event.sectionId,
    ).firstOrNull;

    if (section != null && section.startPage != null && section.startPage! >= 0) {
      emit(state.copyWith(currentPageIndex: section.startPage!));
    }
  }

  Book _createPlaceholderBook() {
    // Placeholder until XML parser is implemented
    return const Book(
      header: BookHeader(
        id: '1',
        title: 'Вегетарианская кухня Востока',
        language: 'ru',
        sourceLanguage: 'ru',
        orientation: BookOrientation.portrait,
      ),
      body: BookBody(
        pages: [],
        sections: [],
        styles: {},
      ),
    );
  }
}
