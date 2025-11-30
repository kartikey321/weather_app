import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

/// Daily forecast card widget
class DailyForecastCard extends StatelessWidget {
  final DailyWeather daily;

  const DailyForecastCard({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(daily.date);
    final condition = daily.condition;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day name
                SizedBox(
                  width: 60,
                  child: Text(
                    dayName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Weather icon
                if (condition.icon.isNotEmpty)
                  Image.network(
                    condition.icon,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.wb_sunny,
                        size: 40,
                        color: Colors.white,
                      );
                    },
                  )
                else
                  const Icon(Icons.wb_sunny, size: 40, color: Colors.white),

                // Temperature range
                Row(
                  children: [
                    Text(
                      '${daily.temperatureMax.round()}°',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${daily.temperatureMin.round()}°',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
