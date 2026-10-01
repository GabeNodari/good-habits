import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('good_habits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habit_records (
        habit_id TEXT NOT NULL,
        date TEXT NOT NULL,
        is_completed INTEGER NOT NULL,
        PRIMARY KEY (habit_id, date)
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_habit_records_date ON habit_records(date)',
    );
  }

  /// Alterna o status do hábito para a data dada (1 para 0, ou 0/ausente para 1)
  Future<bool> toggleHabitRecord(String habitId, String date) async {
    final db = await database;
    final existing = await db.query(
      'habit_records',
      where: 'habit_id = ? AND date = ?',
      whereArgs: [habitId, date],
    );

    bool newStatus = true;
    if (existing.isNotEmpty) {
      final current = (existing.first['is_completed'] as int) == 1;
      newStatus = !current;
    }

    await db.insert('habit_records', {
      'habit_id': habitId,
      'date': date,
      'is_completed': newStatus ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return newStatus;
  }

  /// Define o status explicitamente
  Future<void> setHabitRecord(
    String habitId,
    String date,
    bool isCompleted,
  ) async {
    final db = await database;
    await db.insert('habit_records', {
      'habit_id': habitId,
      'date': date,
      'is_completed': isCompleted ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retorna um mapa de {habit_id: is_completed} para o dia informado
  Future<Map<String, bool>> getDayRecords(String date) async {
    final db = await database;
    final result = await db.query(
      'habit_records',
      where: 'date = ?',
      whereArgs: [date],
    );

    final map = <String, bool>{};
    for (final row in result) {
      final id = row['habit_id'] as String;
      final completed = (row['is_completed'] as int) == 1;
      map[id] = completed;
    }
    return map;
  }

  /// Retorna todos os registros entre startDate e endDate (inclusive)
  Future<List<Map<String, dynamic>>> getRecordsInRange(
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    return await db.query(
      'habit_records',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date ASC',
    );
  }

  /// Retorna todos os registros do banco ordenados por data
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query('habit_records', orderBy: 'date ASC');
  }
}
