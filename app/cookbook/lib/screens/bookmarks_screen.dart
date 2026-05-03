import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/bookmarks/bookmarks_bloc.dart';
import '../bloc/bookmarks/bookmarks_event.dart';
import '../bloc/bookmarks/bookmarks_state.dart';
import '../bloc/book/book_bloc.dart';
import '../bloc/book/book_event.dart';
import '../models/bookmark.dart';
import '../widgets/common/error_view.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/share/share_current_route_button.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Закладки'),
        actions: [
          const ShareCurrentRouteButton(),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle sort options
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date',
                child: Text('По дате'),
              ),
              const PopupMenuItem(
                value: 'page',
                child: Text('По странице'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          switch (state.status) {
            case BookmarksStatus.initial:
            case BookmarksStatus.loading:
              return const LoadingIndicator(message: 'Загрузка закладок...');
            case BookmarksStatus.error:
              return ErrorView(
                message: state.errorMessage ?? 'Ошибка загрузки',
                onRetry: () {
                  context.read<BookmarksBloc>().add(const BookmarksLoadRequested());
                },
              );
            case BookmarksStatus.loaded:
              if (state.bookmarks.isEmpty) {
                return const EmptyState(
                  message: 'У вас пока нет закладок',
                  icon: Icons.bookmark_border,
                );
              }
              return _buildBookmarksList(context, state.sortedByDate);
          }
        },
      ),
    );
  }

  Widget _buildBookmarksList(BuildContext context, List<Bookmark> bookmarks) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return Dismissible(
          key: Key(bookmark.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<BookmarksBloc>().add(BookmarkRemoved(bookmark.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Закладка удалена'),
                action: SnackBarAction(
                  label: 'Отменить',
                  onPressed: () {
                    context.read<BookmarksBloc>().add(BookmarkAdded(
                          pageIndex: bookmark.pageIndex,
                          title: bookmark.title,
                          note: bookmark.note,
                        ));
                  },
                ),
              ),
            );
          },
          child: ListTile(
            leading: const Icon(Icons.bookmark),
            title: Text(bookmark.title ?? 'Страница ${bookmark.pageIndex + 1}'),
            subtitle: bookmark.note != null
                ? Text(
                    bookmark.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(_formatDate(bookmark.createdAt)),
            trailing: Text('Стр. ${bookmark.pageIndex + 1}'),
            onTap: () {
              context.read<BookBloc>().add(BookJumpToPage(bookmark.pageIndex));
              context.pop();
            },
            onLongPress: () => _showEditDialog(context, bookmark),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _showEditDialog(BuildContext context, Bookmark bookmark) {
    final noteController = TextEditingController(text: bookmark.note);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Редактировать закладку'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              labelText: 'Заметка',
              hintText: 'Добавьте заметку к закладке...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                context.read<BookmarksBloc>().add(
                      BookmarkUpdated(
                        bookmark.copyWith(note: noteController.text),
                      ),
                    );
                Navigator.pop(dialogContext);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
