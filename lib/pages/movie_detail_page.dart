import 'package:flutter/material.dart';
import 'package:movie_review_app/models/movie.dart';
import 'package:movie_review_app/models/review.dart';
import 'package:movie_review_app/services/review_database.dart'; // Import review database

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  MovieDetailPage({required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final TextEditingController _reviewController = TextEditingController();
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  // Ambil review berdasarkan movieId dari database lokal
  void _loadReviews() async {
    final reviews = await ReviewDatabase.instance.getReviewsByMovie(
      widget.movie.id.toString(),
    );
    setState(() {
      _reviews = reviews;
    });
  }

  void _submitReview() async {
    if (_reviewController.text.isNotEmpty) {
      final review = Review(
        id: null,
        movieId: widget.movie.id.toString(),
        content: _reviewController.text,
        timestamp: DateTime.now(),
      );
      await ReviewDatabase.instance.insertReview(review);
      _reviewController.clear();
      _loadReviews(); // Reload reviews setelah submit
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(child: Image.network(widget.movie.posterPath, height: 300)),
            SizedBox(height: 16),
            Text(
              widget.movie.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.movie.overview, style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text(
              "Reviews:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            ..._reviews.map((r) => ListTile(title: Text(r.content))),
            SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Tulis review kamu...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text("Kirim Review"),
            ),
          ],
        ),
      ),
    );
  }
}
