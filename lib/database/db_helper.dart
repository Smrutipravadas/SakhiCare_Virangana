import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sakhi_care/models/health.dart';
import 'package:sakhi_care/models/care.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sakhicare.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood INTEGER,
        sleepHours INTEGER,
        workHours INTEGER,
        date TEXT
      )
    ''');
    Future<void> insertHealthLog(HealthLog log) async {
      final db = await instance.database;
      await db.insert('health_logs', log.toMap());
    }

    Future<List<Map<String, dynamic>>> getLast7DaysLogs() async {
      final db = await instance.database;
      return await db.rawQuery(
        "SELECT * FROM health_logs ORDER BY date DESC LIMIT 7",
      );
    }

    Future<void> saveCareCircle(CareCircle person) async {
      final db = await instance.database;
      await db.delete('care_circle'); // only one trusted person
      await db.insert('care_circle', person.toMap());
    }

    Future<Map<String, dynamic>?> getCareCircle() async {
      final db = await instance.database;
      final result = await db.query('care_circle', limit: 1);
      return result.isNotEmpty ? result.first : null;
    }

    await db.execute('''
      CREATE TABLE care_circle (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        relationship TEXT
      )
    ''');
  }
}
