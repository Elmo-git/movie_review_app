class Review {
  final int? id;
  final String movieId; // Tipe String
  final String content;
  final DateTime timestamp;

  Review({
    this.id,
    required this.movieId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId, // Sesuaikan dengan tipe String
      'comment': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      movieId: map['movieId'], // Pastikan menggunakan 'movieId' yang benar
      content: map['comment'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
