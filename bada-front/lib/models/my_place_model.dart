import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Place {
  final int placeId;
  final String placeName;
  final String placeLatitude;
  final String placeLongitude;
  final String icon;
  final String familyCode;

  Place({
    required this.placeId,
    required this.placeName,
    required this.placeLatitude,
    required this.placeLongitude,
    required this.icon,
    required this.familyCode,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeLatitude: json['place_latitude'],
      placeLongitude: json['place_longitude'],
      icon: json['icon'],
      familyCode: json['family_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'place_latitude': placeLatitude,
      'place_longitude': placeLongitude,
      'icon': icon,
      'family_code': familyCode,
    };
  }
}

class MyPlaceData {
  static Future<List<Place>> loadPlaces(String accessToken) async {
    debugPrint('accessToken: $accessToken');
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/myplace'),
      // 요청 헤더에 accessToken을 포함
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> res = json.decode(response.body);
      return res.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
