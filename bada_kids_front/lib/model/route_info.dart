class RouteInfo {
  final double startLng, startLat, endLng, endLat;
  final String addressName, placeName, destinationIcon;
  final List<Point> pointList;
  final int placeId;
  RouteInfo({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
    required this.addressName,
    required this.placeName,
    required this.pointList,
    required this.destinationIcon,
    required this.placeId,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    var list = json['pointList'] as List;
    List<Point> pointList = list.map((i) => Point.fromJson(i)).toList();

    return RouteInfo(
      startLng: json['startLng'],
      startLat: json['startLat'],
      endLng: json['endLng'],
      endLat: json['endLat'],
      addressName: json['addressName'],
      placeName: json['placeName'],
      destinationIcon: json['destinationIcon'],
      placeId: json['placeId'],
      pointList: pointList,
    );
  }
}

class Point {
  final double latitude;
  final double longitude;

  Point({required this.latitude, required this.longitude});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
