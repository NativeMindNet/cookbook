import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/page_screen.dart';
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
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/page/:pageId',
        builder: (context, state) {
          final id = state.pathParameters['pageId']!;
          return PageScreen(pageId: id);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return UnknownRouteScreen(location: state.uri.toString());
    },
  );
}
