import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/main_screen.dart';
import '../screens/search_screen.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/unknown_route_screen.dart';

GoRouter createAppRouter({
  required String initialLocation,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/book',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/book/:pageIndex',
        builder: (context, state) {
          // Navigate to book at specific page
          return const MainScreen();
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return UnknownRouteScreen(location: state.uri.toString());
    },
  );
}
