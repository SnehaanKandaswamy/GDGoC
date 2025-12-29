import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class ApiService {
  static const String baseUrl = "http://10.31.15.174:8000";

  static Future<List<Place>> fetchRecommendations() async {
    final response = await http.post(
      Uri.parse("$baseUrl/recommend"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "latitude": 12.9716,
        "longitude": 77.5946,
        "interest": "nature",
        "travel_type": "solo",
        "time_of_day": "morning"
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['recommendations'];

      return data.map((e) => Place.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load recommendations");
    }
  }
}
