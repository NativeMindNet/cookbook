import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Maps platform / web [Uri] into a [GoRouter] location (path + optional query).
class UriResolver {
  const UriResolver(this.config);

  final AppConfig config;

  /// Web: [Uri.base] from the browser (includes path under base href).
  String? initialWebLocation(Uri browserUri) {
    if (!kIsWeb) return null;
    return normalizeToLocation(browserUri);
  }

  /// Resolves [uri] from app link, custom scheme, or full web URL.
  String? normalizeToLocation(Uri uri) {
    final scheme = uri.scheme.toLowerCase();

    if (scheme == 'cookbook') {
      return _fromCustomScheme(uri);
    }

    if (scheme == 'http' || scheme == 'https') {
      return _stripWebBase(uri);
    }

    return null;
  }

  String _fromCustomScheme(Uri uri) {
    final host = uri.host;
    final path = uri.path;
    if (host.isEmpty) {
      return _ensureLeadingSlash(path.isEmpty ? '/' : path);
    }
    if (path.isEmpty || path == '/') {
      return '/$host';
    }
    return '/$host$path';
  }

  String? _stripWebBase(Uri uri) {
    final base = config.webAppBaseUri;
    if (uri.host.toLowerCase() != base.host.toLowerCase()) {
      return null;
    }
    final prefix = config.webPathPrefix;
    var path = uri.path;
    if (!path.startsWith(prefix)) {
      return null;
    }
    var rest = path.substring(prefix.length);
    if (rest.isEmpty) {
      rest = '/';
    } else if (!rest.startsWith('/')) {
      rest = '/$rest';
    }
    if (uri.hasQuery) {
      return '$rest?${uri.query}';
    }
    return rest;
  }

  static String _ensureLeadingSlash(String path) {
    if (path.isEmpty || path == '/') return '/';
    return path.startsWith('/') ? path : '/$path';
  }
}
