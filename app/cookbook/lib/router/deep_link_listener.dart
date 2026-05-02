import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'uri_resolver.dart';

/// Forwards platform `app_links` events into [GoRouter]. Web relies on [Uri.base] at startup.
class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({
    super.key,
    required this.resolver,
    required this.router,
    required this.child,
  });

  final UriResolver resolver;
  final GoRouter router;
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    _sub = AppLinks().uriLinkStream.listen(_onUri);
  }

  void _onUri(Uri uri) {
    final loc = widget.resolver.normalizeToLocation(uri);
    if (loc != null) {
      widget.router.go(loc);
    }
  }

  @override
  void dispose() {
    final sub = _sub;
    _sub = null;
    if (sub != null) {
      unawaited(sub.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
