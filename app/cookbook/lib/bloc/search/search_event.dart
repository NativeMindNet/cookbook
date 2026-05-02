import 'package:equatable/equatable.dart';

enum SearchScope { all, titles, content, comments }

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchScopeChanged extends SearchEvent {
  final SearchScope scope;

  const SearchScopeChanged(this.scope);

  @override
  List<Object?> get props => [scope];
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}

class SearchResultSelected extends SearchEvent {
  final int pageIndex;

  const SearchResultSelected(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
