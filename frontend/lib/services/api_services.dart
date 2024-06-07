import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'a42747a7f8d7503408b39c8a714bd678'; // TMDB API key

  Future<List<Movie>> getRecommendations(int userId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey&sort_by=popularity.desc&include_adult=false&page=1&with_watch_monetization_types=flatrate'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      List<Movie> recommendations = [];
      for (var item in results) {
        recommendations.add(Movie.fromJson(item));
      }
      return recommendations;
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}

class Movie {
  //factory method to create a Movie object from a JSON map
  final String title;
  final String posterUrl;

  Movie({required this.title, required this.posterUrl});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
    );
  }
}
