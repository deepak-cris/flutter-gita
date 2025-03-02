import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            chapter INTEGER,
            verse INTEGER,
            note_text TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertNote(int chapter, int verse, String noteText) async {
    final db = await database;
    await db.insert('notes', {
      'chapter': chapter,
      'verse': verse,
      'note_text': noteText,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getNote(int chapter, int verse) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'chapter = ? AND verse = ?',
      whereArgs: [chapter, verse],
    );
    if (maps.isNotEmpty) {
      return maps.first['note_text'];
    }
    return null;
  }
}
