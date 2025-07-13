import 'package:quit_companion/src/data/database_helper.dart';
import 'package:quit_companion/src/data/models/journal_entry.dart';

class JournalRepository {
  final DatabaseHelper dbHelper;

  JournalRepository({required this.dbHelper});

  Future<int> addJournalEntry(JournalEntry entry) async {
    return await dbHelper.insert(
      DatabaseHelper.tableJournalEntries,
      entry.toMap(),
    );
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    final maps = await dbHelper.queryAllRows(
      DatabaseHelper.tableJournalEntries,
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<int> deleteJournalEntry(int id) async {
    return await dbHelper.delete(DatabaseHelper.tableJournalEntries, 'id', id);
  }
}
