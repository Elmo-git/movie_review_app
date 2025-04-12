import 'package:flutter/material.dart';
import 'package:movie_review_app/models/movie.dart';
import 'package:movie_review_app/models/review.dart';
import 'package:movie_review_app/services/movie_database.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  MovieDetailPage({required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final TextEditingController reviewController = TextEditingController();
  List<Review> reviews = [];
  Review? editingReview;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final data = await MovieDatabase.instance.getReviewsByMovieId(
      widget.movie.id,
    );
    setState(() {
      reviews = data;
    });
  }

  Future<void> _submitReview() async {
    final text = reviewController.text.trim();
    if (text.isEmpty) return;

    if (editingReview != null) {
      // Update
      final updatedReview = Review(
        id: editingReview!.id,
        movieId: widget.movie.id,
        content: text,
        createdAt: editingReview!.createdAt,
      );
      await MovieDatabase.instance.updateReview(updatedReview);
      editingReview = null;
    } else {
      // Insert
      final newReview = Review(
        movieId: widget.movie.id,
        content: text,
        createdAt: DateTime.now().toIso8601String(),
      );
      await MovieDatabase.instance.insertReview(newReview);
    }

    reviewController.clear();
    await _loadReviews();
  }

  Future<void> _editReview(Review review) async {
    setState(() {
      editingReview = review;
      reviewController.text = review.content;
    });
  }

  Future<void> _deleteReview(int id) async {
    await MovieDatabase.instance.deleteReview(id);
    await _loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.movie.posterPath, height: 300)),
            SizedBox(height: 20),
            Text(
              widget.movie.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(widget.movie.overview),
            SizedBox(height: 20),
            Text(
              editingReview == null ? "Kirim Ulasan" : "Edit Ulasan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                hintText: "Tulis ulasan kamu...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _submitReview,
                  child: Text(
                    editingReview == null ? "Kirim Ulasan" : "Simpan Perubahan",
                  ),
                ),
                if (editingReview != null) SizedBox(width: 10),
                if (editingReview != null)
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        editingReview = null;
                        reviewController.clear();
                      });
                    },
                    child: Text("Batal"),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Ulasan Pengguna",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            reviews.isEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Belum ada ulasan."),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(review.content),
                        subtitle: Text(
                          DateTime.parse(review.createdAt).toLocal().toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editReview(review),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReview(review.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
