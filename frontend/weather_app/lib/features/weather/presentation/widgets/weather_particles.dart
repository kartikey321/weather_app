import 'dart:math';
import 'package:flutter/material.dart';

/// Animated rain particles layer
class RainParticlesLayer extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double intensity; // 0.0 to 1.0

  const RainParticlesLayer({
    super.key,
    this.particleCount = 100,
    this.color = const Color(0xFF4FC3F7),
    this.intensity = 0.7,
  });

  @override
  State<RainParticlesLayer> createState() => _RainParticlesLayerState();
}

class _RainParticlesLayerState extends State<RainParticlesLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RainParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Generate rain particles
    final random = Random();
    final count = (widget.particleCount * widget.intensity).round();
    for (int i = 0; i < count; i++) {
      _particles.add(RainParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        length: 15 + random.nextDouble() * 25,
        speed: 0.3 + random.nextDouble() * 0.4,
        thickness: 1.0 + random.nextDouble() * 1.5,
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
          painter: RainPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
          child: Container(),
        );
      },
    );
  }
}

class RainParticle {
  final double x;
  final double y;
  final double length;
  final double speed;
  final double thickness;

  RainParticle({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.thickness,
  });
}

class RainPainter extends CustomPainter {
  final List<RainParticle> particles;
  final double progress;
  final Color color;

  RainPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = ((particle.y + progress * particle.speed) % 1.0) * size.height;

      final paint = Paint()
        ..color = color.withOpacity(0.6)
        ..strokeWidth = particle.thickness
        ..strokeCap = StrokeCap.round;

      // Draw raindrop as a line
      canvas.drawLine(
        Offset(x, y),
        Offset(x + 2, y + particle.length), // Slight angle for realism
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RainPainter oldDelegate) => progress != oldDelegate.progress;
}

/// Animated snow particles layer
class SnowParticlesLayer extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double intensity; // 0.0 to 1.0

  const SnowParticlesLayer({
    super.key,
    this.particleCount = 80,
    this.color = Colors.white,
    this.intensity = 0.7,
  });

  @override
  State<SnowParticlesLayer> createState() => _SnowParticlesLayerState();
}

class _SnowParticlesLayerState extends State<SnowParticlesLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SnowParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Generate snow particles
    final random = Random();
    final count = (widget.particleCount * widget.intensity).round();
    for (int i = 0; i < count; i++) {
      _particles.add(SnowParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 4,
        speed: 0.1 + random.nextDouble() * 0.15,
        swingAmplitude: 0.02 + random.nextDouble() * 0.04,
        swingFrequency: 0.5 + random.nextDouble() * 1.5,
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
          painter: SnowPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
          child: Container(),
        );
      },
    );
  }
}

class SnowParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double swingAmplitude;
  final double swingFrequency;

  SnowParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.swingAmplitude,
    required this.swingFrequency,
  });
}

class SnowPainter extends CustomPainter {
  final List<SnowParticle> particles;
  final double progress;
  final Color color;

  SnowPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final baseY = ((particle.y + progress * particle.speed) % 1.0) * size.height;

      // Add horizontal swing motion
      final swing = sin(progress * 2 * pi * particle.swingFrequency) *
                   particle.swingAmplitude * size.width;
      final x = particle.x * size.width + swing;
      final y = baseY;

      final paint = Paint()
        ..color = color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      // Draw snowflake as a circle
      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Draw subtle glow
      canvas.drawCircle(
        Offset(x, y),
        particle.size * 1.5,
        Paint()
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => progress != oldDelegate.progress;
}

/// Drizzle particles (lighter rain)
class DrizzleParticlesLayer extends StatefulWidget {
  final int particleCount;
  final Color color;

  const DrizzleParticlesLayer({
    super.key,
    this.particleCount = 60,
    this.color = const Color(0xFF81D4FA),
  });

  @override
  State<DrizzleParticlesLayer> createState() => _DrizzleParticlesLayerState();
}

class _DrizzleParticlesLayerState extends State<DrizzleParticlesLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<DrizzleParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Generate drizzle particles
    final random = Random();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(DrizzleParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 1.5 + random.nextDouble() * 2,
        speed: 0.2 + random.nextDouble() * 0.25,
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
          painter: DrizzlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
          child: Container(),
        );
      },
    );
  }
}

class DrizzleParticle {
  final double x;
  final double y;
  final double size;
  final double speed;

  DrizzleParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class DrizzlePainter extends CustomPainter {
  final List<DrizzleParticle> particles;
  final double progress;
  final Color color;

  DrizzlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = ((particle.y + progress * particle.speed) % 1.0) * size.height;

      final paint = Paint()
        ..color = color.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      // Draw small droplet
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(DrizzlePainter oldDelegate) => progress != oldDelegate.progress;
}
