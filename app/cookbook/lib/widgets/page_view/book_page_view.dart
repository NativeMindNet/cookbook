import 'package:flutter/material.dart';
import '../../models/book_page.dart';
import '../../models/paragraph.dart';
import 'page_background.dart';
import 'page_content.dart';

class BookPageView extends StatelessWidget {
  final BookPage page;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;
  final Function(int)? onControlTap;

  const BookPageView({
    super.key,
    required this.page,
    this.onTapLeft,
    this.onTapRight,
    this.onControlTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(context, details),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background layer
          if (page.hasBackground || page.backgroundColor != null)
            PageBackground(
              imagePath: page.backgroundImagePath,
              backgroundColor: page.backgroundColor,
            ),

          // Content layer
          SafeArea(
            child: PageContent(paragraphs: page.paragraphs),
          ),

          // Controls layer would go here
          // AnimationsOverlay would go here
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, TapUpDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;

    // Tap on left third = previous page
    // Tap on right third = next page
    // Tap on middle = toggle UI
    if (tapX < screenWidth / 3) {
      onTapLeft?.call();
    } else if (tapX > screenWidth * 2 / 3) {
      onTapRight?.call();
    }
  }
}

class TwoPageBookView extends StatelessWidget {
  final BookPage leftPage;
  final BookPage? rightPage;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;

  const TwoPageBookView({
    super.key,
    required this.leftPage,
    this.rightPage,
    this.onTapLeft,
    this.onTapRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left page
        Expanded(
          child: BookPageView(
            page: leftPage,
            onTapLeft: onTapLeft,
            onTapRight: rightPage != null ? null : onTapRight,
          ),
        ),

        // Spine divider
        Container(
          width: 4,
          color: Colors.brown.shade800,
        ),

        // Right page
        Expanded(
          child: rightPage != null
              ? BookPageView(
                  page: rightPage!,
                  onTapLeft: null,
                  onTapRight: onTapRight,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
