import 'package:equatable/equatable.dart';
import 'search_event.dart';

class SearchResult {
  final int pageIndex;
  final String title;
  final String snippet;
  final List<int> highlightPositions;

  const SearchResult({
    required this.pageIndex,
    required this.title,
    required this.snippet,
    this.highlightPositions = const [],
  });
}

enum SearchStatus { initial, searching, success, empty, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final SearchScope scope;
  final List<SearchResult> results;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.scope = SearchScope.all,
    this.results = const [],
    this.errorMessage,
  });

  bool get hasResults => results.isNotEmpty;

  int get resultCount => results.length;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    SearchScope? scope,
    List<SearchResult>? results,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      scope: scope ?? this.scope,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, scope, results, errorMessage];
}
