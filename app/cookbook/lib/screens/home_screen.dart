import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cookbook')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Vegetarian Cookbook'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/page/1'),
              child: const Text('Open sample page route'),
            ),
          ],
        ),
      ),
    );
  }
}
