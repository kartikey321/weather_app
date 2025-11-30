import 'dart:math';
import 'package:flutter/material.dart';

/// Animated clouds layer for parallax effect
class CloudsLayer extends StatefulWidget {
  final int cloudCount;
  final Color cloudColor;
  final double opacity;

  const CloudsLayer({
    super.key,
    this.cloudCount = 5,
    this.cloudColor = Colors.white,
    this.opacity = 0.3,
  });

  @override
  State<CloudsLayer> createState() => _CloudsLayerState();
}

class _CloudsLayerState extends State<CloudsLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<CloudData> _clouds = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Generate random clouds
    final random = Random();
    for (int i = 0; i < widget.cloudCount; i++) {
      _clouds.add(CloudData(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.6, // Keep clouds in upper 60% of screen
        size: 80 + random.nextDouble() * 120,
        speed: 0.001 + random.nextDouble() * 0.002,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CloudsPainter(
            clouds: _clouds,
            progress: _controller.value,
            color: widget.cloudColor.withOpacity(widget.opacity),
          ),
          child: Container(),
        );
      },
    );
  }
}

class CloudData {
  final double x;
  final double y;
  final double size;
  final double speed;

  CloudData({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class CloudsPainter extends CustomPainter {
  final List<CloudData> clouds;
  final double progress;
  final Color color;

  CloudsPainter({
    required this.clouds,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final cloud in clouds) {
      final x = ((cloud.x + progress * cloud.speed) % 1.0) * size.width;
      final y = cloud.y * size.height;

      _drawCloud(canvas, paint, Offset(x, y), cloud.size);
    }
  }

  void _drawCloud(Canvas canvas, Paint paint, Offset position, double size) {
    // Draw a simple cloud using circles
    canvas.drawCircle(position, size * 0.3, paint);
    canvas.drawCircle(
      position + Offset(size * 0.3, 0),
      size * 0.35,
      paint,
    );
    canvas.drawCircle(
      position + Offset(size * 0.6, 0),
      size * 0.3,
      paint,
    );
    canvas.drawCircle(
      position + Offset(size * 0.3, size * 0.1),
      size * 0.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(CloudsPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

/// Animated sun layer
class SunLayer extends StatefulWidget {
  final double size;
  final Color color;

  const SunLayer({
    super.key,
    this.size = 120,
    this.color = const Color(0xFFFFD700),
  });

  @override
  State<SunLayer> createState() => _SunLayerState();
}

class _SunLayerState extends State<SunLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 80, right: 40),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: SunPainter(
                color: widget.color,
                rotation: _controller.value * 2 * pi,
              ),
            );
          },
        ),
      ),
    );
  }
}

class SunPainter extends CustomPainter {
  final Color color;
  final double rotation;

  SunPainter({
    required this.color,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.7) // Increased opacity
      ..style = PaintingStyle.fill;

    // Draw sun rays
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * pi / 180;
      final x1 = cos(angle) * radius * 0.6;
      final y1 = sin(angle) * radius * 0.6;
      final x2 = cos(angle) * radius;
      final y2 = sin(angle) * radius;

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = color.withOpacity(0.6) // Increased opacity
          ..strokeWidth = 4 // Thicker rays
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.restore();

    // Draw sun circle
    canvas.drawCircle(center, radius * 0.5, paint);

    // Draw bright center
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()
        ..color = color.withOpacity(0.8) // Increased opacity
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
  }

  @override
  bool shouldRepaint(SunPainter oldDelegate) => rotation != oldDelegate.rotation;
}

/// Animated moon layer
class MoonLayer extends StatelessWidget {
  final double size;
  final Color color;

  const MoonLayer({
    super.key,
    this.size = 100,
    this.color = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 80, right: 40),
        child: CustomPaint(
          size: Size(size, size),
          painter: MoonPainter(color: color),
        ),
      ),
    );
  }
}

class MoonPainter extends CustomPainter {
  final Color color;

  MoonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw moon
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.8) // Increased opacity
        ..style = PaintingStyle.fill,
    );

    // Draw moon glow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.6) // Increased opacity
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );

    // Draw craters
    final craterPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center + Offset(-radius * 0.3, -radius * 0.2),
      radius * 0.15,
      craterPaint,
    );
    canvas.drawCircle(
      center + Offset(radius * 0.2, radius * 0.3),
      radius * 0.2,
      craterPaint,
    );
    canvas.drawCircle(
      center + Offset(radius * 0.3, -radius * 0.4),
      radius * 0.1,
      craterPaint,
    );
  }

  @override
  bool shouldRepaint(MoonPainter oldDelegate) => false;
}

/// Animated stars layer
class StarsLayer extends StatefulWidget {
  final int starCount;
  final Color starColor;

  const StarsLayer({
    super.key,
    this.starCount = 50,
    this.starColor = Colors.white,
  });

  @override
  State<StarsLayer> createState() => _StarsLayerState();
}

class _StarsLayerState extends State<StarsLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<StarData> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Generate random stars
    final random = Random();
    for (int i = 0; i < widget.starCount; i++) {
      _stars.add(StarData(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.7, // Keep stars in upper 70% of screen
        size: 1.0 + random.nextDouble() * 2.5,
        twinkleOffset: random.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarsPainter(
            stars: _stars,
            twinkle: _controller.value,
            color: widget.starColor,
          ),
          child: Container(),
        );
      },
    );
  }
}

class StarData {
  final double x;
  final double y;
  final double size;
  final double twinkleOffset;

  StarData({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleOffset,
  });
}

class StarsPainter extends CustomPainter {
  final List<StarData> stars;
  final double twinkle;
  final Color color;

  StarsPainter({
    required this.stars,
    required this.twinkle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final x = star.x * size.width;
      final y = star.y * size.height;

      // Calculate twinkle effect
      final twinkleValue = sin((twinkle + star.twinkleOffset) * 2 * pi);
      final opacity = 0.3 + (twinkleValue * 0.4);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw star
      canvas.drawCircle(Offset(x, y), star.size, paint);

      // Draw glow
      canvas.drawCircle(
        Offset(x, y),
        star.size * 1.5,
        Paint()
          ..color = color.withOpacity(opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => twinkle != oldDelegate.twinkle;
}
