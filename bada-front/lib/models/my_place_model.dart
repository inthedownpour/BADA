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
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 응답에서 전체 JSON 객체를 디코드
      final Map<String, dynamic> decodedData = json.decode(response.body);
      // MyPlaceList 키에 접근하여 List<dynamic> 타입으로 변환
      final List<dynamic> myPlaceList = decodedData['MyPlaceList'];
      // List<dynamic>을 List<Place>로 변환
      return myPlaceList.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
