import 'package:flutter/material.dart';

/// Represents a single layer in the parallax effect
class ParallaxLayer {
  final Widget child;
  final double speed;
  final Alignment alignment;

  const ParallaxLayer({
    required this.child,
    required this.speed,
    this.alignment = Alignment.center,
  });
}

/// Multi-layer parallax widget that creates depth by moving layers at different speeds
class MultiLayerParallax extends StatelessWidget {
  final ScrollController scrollController;
  final List<ParallaxLayer> layers;
  final Widget child;

  const MultiLayerParallax({
    super.key,
    required this.scrollController,
    required this.layers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = scrollController.hasClients ? scrollController.offset : 0.0;

        return Stack(
          children: [
            // Render all parallax layers
            ...layers.map((layer) {
              final parallaxOffset = offset * layer.speed;
              return Positioned.fill(
                top: -parallaxOffset,
                child: Align(
                  alignment: layer.alignment,
                  child: layer.child,
                ),
              );
            }),

            // Main content
            child,
          ],
        );
      },
    );
  }
}
