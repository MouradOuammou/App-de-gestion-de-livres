import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;

      sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await databaseFactory.getDatabasesPath(), 'books_database.db');
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id TEXT PRIMARY KEY,
              title TEXT,
              author TEXT,
              imageUrl TEXT
            )
          ''');
        },
      ),
    );
  }

  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      _tableName,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
