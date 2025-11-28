import 'package:flutter/material.dart';

/// Temperature display widget
class TemperatureDisplay extends StatelessWidget {
  final double temperature;
  final String? description;
  final String? icon;

  const TemperatureDisplay({
    super.key,
    required this.temperature,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Image.network(
            'https://openweathermap.org/img/wn/$icon@4x.png',
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.wb_sunny, size: 120);
            },
          ),
        Text(
          '${temperature.round()}°C',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (description != null)
          Text(
            description!,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
      ],
    );
  }
}
