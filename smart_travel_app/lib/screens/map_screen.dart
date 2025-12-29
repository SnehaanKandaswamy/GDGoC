import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  final LatLng _center = const LatLng(12.9716, 77.5946);

  final List<Map<String, dynamic>> _places = [
    {
      "name": "Hidden Temple",
      "lat": 12.9718,
      "lng": 77.5939,
    },
    {
      "name": "Village Lake",
      "lat": 12.969,
      "lng": 77.59,
    },
    {
      "name": "Old Fort",
      "lat": 12.975,
      "lng": 77.588,
    },
  ];

  Set<Marker> _buildMarkers() {
    return _places.map((place) {
      return Marker(
        markerId: MarkerId(place["name"]),
        position: LatLng(place["lat"], place["lng"]),
        infoWindow: InfoWindow(title: place["name"]),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13,
        ),
        markers: _buildMarkers(),
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
