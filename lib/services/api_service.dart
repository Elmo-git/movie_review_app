import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_review_app/models/movie.dart';

class ApiService {
  static const String apiKey = '5c9a7173c4dc8adf41467fb14c8d25ae';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
