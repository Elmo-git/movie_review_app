import 'package:flutter/material.dart';
import 'package:movie_review_app/services/api_service.dart';
import 'package:movie_review_app/models/movie.dart';
import 'package:movie_review_app/pages/movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final ApiService api = ApiService();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Film yang ada')),
      body: FutureBuilder<List<Movie>>(
        future: api.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading movies'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              return ListTile(
                leading: Image.network(
                  movie.poster,
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                ),
                title: Text(movie.title),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
