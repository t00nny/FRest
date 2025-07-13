import 'package:quit_companion/src/data/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final DatabaseHelper dbHelper;
  final SharedPreferences prefs;
  static const _onboardingCompleteKey = 'onboarding_complete';

  SettingsRepository({required this.dbHelper, required this.prefs});

  Future<void> setOnboardingComplete() async {
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  Future<bool> isOnboardingComplete() async {
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> saveSobrietyStartDate(DateTime date) async {
    await dbHelper.insert(DatabaseHelper.tableSettings, {
      'key': 'sobrietyStartDate',
      'value': date.toIso8601String(),
    });
  }

  Future<DateTime?> getSobrietyStartDate() async {
    final setting = await dbHelper.queryRow(
      DatabaseHelper.tableSettings,
      'key',
      'sobrietyStartDate',
    );
    return setting != null ? DateTime.parse(setting['value']) : null;
  }
}
