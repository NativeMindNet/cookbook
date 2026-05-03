import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/share/share_current_route_button.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookbook'),
        actions: const [ShareCurrentRouteButton()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No screen for:\n$location',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
