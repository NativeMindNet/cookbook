import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageScreen extends StatelessWidget {
  const PageScreen({super.key, required this.pageId});

  final String pageId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text('Page $pageId'),
      ),
      body: Center(
        child: Text(
          'Deep link target: /page/$pageId\n'
          '(Wire this route to book content when the reader UI is ready.)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
