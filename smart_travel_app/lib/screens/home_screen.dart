import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/place.dart';
import '../widgets/place_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Place>> futurePlaces;

  @override
  void initState() {
    super.initState();
    futurePlaces = ApiService.fetchRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Travel Assistant")),
      body: FutureBuilder<List<Place>>(
        future: futurePlaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Place> places = snapshot.data ?? [];
          final random = Random();

          // Assign random crowdScore if missing
          places = places.map((p) {
            return Place(
              name: p.name,
              lat: p.lat,
              lng: p.lng,
              story: p.story,
              vicinity: p.vicinity,
              crowdScore: p.crowdScore == 0
                  ? 10 + random.nextInt(90)
                  : p.crowdScore,
            );
          }).toList();

          if (places.isEmpty) {
            return const Center(child: Text("No places found."));
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              return PlaceCard(place: places[index]);
            },
          );
        },
      ),
    );
  }
}
