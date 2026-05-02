import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../platform/browser_hints.dart';
import '../services/store_country_resolver.dart';

const _kDismissedKey = 'install_app_prompt_dismissed_v1';

/// Bottom prompt on mobile web to open the native store from [.env].
class InstallAppPrompt extends StatefulWidget {
  const InstallAppPrompt({super.key, required this.config});

  final AppConfig config;

  @override
  State<InstallAppPrompt> createState() => _InstallAppPromptState();
}

class _InstallAppPromptState extends State<InstallAppPrompt> {
  bool? _dismissed;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb || !isMobileWebBrowser) return;
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool(_kDismissedKey) ?? false;
    if (!mounted) return;
    setState(() {
      _dismissed = dismissed;
      _visible = !dismissed;
    });
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDismissedKey, true);
    if (!mounted) return;
    setState(() {
      _dismissed = true;
      _visible = false;
    });
  }

  Future<void> _openStore() async {
    final lang = browserLanguageTag;
    final region = StoreCountryResolver.regionFromLanguageTag(lang);
    final vendor = StoreCountryResolver.pickVendor(
      treatAsIosBrowser: isIosMobileWebBrowser,
      regionIso3166Alpha2: region,
    );
    final uri = StoreCountryResolver.urlFor(vendor, widget.config);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !isMobileWebBrowser) return const SizedBox.shrink();
    if (_dismissed == null || !_visible) return const SizedBox.shrink();

    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              const Icon(Icons.install_mobile, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Install the Cookbook app for the best experience.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: _dismiss,
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: _openStore,
                child: const Text('Install'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
