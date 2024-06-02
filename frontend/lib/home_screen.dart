import 'package:flutter/material.dart';
import '../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //text controller for user input ID field
  final ApiService apiService = ApiService();
  List<String> recommendations = [];
  final TextEditingController userIdController = TextEditingController();

  void fetchRecommendations() async {
    //fetches recommendation for this user
    final userId = int.parse(userIdController.text);
    final recs = await apiService.getRecommendations(userId);
    setState(() {
      recommendations = recs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Recommendations')),
      body: Padding(
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
                    child: ListView.builder(
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(recommendations[index]),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
