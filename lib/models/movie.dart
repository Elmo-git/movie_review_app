class Movie {
  final String title;
  final String poster;
  final String overview;

  Movie({required this.title, required this.poster, required this.overview});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      poster: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      overview: json['overview'],
    );
  }
}
