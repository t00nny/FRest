import 'package:quit_companion/src/data/database_helper.dart';
import 'package:quit_companion/src/data/models/daily_checkin.dart';
import 'package:quit_companion/src/data/models/urge.dart';

class StatsRepository {
  final DatabaseHelper dbHelper;

  StatsRepository({required this.dbHelper});

  Future<int> addDailyCheckin(DailyCheckin checkin) async {
    return await dbHelper.insert(
      DatabaseHelper.tableDailyCheckins,
      checkin.toMap(),
    );
  }

  Future<DailyCheckin?> getCheckinForDate(DateTime date) async {
    final dateString = date.toIso8601String().substring(0, 10);
    final map = await dbHelper.queryRow(
      DatabaseHelper.tableDailyCheckins,
      'date',
      dateString,
    );
    return map != null ? DailyCheckin.fromMap(map) : null;
  }

  Future<List<DailyCheckin>> getAllCheckins() async {
    final maps = await dbHelper.queryAllRows(
      DatabaseHelper.tableDailyCheckins,
      orderBy: 'date DESC',
    );
    return maps.map((map) => DailyCheckin.fromMap(map)).toList();
  }

  Future<int> addUrge(Urge urge) async {
    return await dbHelper.insert(DatabaseHelper.tableUrges, urge.toMap());
  }

  Future<List<Urge>> getAllUrges() async {
    final maps = await dbHelper.queryAllRows(
      DatabaseHelper.tableUrges,
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => Urge.fromMap(map)).toList();
  }
}
