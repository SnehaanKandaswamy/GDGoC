import 'package:flutter/material.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Optimized Itinerary")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.place),
            title: Text("Morning: Hidden Temple"),
            subtitle: Text("Low crowd, peaceful start"),
          ),
          ListTile(
            leading: Icon(Icons.place),
            title: Text("Afternoon: Local Market"),
            subtitle: Text("Cultural experience"),
          ),
          ListTile(
            leading: Icon(Icons.place),
            title: Text("Evening: Sunset Point"),
            subtitle: Text("Best timing recommendation"),
          ),
        ],
      ),
    );
  }
}
