import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/book/book_bloc.dart';
import '../bloc/book/book_state.dart';
import '../bloc/book/book_event.dart';
import '../bloc/bookmarks/bookmarks_bloc.dart';
import '../bloc/bookmarks/bookmarks_event.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/page_view/book_page_view.dart';
import '../widgets/drawer/app_drawer.dart';
import '../utils/responsive_breakpoints.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  bool _showControls = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(
      listener: (context, state) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentPageIndex) {
          _pageController.animateToPage(
            state.currentPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          drawer: AppDrawer(
            sections: state.book?.sections ?? [],
            onSectionTap: (pageIndex) {
              context.read<BookBloc>().add(BookJumpToPage(pageIndex));
            },
            onSearchTap: () => context.push('/search'),
            onBookmarksTap: () => context.push('/bookmarks'),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(BookState state) {
    switch (state.status) {
      case BookStatus.initial:
      case BookStatus.loading:
        return const LoadingIndicator(message: 'Загрузка книги...');
      case BookStatus.error:
        return ErrorView(
          message: state.errorMessage ?? 'Ошибка загрузки',
          onRetry: () {
            context.read<BookBloc>().add(const BookLoadRequested());
          },
        );
      case BookStatus.loaded:
        return _buildBookView(state);
    }
  }

  Widget _buildBookView(BookState state) {
    final isLandscape = ResponsiveBreakpoints.isLandscape(context);
    final isTabletOrDesktop = !ResponsiveBreakpoints.isMobile(context);

    // Two-page view for landscape on tablet/desktop
    if (isLandscape && isTabletOrDesktop && state.totalPages > 1) {
      return _buildTwoPageView(state);
    }

    return Stack(
      children: [
        _buildPageView(state),
        if (_showControls) _buildOverlayControls(state),
      ],
    );
  }

  Widget _buildPageView(BookState state) {
    if (state.book == null || state.book!.pages.isEmpty) {
      return const Center(child: Text('Нет страниц'));
    }

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: PageView.builder(
        controller: _pageController,
        itemCount: state.totalPages,
        onPageChanged: (index) {
          context.read<BookBloc>().add(BookPageChanged(index));
        },
        itemBuilder: (context, index) {
          final page = state.book!.pages[index];
          return BookPageView(
            page: page,
            onTapLeft: () {
              context.read<BookBloc>().add(const BookPreviousPageRequested());
            },
            onTapRight: () {
              context.read<BookBloc>().add(const BookNextPageRequested());
            },
          );
        },
      ),
    );
  }

  Widget _buildTwoPageView(BookState state) {
    final leftPageIndex = (state.currentPageIndex ~/ 2) * 2;
    final rightPageIndex = leftPageIndex + 1;

    final leftPage = state.book!.pages[leftPageIndex];
    final rightPage = rightPageIndex < state.totalPages
        ? state.book!.pages[rightPageIndex]
        : null;

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: Stack(
        children: [
          TwoPageBookView(
            leftPage: leftPage,
            rightPage: rightPage,
            onTapLeft: () {
              if (leftPageIndex > 1) {
                context.read<BookBloc>().add(BookJumpToPage(leftPageIndex - 2));
              }
            },
            onTapRight: () {
              if (rightPageIndex < state.totalPages - 1) {
                context.read<BookBloc>().add(BookJumpToPage(leftPageIndex + 2));
              }
            },
          ),
          if (_showControls) _buildOverlayControls(state),
        ],
      ),
    );
  }

  Widget _buildOverlayControls(BookState state) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu button
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                    // Page counter
                    Text(
                      '${state.currentPageIndex + 1} / ${state.totalPages}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    // Bookmark button
                    BlocBuilder<BookmarksBloc, dynamic>(
                      builder: (context, bookmarksState) {
                        final isBookmarked = bookmarksState is dynamic &&
                            bookmarksState.isPageBookmarked != null &&
                            bookmarksState.isPageBookmarked(state.currentPageIndex);

                        return IconButton(
                          icon: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.read<BookmarksBloc>().add(
                                  BookmarkToggled(
                                    pageIndex: state.currentPageIndex,
                                    title: state.currentPage?.title,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
