import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Movie {
  final String title;
  final String overview;

  Movie({required this.title, required this.overview});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API APP',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const MyMoviesPage(title: 'Movies Page')));
          },
          child: const Text("Movies"),
        ),
      ),
    );
  }
}

class MyMoviesPage extends StatefulWidget {
  const MyMoviesPage({super.key, required this.title});
  final String title;

  @override
  State<MyMoviesPage> createState() => _MyMoviesPageState();
}

class _MyMoviesPageState extends State<MyMoviesPage> {
  List<Movie> movies = [];

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=YOUR_API_KEY_HERE'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      setState(() {
        movies = List<Movie>.from(
            parsed['results'].map((movie) => Movie.fromJson(movie)));
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
