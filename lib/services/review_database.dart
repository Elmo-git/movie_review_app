import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie_review_app/models/review.dart';

class ReviewDatabase {
  static final ReviewDatabase instance = ReviewDatabase._init();
  static Database? _database;

  ReviewDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reviews.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieId TEXT NOT NULL,
        reviewer TEXT NOT NULL,
        comment TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertReview(Review review) async {
    final db = await instance.database;
    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Review>> getReviewsByMovie(String movieId) async {
    final db = await instance.database;

    final result = await db.query(
      'reviews',
      where: 'movieId = ?', // Query berdasarkan movieId
      whereArgs: [movieId], // Cari berdasarkan movieId yang sesuai
    );

    return result.map((json) => Review.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
