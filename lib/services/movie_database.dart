import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie_review_app/models/movie.dart';
import 'package:movie_review_app/models/review.dart';

class MovieDatabase {
  static final MovieDatabase instance = MovieDatabase._init();
  static Database? _database;

  MovieDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movie.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieId INTEGER,
        content TEXT,
        createdAt TEXT,
        FOREIGN KEY(movieId) REFERENCES movies(id)
      );
    ''');
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await instance.database;
    final result = await db.query('movies');
    return result.map((json) => Movie.fromMap(json)).toList();
  }

  Future<void> insertMovie(Movie movie) async {
    final db = await instance.database;
    await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Tambahkan method untuk review
  Future<void> insertReview(Review review) async {
    final db = await instance.database;
    await db.insert('reviews', review.toMap());
  }

  Future<List<Review>> getReviewsByMovieId(int movieId) async {
    final db = await instance.database;
    final result = await db.query(
      'reviews',
      where: 'movieId = ?',
      whereArgs: [movieId],
    );
    return result.map((json) => Review.fromMap(json)).toList();
  }

  Future<void> updateReview(Review review) async {
    final db = await instance.database;
    await db.update(
      'reviews',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  Future<void> deleteReview(int id) async {
    final db = await instance.database;
    await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
