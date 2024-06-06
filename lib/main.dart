import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class Movie {
  final String title;
  final String overview;
  final String posterPath;

  Movie(
      {required this.title, required this.overview, required this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        title: json['title'],
        overview: json['overview'],
        posterPath: json['poster_path']);
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyMoviesPage()));
          },
          child: const Text("Movies"),
        ),
      ),
    );
  }
}

class MyMoviesPage extends StatefulWidget {
  const MyMoviesPage({super.key});

  @override
  State<MyMoviesPage> createState() => _MyMoviesPageState();
}

class _MyMoviesPageState extends State<MyMoviesPage> {
  List<Movie> movies = [];

  Future<void> fetchMovies() async {
    final apiKey = dotenv.env['API_KEY'];
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey'));
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
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top rated movies"),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(movies[index].title),
            subtitle: Text(movies[index].overview),
            leading: Image.network(
              'https://image.tmdb.org/t/p/original${movies[index].posterPath}',
              width: 72,
            ),
          );
        },
      ),
    );
  }
}
