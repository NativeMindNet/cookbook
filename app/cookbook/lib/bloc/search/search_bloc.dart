import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../models/book.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Book? Function() bookGetter;
  Timer? _debounceTimer;

  static const _debounceDuration = Duration(milliseconds: 300);

  SearchBloc({required this.bookGetter}) : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchScopeChanged>(_onScopeChanged);
    on<SearchCleared>(_onCleared);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();

    if (event.query.isEmpty) {
      emit(state.copyWith(
        status: SearchStatus.initial,
        query: '',
        results: [],
      ));
      return;
    }

    emit(state.copyWith(
      status: SearchStatus.searching,
      query: event.query,
    ));

    _debounceTimer = Timer(_debounceDuration, () {
      add(_SearchExecute(event.query));
    });
  }

  void _onScopeChanged(
    SearchScopeChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(scope: event.scope));

    // Re-search with new scope
    if (state.query.isNotEmpty) {
      add(SearchQueryChanged(state.query));
    }
  }

  void _onCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();
    emit(const SearchState());
  }

  List<SearchResult> _performSearch(String query, SearchScope scope) {
    final book = bookGetter();
    if (book == null) return [];

    final results = <SearchResult>[];
    final queryLower = query.toLowerCase();

    for (var i = 0; i < book.pages.length; i++) {
      final page = book.pages[i];
      final pageText = page.plainText.toLowerCase();
      final title = page.title ?? 'Страница ${i + 1}';

      bool matches = false;
      String snippet = '';

      switch (scope) {
        case SearchScope.titles:
          matches = title.toLowerCase().contains(queryLower);
          snippet = title;
          break;
        case SearchScope.content:
          matches = pageText.contains(queryLower);
          if (matches) {
            snippet = _extractSnippet(page.plainText, query);
          }
          break;
        case SearchScope.comments:
          matches = page.comments?.toLowerCase().contains(queryLower) ?? false;
          snippet = page.comments ?? '';
          break;
        case SearchScope.all:
          if (title.toLowerCase().contains(queryLower)) {
            matches = true;
            snippet = title;
          } else if (pageText.contains(queryLower)) {
            matches = true;
            snippet = _extractSnippet(page.plainText, query);
          } else if (page.comments?.toLowerCase().contains(queryLower) ?? false) {
            matches = true;
            snippet = page.comments ?? '';
          }
          break;
      }

      if (matches) {
        results.add(SearchResult(
          pageIndex: i,
          title: title,
          snippet: snippet,
        ));
      }
    }

    return results;
  }

  String _extractSnippet(String text, String query, {int contextLength = 50}) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) return text.substring(0, text.length.clamp(0, 100));

    final start = (index - contextLength).clamp(0, text.length);
    final end = (index + query.length + contextLength).clamp(0, text.length);

    var snippet = text.substring(start, end);
    if (start > 0) snippet = '...$snippet';
    if (end < text.length) snippet = '$snippet...';

    return snippet;
  }
}

// Internal event for executing search after debounce
class _SearchExecute extends SearchEvent {
  final String query;

  const _SearchExecute(this.query);

  @override
  List<Object?> get props => [query];
}

extension on SearchBloc {
  void _handleSearchExecute(_SearchExecute event, Emitter<SearchState> emit) {
    try {
      final results = _performSearch(event.query, state.scope);

      emit(state.copyWith(
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        results: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
