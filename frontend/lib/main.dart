// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../services/api_services.dart'; // Ensure you have the correct path

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Movie Recommendation App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
        locale: Locale('en', 'US'),
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var favorites = <Movie>[];

  void toggleFavorite(Movie movie) {
    if (favorites.contains(movie)) {
      favorites.remove(movie);
    } else {
      favorites.add(movie);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Movie> recommendations = [];

  @override
  void initState() {
    super.initState();
    fetchRecommendations(1); // Fetch recommendations for user 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Recommendations')),
      body: _buildRecommendations(),
    );
  }

  Widget _buildRecommendations() {
    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        return MoviePoster(
          movie: recommendations[index],
          onFavoritePressed: () {
            // Toggle favorite state of the movie
            setState(() {
              recommendations[index].toggleFavorite();
            });
            context.read<MyAppState>().toggleFavorite(recommendations[index]);
          },
        );
      },
    );
  }

  void fetchRecommendations(int userId) async {
    try {
      // Fetch recommendations from API
      final recs = await apiService.getRecommendations(userId);

      // Update recommendations
      setState(() {
        recommendations = recs.cast<Movie>();
      });
    } catch (e) {}
  }
}

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onFavoritePressed;

  const MoviePoster({super.key, required this.movie, this.onFavoritePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: movie.isFavorite ? Colors.red : null,
                  ),
                  onPressed: onFavoritePressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Movie {
  final String title;
  final String posterUrl;
  bool isFavorite;

  Movie({
    required this.title,
    required this.posterUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
