import '../config/app_config.dart';

/// Builds the public HTTPS URL for the web app from [AppConfig.webAppBaseUri]
/// and a [GoRouter]-style location (`/path` plus optional `?query`).
///
/// Inverse of [UriResolver.normalizeToLocation] for same-host HTTPS URLs.
Uri buildShareWebUri(AppConfig config, String location) {
  var loc = location.trim();
  if (loc.isEmpty) {
    loc = '/';
  } else if (!loc.startsWith('/')) {
    loc = '/$loc';
  }

  final locUri = Uri.parse(loc);
  final base = config.webAppBaseUri;
  final basePath = base.path;
  var locPath = locUri.path;
  if (locPath.isEmpty) {
    locPath = '/';
  }
  final tail = locPath.startsWith('/') ? locPath.substring(1) : locPath;
  final mergedPath = basePath.endsWith('/')
      ? '$basePath$tail'
      : '$basePath/$tail';

  return base.replace(
    path: mergedPath,
    query: locUri.hasQuery ? locUri.query : null,
  );
}
