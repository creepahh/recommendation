import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://localhost:3000'; //need to use the path of csv file instead, will come later

  Future<List<String>> getRecommendations(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/recommendations?user_id=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<String> recommendations = [];
      for (var item in data) {
        recommendations.add(item['title']);
      }
      return recommendations;
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
