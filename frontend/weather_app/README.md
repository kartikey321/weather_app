# weather_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Weather Features

- Enter latitude/longitude manually or search by city name directly from the weather screen.
- Copy a deep link (e.g. `weatherapp://weather?city=Berlin`) from the weather screen share icon to reopen the same location.
- Coordinate-based links such as `weatherapp://weather?lat=37.7749&lon=-122.4194` are also supported on Android/iOS thanks to the bundled intent filters / URL schemes.
- On the web build, the browser URL updates (e.g. `https://your-host/weather?city=Berlin`) so bookmarking or sharing the current city works the same way as on mobile.
