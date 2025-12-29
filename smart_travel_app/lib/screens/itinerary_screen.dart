import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/place.dart';

class ItineraryScreen extends StatefulWidget {
  final List<Place>? places;

  const ItineraryScreen({Key? key, this.places}) : super(key: key);

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  late GoogleMapController _mapController;
  LatLng _userLocation = const LatLng(12.9716, 77.5946); // Default: Bangalore
  List<Place> _orderedPlaces = [];
  bool _locationUpdated = false;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _fetchUserLocation();
  }

  void _loadPlaces() {
    final random = Random();
    List<Place> placesToUse = widget.places ??
        [
          Place(
            name: 'Place 1',
            lat: _userLocation.latitude + 0.001,
            lng: _userLocation.longitude + 0.001,
            crowdScore: 10 + random.nextInt(90),
            story: 'A nice place to visit',
          ),
          Place(
            name: 'Place 2',
            lat: _userLocation.latitude + 0.002,
            lng: _userLocation.longitude - 0.001,
            crowdScore: 10 + random.nextInt(90),
            story: 'Historic spot',
          ),
        ];

    setState(() {
      _orderedPlaces = placesToUse;
    });
  }

  Future<void> _fetchUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 5));

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _locationUpdated = true;
      });

      // Optionally move camera to new location
      _mapController.animateCamera(
        CameraUpdate.newLatLng(_userLocation),
      );
    } catch (e) {
      print("Failed to get location, using default: $e");
    }
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // User marker
    markers.add(Marker(
      markerId: const MarkerId('user'),
      position: _userLocation,
      infoWindow: const InfoWindow(title: 'You'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));

    // Place markers
    for (var place in _orderedPlaces) {
      markers.add(Marker(
        markerId: MarkerId(place.name),
        position: LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: 'Crowd: ${place.crowdScore}',
        ),
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 15,
              ),
              markers: _buildMarkers(),
              myLocationEnabled: true,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _orderedPlaces.length,
              itemBuilder: (context, index) {
                final place = _orderedPlaces[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(place.name),
                  subtitle: Text('Crowd: ${place.crowdScore}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
