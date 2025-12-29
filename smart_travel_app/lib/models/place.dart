class Place {
  final String name;
  final double lat;
  final double lng;
  final String? vicinity;
  final int crowdScore; // make non-nullable
  final String? story;

  Place({
    required this.name,
    required this.lat,
    required this.lng,
    required this.crowdScore, // always required
    this.vicinity,
    this.story,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Unknown',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      crowdScore: (json['crowdScore'] ?? 0) as int,
      vicinity: json['vicinity'],
      story: json['story'],
    );
  }
}
