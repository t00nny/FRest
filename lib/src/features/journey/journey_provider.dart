// lib/src/features/journey/journey_provider.dart

import 'package:flutter/material.dart';
import 'package:quit_companion/src/data/models/daily_checkin.dart';
import 'package:quit_companion/src/data/repositories/stats_repository.dart';

class JourneyProvider extends ChangeNotifier {
  final StatsRepository _statsRepository;

  JourneyProvider(this._statsRepository) {
    fetchData();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<DailyCheckin> _checkins = [];
  List<DailyCheckin> get checkins => _checkins;

  Map<DateTime, int> get calendarHeatmapData {
    final Map<DateTime, int> data = {};
    for (var checkin in _checkins) {
      final day = DateTime(
        checkin.date.year,
        checkin.date.month,
        checkin.date.day,
      );
      data[day] = checkin.score;
    }
    return data;
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    _checkins = await _statsRepository.getAllCheckins();
    _isLoading = false;
    notifyListeners();
  }
}
