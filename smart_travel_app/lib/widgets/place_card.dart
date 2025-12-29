import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(place.name),
        subtitle: Text(place.story),
        trailing: Text("Crowd: ${place.crowdScore}"),
      ),
    );
  }
}
