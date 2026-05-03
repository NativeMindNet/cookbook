import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/book/book_bloc.dart';
import '../bloc/book/book_event.dart';
import '../bloc/book/book_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';
import '../widgets/share/share_current_route_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(const BookLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513), // Saddle brown
      body: BlocConsumer<BookBloc, BookState>(
        listener: (context, state) {
          if (state.status == BookStatus.loaded) {
            context.go('/book');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    _buildLogo(),
                    const Spacer(),
                    _buildContent(state),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: ShareCurrentRouteButton(
                    locationOverride: '/book',
                    iconColor: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Logo placeholder
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.menu_book,
            size: 100,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Вегетарианская кухня',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Востока',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BookState state) {
    switch (state.status) {
      case BookStatus.initial:
      case BookStatus.loading:
        return const LoadingIndicator(
          message: 'Загрузка книги...',
        );
      case BookStatus.error:
        return ErrorView(
          message: state.errorMessage ?? 'Не удалось загрузить книгу',
          onRetry: () {
            context.read<BookBloc>().add(const BookLoadRequested());
          },
        );
      case BookStatus.loaded:
        return const LoadingIndicator(message: 'Открываем...');
    }
  }
}
