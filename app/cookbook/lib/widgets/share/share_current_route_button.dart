import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_config.dart';
import '../../router/share_web_uri.dart';

/// Shares the canonical web URL for the current (or overridden) route.
class ShareCurrentRouteButton extends StatelessWidget {
  const ShareCurrentRouteButton({
    super.key,
    this.locationOverride,
    this.icon = Icons.share,
    this.iconColor,
  });

  /// When set (e.g. `/book/12`), used instead of [GoRouterState.uri].
  final String? locationOverride;

  final IconData icon;
  final Color? iconColor;

  String _location(BuildContext context) {
    if (locationOverride != null) {
      return locationOverride!;
    }
    final uri = GoRouterState.of(context).uri;
    final path = uri.path.isEmpty ? '/' : uri.path;
    if (!uri.hasQuery) {
      return path;
    }
    return '$path?${uri.query}';
  }

  Future<void> _onPressed(BuildContext context) async {
    final config = RepositoryProvider.of<AppConfig>(context);
    final location = _location(context);
    final shareUri = buildShareWebUri(config, location);

    try {
      await SharePlus.instance.share(ShareParams(uri: shareUri));
    } on PlatformException catch (_) {
      if (!context.mounted) return;
      await Clipboard.setData(ClipboardData(text: shareUri.toString()));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ссылка скопирована в буфер обмена')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: iconColor),
      tooltip: 'Поделиться ссылкой',
      onPressed: () => _onPressed(context),
    );
  }
}
