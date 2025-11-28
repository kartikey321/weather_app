import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:weather_app/features/weather/domain/entities/weather_query.dart';

enum DeepLinkStatus { idle, pending, success, failure }

/// Coordinates deep link handling between splash + weather screens.
class DeepLinkTracker {
  DeepLinkTracker._();

  static final DeepLinkTracker instance = DeepLinkTracker._();

  final ValueNotifier<DeepLinkStatus> statusNotifier =
      ValueNotifier<DeepLinkStatus>(DeepLinkStatus.idle);

  final StreamController<WeatherQuery> _queryController =
      StreamController<WeatherQuery>.broadcast();

  WeatherQuery? _pendingQuery;

  Stream<WeatherQuery> get stream => _queryController.stream;

  WeatherQuery? get pendingQuery => _pendingQuery;
  DeepLinkStatus get status => statusNotifier.value;

  void submitQuery(WeatherQuery query) {
    _pendingQuery = query;
    statusNotifier.value = DeepLinkStatus.pending;
    if (!_queryController.isClosed) {
      _queryController.add(query);
    }
  }

  WeatherQuery? consumePendingQuery() {
    final query = _pendingQuery;
    _pendingQuery = null;
    return query;
  }

  void completeSuccess() {
    statusNotifier.value = DeepLinkStatus.success;
  }

  void completeFailure() {
    statusNotifier.value = DeepLinkStatus.failure;
  }

  void resetStatus() {
    statusNotifier.value = DeepLinkStatus.idle;
  }

  void dispose() {
    _queryController.close();
  }
}
