import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('games.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        name TEXT,
        released TEXT,
        rating REAL,
        background_image TEXT
      )
    ''');
  }

  Future<void> addFavorite(Game game) async {
    final db = await instance.database;
    await db.insert('favorites', game.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(int id) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Game>> getFavorites() async {
    final db = await instance.database;
    final maps = await db.query('favorites');
    return maps.map((json) => Game(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      rating: json['rating'],
      backgroundImage: json['background_image'],
    )).toList();
  }
}