import 'package:flutter/material.dart';

class PageBackground extends StatelessWidget {
  final String? imagePath;
  final Color? backgroundColor;
  final BoxFit fit;

  const PageBackground({
    super.key,
    this.imagePath,
    this.backgroundColor,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return _buildImageBackground();
    }

    return Container(
      color: backgroundColor ?? const Color(0xFFF3E1C6), // Parchment color
    );
  }

  Widget _buildImageBackground() {
    final path = _resolveImagePath(imagePath!);

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: backgroundColor ?? const Color(0xFFF3E1C6),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 48,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  String _resolveImagePath(String path) {
    // Replace legacy path references
    var resolved = path.replaceAll(r'($APP_BUNDLE)/', 'assets/images/content/');

    // Ensure .png extension if not present
    if (!resolved.contains('.')) {
      resolved = '$resolved.png';
    }

    return resolved;
  }
}

class ParchmentBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  const ParchmentBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFF3E1C6),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
