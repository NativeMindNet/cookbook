import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'config/app_config.dart';
import 'router/app_router.dart';
import 'router/deep_link_listener.dart';
import 'router/uri_resolver.dart';
import 'widgets/install_app_prompt.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await dotenv.load(fileName: '.env');
  final config = AppConfig.fromDotEnv();
  final resolver = UriResolver(config);

  var initialLocation = '/';
  if (kIsWeb) {
    initialLocation = resolver.initialWebLocation(Uri.base) ?? '/';
  } else {
    final initialUri = await AppLinks().getInitialLink();
    if (initialUri != null) {
      initialLocation = resolver.normalizeToLocation(initialUri) ?? '/';
    }
  }

  final router = createAppRouter(initialLocation: initialLocation);

  runApp(
    CookbookRoot(
      config: config,
      resolver: resolver,
      router: router,
    ),
  );
}

class CookbookRoot extends StatelessWidget {
  const CookbookRoot({
    super.key,
    required this.config,
    required this.resolver,
    required this.router,
  });

  final AppConfig config;
  final UriResolver resolver;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cookbook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) {
        final body = DeepLinkListener(
          resolver: resolver,
          router: router,
          child: child ?? const SizedBox.shrink(),
        );
        if (!kIsWeb) return body;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: body),
            InstallAppPrompt(config: config),
          ],
        );
      },
    );
  }
}
