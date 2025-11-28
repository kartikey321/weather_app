import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

/// Daily forecast card widget
class DailyForecastCard extends StatelessWidget {
  final DailyWeather daily;

  const DailyForecastCard({
    super.key,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(daily.date);
    final condition = daily.condition;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Day name
            SizedBox(
              width: 50,
              child: Text(
                dayName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // Weather icon
            if (condition.icon.isNotEmpty)
              Image.network(
                condition.icon,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.wb_sunny, size: 40);
                },
              )
            else
              const Icon(Icons.wb_sunny, size: 40),

            // Temperature range
            Row(
              children: [
                Text(
                  '${daily.temperatureMax.round()}°',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${daily.temperatureMin.round()}°',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
