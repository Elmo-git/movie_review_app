import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/review.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'movie_reviews.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reviews (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            movieId INTEGER,
            content TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertReview(Review review) async {
    final db = await database;
    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Review>> getReviewsByMovieId(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
      where: 'movieId = ?',
      whereArgs: [movieId],
    );

    return List.generate(maps.length, (i) => Review.fromMap(maps[i]));
  }
}
