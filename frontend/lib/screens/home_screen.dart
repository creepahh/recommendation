import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import '../services/api_services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Movie> recommendations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Recommendations'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout logic, navigate to LoginScreen
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _buildRecommendations(),
    );
  }

  Widget _buildRecommendations() {
    return FutureBuilder<List<Movie>>(
      future:
          apiService.getRecommendations(1), // Fetch recommendations for user 1
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          recommendations = snapshot.data!;
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
                  context
                      .read<MyAppState>()
                      .toggleFavorite(recommendations[index]);
                },
              );
            },
          );
        }
      },
    );
  }
}
