import 'package:flutter/material.dart';
import 'package:movie_review_app/pages/movie_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Review App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MovieListPage(),
    );
  }
}
