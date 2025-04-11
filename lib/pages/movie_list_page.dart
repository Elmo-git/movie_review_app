import 'package:flutter/material.dart';
import 'package:movie_review_app/services/api_service.dart';
import 'package:movie_review_app/models/movie.dart';
import 'package:movie_review_app/pages/movie_detail_page.dart';
import 'package:movie_review_app/services/movie_database.dart'; // Import movie database helper

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final ApiService api = ApiService();
  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    searchController.addListener(_filterMovies);
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Movie> movies = await MovieDatabase.instance.getAllMovies();

      if (movies.isEmpty) {
        movies = await api.fetchMovies();
      }

      setState(() {
        allMovies = movies;
        filteredMovies = movies;
      });
    } catch (e) {
      print("Error loading movies: $e");
      setState(() {
        _errorMessage = "Gagal memuat film. Periksa koneksi internet atau API.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterMovies() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMovies =
          allMovies
              .where((movie) => movie.title.toLowerCase().contains(query))
              .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        filteredMovies = allMovies;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            isSearching
                ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Cari film?",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.blueGrey),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                )
                : Text("List film"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : filteredMovies.isEmpty
              ? const Center(child: Text("Tidak ada film ditemukan."))
              : ListView.builder(
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        movie.posterPath,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                      title: Text(movie.title),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MovieDetailPage(movie: movie),
                            ),
                          ),
                    ),
                  );
                },
              ),
    );
  }
}
