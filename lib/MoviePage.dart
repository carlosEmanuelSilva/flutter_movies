import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'MovieClass.dart';

class MyMoviesPage extends StatefulWidget {
  const MyMoviesPage({super.key});

  @override
  State<MyMoviesPage> createState() => _MyMoviesPageState();
}
class _MyMoviesPageState extends State<MyMoviesPage> {
  List<Movie> movies = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    final apiKey = dotenv.env['API_KEY'];
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey'));

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      setState(() {
        movies = List<Movie>.from(
            parsed['results'].map((movie) => Movie.fromJson(movie)));
      });
    } else {
      setState(() {
        isError = true;
      });
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
        title: const Text("Top rated movies", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : isError
          ? const Center(
        child: Text("Failed to load movies"),
      )
          : ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                  title: Text(
                    movies[index].title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    movies[index].overview,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:Image.network(
                      'https://image.tmdb.org/t/p/original${movies[index].posterPath}',
                      width: 72,
                    ),
                  )
              ),
            ),
          );


        },
      ),
    );
  }
}