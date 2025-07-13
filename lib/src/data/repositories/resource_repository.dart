import 'package:quit_companion/src/data/database_helper.dart';
import 'package:quit_companion/src/data/models/reason.dart';
import 'package:quit_companion/src/data/models/resource.dart';

class ResourceRepository {
  final DatabaseHelper dbHelper;

  ResourceRepository({required this.dbHelper});

  Future<int> addReason(String statement) async {
    return await dbHelper.insert(DatabaseHelper.tableReasons, {
      'statement': statement,
    });
  }

  Future<List<Reason>> getAllReasons() async {
    final maps = await dbHelper.queryAllRows(DatabaseHelper.tableReasons);
    return maps.map((map) => Reason.fromMap(map)).toList();
  }

  Future<int> addResource(String instruction) async {
    return await dbHelper.insert(DatabaseHelper.tableResources, {
      'instruction': instruction,
    });
  }

  Future<List<Resource>> getAllResources() async {
    final maps = await dbHelper.queryAllRows(DatabaseHelper.tableResources);
    return maps.map((map) => Resource.fromMap(map)).toList();
  }

  Future<int> deleteReason(int id) async {
    return await dbHelper.delete(DatabaseHelper.tableReasons, 'id', id);
  }

  Future<int> deleteResource(int id) async {
    return await dbHelper.delete(DatabaseHelper.tableResources, 'id', id);
  }
}
