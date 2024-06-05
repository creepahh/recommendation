import 'package:flutter/material.dart';
import '../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Movie> recommendations = [];
  final TextEditingController userIdController = TextEditingController();

  void fetchRecommendations() async {
    final userId = int.parse(userIdController.text);
    final recs = await apiService.getRecommendations(userId);
    setState(() {
      recommendations = recs.cast<Movie>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Recommendations')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildVerticalLayout();
          } else {
            return _buildHorizontalLayout();
          }
        },
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: userIdController,
            decoration: const InputDecoration(labelText: 'Enter User ID'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchRecommendations,
            child: const Text('Get Recommendations'),
          ),
          const SizedBox(height: 20),
          recommendations.isEmpty
              ? const Text('No recommendations yet')
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      return MoviePoster(
                        movie: recommendations[index],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(labelText: 'Enter User ID'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchRecommendations,
                  child: const Text('Get Recommendations'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: recommendations.isEmpty
                ? const Center(child: Text('No recommendations yet'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      return MoviePoster(
                        movie: recommendations[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final Movie movie;

  const MoviePoster({Key? key, required this.movie}) : super(key: key);

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
            child: Text(
              movie.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Movie({required this.title, required this.posterUrl});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterUrl: json['poster_url'],
    );
  }
}
