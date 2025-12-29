class Place {
  final String name;
  final String vicinity;
  final double crowdScore;
  final String story;
  final double lat;
  final double lng;

  Place({
    required this.name,
    required this.vicinity,
    required this.crowdScore,
    required this.story,
    required this.lat,
    required this.lng,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      vicinity: json['vicinity'],
      crowdScore: (json['crowd_score']).toDouble(),
      story: json['story'],
      lat: json['location']['lat'],
      lng: json['location']['lng'],
    );
  }
}
