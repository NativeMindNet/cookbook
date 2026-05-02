import 'package:cookbook/config/app_config.dart';
import 'package:cookbook/router/uri_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = AppConfig.fake(
    webAppBaseUri: Uri.parse('https://nativemindnet.github.io/cookbook/web/'),
  );
  final resolver = UriResolver(config);

  test('strips WEBAPP_URL path prefix for https', () {
    final uri = Uri.parse(
      'https://nativemindnet.github.io/cookbook/web/page/7',
    );
    expect(resolver.normalizeToLocation(uri), '/page/7');
  });

  test('custom scheme cookbook with host + path', () {
    final uri = Uri.parse('cookbook://chapter/intro');
    expect(resolver.normalizeToLocation(uri), '/chapter/intro');
  });

  test('custom scheme cookbook with empty host', () {
    final uri = Uri.parse('cookbook:///page/3');
    expect(resolver.normalizeToLocation(uri), '/page/3');
  });

  test('rejects https on wrong host', () {
    final uri = Uri.parse('https://evil.example/page/1');
    expect(resolver.normalizeToLocation(uri), isNull);
  });

  test('region prefix without trailing slash in config', () {
    final c2 = AppConfig.fake(
      webAppBaseUri: Uri.parse('https://example.com/base'),
    );
    final r2 = UriResolver(c2);
    expect(
      r2.normalizeToLocation(Uri.parse('https://example.com/base/foo')),
      '/foo',
    );
  });
}
