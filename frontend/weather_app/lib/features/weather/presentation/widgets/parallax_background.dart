import 'package:flutter/material.dart';

/// Parallax background that responds to scroll position
class ParallaxBackground extends StatelessWidget {
  final Widget child;
  final Widget? backgroundWidget;
  final ScrollController scrollController;
  final List<Color> gradientColors;
  final double parallaxStrength;

  const ParallaxBackground({
    super.key,
    required this.child,
    this.backgroundWidget,
    required this.scrollController,
    required this.gradientColors,
    this.parallaxStrength = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = scrollController.hasClients ? scrollController.offset : 0.0;
        final parallaxOffset = offset * parallaxStrength;

        return Stack(
          children: [
            // Background widget (Video) with parallax
            if (backgroundWidget != null)
              Positioned.fill(
                top: -parallaxOffset,
                child: backgroundWidget!,
              ),

            // Background gradient with parallax (overlay)
            Positioned.fill(
              top: -parallaxOffset,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: backgroundWidget != null
                        ? gradientColors.map((c) => c.withOpacity(0.7)).toList()
                        : gradientColors,
                  ),
                ),
              ),
            ),

            // Child content
            child,
          ],
        );
      },
    );
  }
}
