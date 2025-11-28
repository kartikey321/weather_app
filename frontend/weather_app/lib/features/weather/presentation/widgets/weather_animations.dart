import 'dart:math';
import 'package:flutter/material.dart';

/// Base class for weather animations
abstract class WeatherAnimation extends StatefulWidget {
  const WeatherAnimation({super.key});
}

/// Animated rain effect
class RainAnimation extends WeatherAnimation {
  final int dropCount;

  const RainAnimation({super.key, this.dropCount = 50});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_RainDrop> _drops = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Initialize rain drops
    for (int i = 0; i < widget.dropCount; i++) {
      _drops.add(_RainDrop(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.5 + _random.nextDouble() * 0.5,
        length: 10 + _random.nextDouble() * 20,
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
          painter: _RainPainter(_drops, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _RainDrop {
  final double x;
  final double y;
  final double speed;
  final double length;

  _RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
  });
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> drops;
  final double progress;

  _RainPainter(this.drops, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (final drop in drops) {
      final x = drop.x * size.width;
      final y = ((drop.y + progress * drop.speed) % 1.0) * size.height;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RainPainter oldDelegate) => true;
}

/// Animated snow effect
class SnowAnimation extends WeatherAnimation {
  final int flakeCount;

  const SnowAnimation({super.key, this.flakeCount = 30});

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Snowflake> _flakes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Initialize snowflakes
    for (int i = 0; i < widget.flakeCount; i++) {
      _flakes.add(_Snowflake(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.1 + _random.nextDouble() * 0.3,
        size: 2 + _random.nextDouble() * 4,
        drift: (_random.nextDouble() - 0.5) * 0.2,
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
          painter: _SnowPainter(_flakes, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _Snowflake {
  final double x;
  final double y;
  final double speed;
  final double size;
  final double drift;

  _Snowflake({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.drift,
  });
}

class _SnowPainter extends CustomPainter {
  final List<_Snowflake> flakes;
  final double progress;

  _SnowPainter(this.flakes, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (final flake in flakes) {
      final x = (flake.x + sin(progress * 2 * pi) * flake.drift) * size.width;
      final y = ((flake.y + progress * flake.speed) % 1.0) * size.height;

      canvas.drawCircle(Offset(x, y), flake.size, paint);
    }
  }

  @override
  bool shouldRepaint(_SnowPainter oldDelegate) => true;
}

/// Animated clouds effect
class CloudsAnimation extends WeatherAnimation {
  final int cloudCount;

  const CloudsAnimation({super.key, this.cloudCount = 5});

  @override
  State<CloudsAnimation> createState() => _CloudsAnimationState();
}

class _CloudsAnimationState extends State<CloudsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Cloud> _clouds = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Initialize clouds
    for (int i = 0; i < widget.cloudCount; i++) {
      _clouds.add(_Cloud(
        y: 0.1 + _random.nextDouble() * 0.3,
        speed: 0.05 + _random.nextDouble() * 0.1,
        size: 50 + _random.nextDouble() * 100,
        opacity: 0.1 + _random.nextDouble() * 0.2,
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
          painter: _CloudsPainter(_clouds, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _Cloud {
  final double y;
  final double speed;
  final double size;
  final double opacity;

  _Cloud({
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class _CloudsPainter extends CustomPainter {
  final List<_Cloud> clouds;
  final double progress;

  _CloudsPainter(this.clouds, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final cloud in clouds) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(cloud.opacity)
        ..style = PaintingStyle.fill;

      final x = ((progress * cloud.speed) % 1.2 - 0.2) * size.width;
      final y = cloud.y * size.height;

      // Draw cloud as overlapping circles
      canvas.drawCircle(Offset(x, y), cloud.size * 0.6, paint);
      canvas.drawCircle(Offset(x + cloud.size * 0.5, y), cloud.size * 0.5, paint);
      canvas.drawCircle(Offset(x + cloud.size, y), cloud.size * 0.6, paint);
      canvas.drawCircle(Offset(x + cloud.size * 0.5, y - cloud.size * 0.3), cloud.size * 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(_CloudsPainter oldDelegate) => true;
}

/// Sun rays animation for clear weather
class SunRaysAnimation extends WeatherAnimation {
  const SunRaysAnimation({super.key});

  @override
  State<SunRaysAnimation> createState() => _SunRaysAnimationState();
}

class _SunRaysAnimationState extends State<SunRaysAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
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
          painter: _SunRaysPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _SunRaysPainter extends CustomPainter {
  final double progress;

  _SunRaysPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.8, size.height * 0.1);
    final rayCount = 12;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * pi + progress * 2 * pi;
      final path = Path();

      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + cos(angle - 0.1) * 100,
        center.dy + sin(angle - 0.1) * 100,
      );
      path.lineTo(
        center.dx + cos(angle + 0.1) * 100,
        center.dy + sin(angle + 0.1) * 100,
      );
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SunRaysPainter oldDelegate) => true;
}
