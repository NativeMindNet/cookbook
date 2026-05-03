import 'package:cookbook/config/app_config.dart';
import 'package:cookbook/router/share_web_uri.dart';
import 'package:cookbook/router/uri_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildShareWebUri', () {
    test('joins trailing-slash base with location path', () {
      final config = AppConfig.fake(
        webAppBaseUri: Uri.parse(
          'https://nativemindnet.github.io/cookbook/web/',
        ),
      );
      final u = buildShareWebUri(config, '/book/7');
      expect(
        u.toString(),
        'https://nativemindnet.github.io/cookbook/web/book/7',
      );
    });

    test('preserves query string', () {
      final config = AppConfig.fake(
        webAppBaseUri: Uri.parse(
          'https://nativemindnet.github.io/cookbook/web/',
        ),
      );
      final u = buildShareWebUri(config, '/search?q=rice&scope=all');
      expect(u.path, '/cookbook/web/search');
      expect(u.query, 'q=rice&scope=all');
    });

    test('base path without trailing slash', () {
      final config = AppConfig.fake(
        webAppBaseUri: Uri.parse('https://example.com/base'),
      );
      final u = buildShareWebUri(config, '/foo');
      expect(u.toString(), 'https://example.com/base/foo');
    });

    test('location root', () {
      final config = AppConfig.fake(
        webAppBaseUri: Uri.parse('https://example.com/cookbook/web/'),
      );
      final u = buildShareWebUri(config, '/');
      expect(u.path, '/cookbook/web/');
    });

    test('round-trip with UriResolver for https', () {
      final config = AppConfig.fake(
        webAppBaseUri: Uri.parse(
          'https://nativemindnet.github.io/cookbook/web/',
        ),
      );
      const location = '/bookmarks?sort=page';
      final public = buildShareWebUri(config, location);
      final back = UriResolver(config).normalizeToLocation(public);
      expect(back, location);
    });
  });
}
