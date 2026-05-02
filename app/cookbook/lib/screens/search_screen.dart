import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../bloc/book/book_bloc.dart';
import '../bloc/book/book_event.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<SearchBloc>().add(const SearchCleared());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildScopeTabs(),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildScopeTabs() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: SearchScope.values.map((scope) {
              final isSelected = state.scope == scope;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_getScopeName(scope)),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<SearchBloc>().add(SearchScopeChanged(scope));
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStatus.initial:
            return const Center(
              child: Text('Введите текст для поиска'),
            );
          case SearchStatus.searching:
            return const LoadingIndicator(message: 'Поиск...');
          case SearchStatus.empty:
            return EmptyState(
              message: 'Ничего не найдено по запросу "${state.query}"',
              icon: Icons.search_off,
            );
          case SearchStatus.error:
            return ErrorView(
              message: state.errorMessage ?? 'Ошибка поиска',
              onRetry: () {
                context.read<SearchBloc>().add(SearchQueryChanged(state.query));
              },
            );
          case SearchStatus.success:
            return _buildResultsList(state.results);
        }
      },
    );
  }

  Widget _buildResultsList(List<SearchResult> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          title: Text(result.title),
          subtitle: Text(
            result.snippet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text('Стр. ${result.pageIndex + 1}'),
          onTap: () {
            context.read<BookBloc>().add(BookJumpToPage(result.pageIndex));
            context.pop();
          },
        );
      },
    );
  }

  String _getScopeName(SearchScope scope) {
    switch (scope) {
      case SearchScope.all:
        return 'Везде';
      case SearchScope.titles:
        return 'Заголовки';
      case SearchScope.content:
        return 'Текст';
      case SearchScope.comments:
        return 'Комментарии';
    }
  }
}
