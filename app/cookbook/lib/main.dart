import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'config/app_config.dart';
import 'router/app_router.dart';
import 'router/deep_link_listener.dart';
import 'router/uri_resolver.dart';
import 'widgets/install_app_prompt.dart';

// Bloc imports
import 'bloc/book/book_bloc.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/bookmarks/bookmarks_bloc.dart';
import 'bloc/audio/audio_bloc.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/settings/settings_event.dart';
import 'bloc/bookmarks/bookmarks_event.dart';
import 'services/bookmark_storage_service.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BookBloc()),
        BlocProvider(
          create: (context) => SearchBloc(
            bookGetter: () => context.read<BookBloc>().state.book,
          ),
        ),
        BlocProvider(
          create: (_) => BookmarksBloc(
            storageService: BookmarkStorageService(),
          )..add(const BookmarksLoadRequested()),
        ),
        BlocProvider(create: (_) => AudioBloc()),
        BlocProvider(
          create: (_) => SettingsBloc()..add(const SettingsLoadRequested()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, dynamic>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: 'Вегетарианская кухня Востока',
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: settingsState.themeMode ?? ThemeMode.system,
            locale: settingsState.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru'),
              Locale('zh'),
              Locale('th'),
              Locale('hi'),
              Locale('ja'),
            ],
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
        },
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.brown.shade900 : Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF3E1C6), // Parchment
      fontFamily: 'MurariChandUni',
    );
  }
}
