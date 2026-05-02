import 'package:flutter_dotenv/flutter_dotenv.dart';

/// URLs and web base from `.env` (bundled asset). Do not hardcode store links in UI.
class AppConfig {
  const AppConfig({
    required this.webAppBaseUri,
    required this.appStoreUrl,
    required this.googlePlayUrl,
    required this.ruStoreUrl,
    required this.ruMarketUrl,
    this.cdnAudioRussianUrl,
  });

  final Uri webAppBaseUri;
  final Uri appStoreUrl;
  final Uri googlePlayUrl;
  final Uri ruStoreUrl;
  final Uri ruMarketUrl;
  final Uri? cdnAudioRussianUrl;

  /// Path prefix for App Links / Universal Links, e.g. `/cookbook/web`.
  String get webPathPrefix {
    var p = webAppBaseUri.path;
    if (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p.isEmpty ? '/' : p;
  }

  factory AppConfig.fromDotEnv() {
    Uri parseU(String key, String fallback) {
      final raw = dotenv.get(key, fallback: fallback);
      return Uri.parse(raw.trim());
    }

    final cdn = dotenv.maybeGet('CDN_AUDIO_RUSSIAN_URL')?.trim();

    return AppConfig(
      webAppBaseUri: parseU(
        'WEBAPP_URL',
        'https://nativemindnet.github.io/cookbook/web/',
      ),
      appStoreUrl: parseU(
        'APPSTORE_URL',
        'https://apps.apple.com/',
      ),
      googlePlayUrl: parseU(
        'GOOGLEPLAY_URL',
        'https://play.google.com/store',
      ),
      ruStoreUrl: parseU(
        'RUSTORE_URL',
        'https://www.rustore.ru/',
      ),
      ruMarketUrl: parseU(
        'RUMARKET_URL',
        'https://ruplay.market/',
      ),
      cdnAudioRussianUrl:
          cdn != null && cdn.isNotEmpty ? Uri.parse(cdn) : null,
    );
  }

  /// For tests without dotenv.
  factory AppConfig.fake({
    Uri? webAppBaseUri,
    Uri? appStoreUrl,
    Uri? googlePlayUrl,
    Uri? ruStoreUrl,
    Uri? ruMarketUrl,
  }) {
    return AppConfig(
      webAppBaseUri:
          webAppBaseUri ?? Uri.parse('https://example.com/cookbook/web/'),
      appStoreUrl: appStoreUrl ?? Uri.parse('https://apps.apple.com/app/x'),
      googlePlayUrl:
          googlePlayUrl ?? Uri.parse('https://play.google.com/store/apps/x'),
      ruStoreUrl: ruStoreUrl ?? Uri.parse('https://www.rustore.ru/app/x'),
      ruMarketUrl: ruMarketUrl ?? Uri.parse('https://ruplay.market/app/x'),
    );
  }
}
