// lib/src/features/home/home_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quit_companion/src/data/models/daily_checkin.dart';
import 'package:quit_companion/src/data/repositories/settings_repository.dart';
import 'package:quit_companion/src/data/repositories/stats_repository.dart';
import 'package:quit_companion/src/utils/duration_formatter.dart';

class HomeProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final StatsRepository _statsRepository;

  HomeProvider({
    required SettingsRepository settingsRepository,
    required StatsRepository statsRepository,
  })  : _settingsRepository = settingsRepository,
        _statsRepository = statsRepository {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DateTime? _sobrietyStartDate;
  Duration _currentStreak = Duration.zero;
  String _formattedStreak = "00h : 00m : 00s";
  Timer? _timer;

  Duration get currentStreak => _currentStreak;
  String get formattedStreak => _formattedStreak;

  DailyCheckin? _todayCheckin;
  DailyCheckin? get todayCheckin => _todayCheckin;
  bool get isCheckinComplete => _todayCheckin != null;

  Future<void> _init() async {
    _sobrietyStartDate = await _settingsRepository.getSobrietyStartDate();
    await _fetchTodayCheckin();
    _startTimer();
    _isLoading = false;
    notifyListeners();
  }

  // CORRECTED: Added public method to refresh data
  Future<void> refreshData() async {
    await _init();
  }

  void _startTimer() {
    if (_sobrietyStartDate == null) return;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentStreak = DateTime.now().difference(_sobrietyStartDate!);
      _formattedStreak = formatDuration(_currentStreak);
      notifyListeners();
    });
  }

  Future<void> _fetchTodayCheckin() async {
    final today = DateTime.now();
    _todayCheckin = await _statsRepository.getCheckinForDate(today);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
