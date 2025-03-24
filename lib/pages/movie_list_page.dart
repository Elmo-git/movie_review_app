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
  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    searchController.addListener(_filterMovies);
  }

  Future<void> _fetchMovies() async {
    try {
      List<Movie> movies = await api.fetchMovies();
      setState(() {
        allMovies = movies;
        filteredMovies = movies;
      });
    } catch (e) {
      print("error fetching pak: $e");
    }
  }

  void _filterMovies() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMovies =
          allMovies
              .where((movies) => movies.title.toLowerCase().contains(query))
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
          filteredMovies.isEmpty
              ? Center(child: Text("ga ada pak boss"))
              : ListView.builder(
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];
                  return Card(
                    child: ListTile(
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
