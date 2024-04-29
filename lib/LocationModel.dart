class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint(this.latitude, this.longitude);

  factory GeoPoint.fromMap(Map<String, double> map) {
    return GeoPoint(
      map['latitude'] ?? 0.0,
      map['longitude'] ?? 0.0,
    );
  }
}