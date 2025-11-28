class WeatherQuery {
  final double? latitude;
  final double? longitude;
  final String? city;

  const WeatherQuery({this.latitude, this.longitude, this.city})
    : assert(
        (latitude != null && longitude != null) || (city != null),
        'WeatherQuery requires coordinates or a city name',
      );

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get hasCity => city != null && city!.isNotEmpty;

  WeatherQuery copyWith({
    double? latitude,
    double? longitude,
    String? city,
    bool clearCoordinates = false,
    bool clearCity = false,
  }) {
    final newLatitude = clearCoordinates ? null : (latitude ?? this.latitude);
    final newLongitude = clearCoordinates
        ? null
        : (longitude ?? this.longitude);
    final newCity = clearCity ? null : (city ?? this.city);

    return WeatherQuery(
      latitude: newLatitude,
      longitude: newLongitude,
      city: newCity,
    );
  }
}
