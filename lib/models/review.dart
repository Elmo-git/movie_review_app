class Review {
  final int? id;
  final int movieId;
  final String content;
  final String createdAt;

  Review({
    this.id,
    required this.movieId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId,
      'content': content,
      'createdAt': createdAt,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      movieId: map['movieId'],
      content: map['content'],
      createdAt: map['createdAt'],
    );
  }
}
