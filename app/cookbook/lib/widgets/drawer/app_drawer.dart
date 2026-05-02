import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';
import '../../bloc/settings/settings_event.dart';
import '../../models/book_section.dart';

class AppDrawer extends StatelessWidget {
  final List<BookSection> sections;
  final Function(int)? onSectionTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onBookmarksTap;
  final VoidCallback? onSettingsTap;

  const AppDrawer({
    super.key,
    this.sections = const [],
    this.onSectionTap,
    this.onSearchTap,
    this.onBookmarksTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildQuickActions(context),
                  const Divider(),
                  _buildSectionsList(context),
                ],
              ),
            ),
            const Divider(),
            _buildLanguageSelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.brown.shade700,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вегетарианская кухня',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Востока',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Поиск'),
          onTap: () {
            Navigator.pop(context);
            onSearchTap?.call();
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_outline),
          title: const Text('Закладки'),
          onTap: () {
            Navigator.pop(context);
            onBookmarksTap?.call();
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Настройки'),
          onTap: () {
            Navigator.pop(context);
            onSettingsTap?.call();
          },
        ),
      ],
    );
  }

  Widget _buildSectionsList(BuildContext context) {
    if (sections.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Оглавление загружается...'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            'Оглавление',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...sections.map((section) => ListTile(
              title: Text(section.title),
              dense: true,
              onTap: () {
                Navigator.pop(context);
                onSectionTap?.call(section.startPage);
              },
            )),
      ],
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.language, size: 20),
              const SizedBox(width: 8),
              const Text('Язык:'),
              const SizedBox(width: 8),
              DropdownButton<Locale>(
                value: state.locale,
                underline: const SizedBox.shrink(),
                items: SettingsState.supportedLocales.map((locale) {
                  return DropdownMenuItem(
                    value: locale,
                    child: Text(_getLanguageName(locale)),
                  );
                }).toList(),
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<SettingsBloc>().add(
                          SettingsLanguageChanged(locale),
                        );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'th':
        return 'ไทย';
      case 'hi':
        return 'हिंदी';
      case 'ja':
        return '日本語';
      default:
        return locale.languageCode;
    }
  }
}
