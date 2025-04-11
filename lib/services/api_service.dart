import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_review_app/models/movie.dart';

class ApiService {
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YzlhNzE3M2M0ZGM4YWRmNDE0NjdmYjE0YzhkMjVhZSIsIm5iZiI6MTc0Mjc5OTMxNi4yMjIwMDAxLCJzdWIiOiI2N2UxMDFkNDk2OGVlMjA4Njc0ZDdlMWUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.JUlJLifIKs6OZklumdMM1uylsA1BMqoif9BV4N5Tlu8';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load movies');
    }
  }
}
