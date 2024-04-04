import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlarmApi {
  Future<void> sendAlarm({
    required String familyCode,
    required String childeName,
    required String type,
    required String phone,
    required String? profileUrl,
    required String destinationName,
    required String destinationIcon,
    required int destinationId,
    required String latitude,
    required String longitude,
    required int memberId,
  }) async {
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/kafka/alarm');

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(<String, dynamic>{
        "type": type,
        "memberId": memberId,
        "familyCode": familyCode,
        "myPlaceId": destinationId,
        "latitude": latitude,
        "longitude": longitude,
        "content": '보낸 시각은 : ${DateTime.now().toString()}',
        "childName": childeName,
        "phone": phone,
        "profileUrl": profileUrl,
        "destinationName": destinationName,
        "destinationIcon": destinationIcon
      }),
    );

    var fcmToken = await FirebaseMessaging.instance.getToken();

    if (response.statusCode == 200) {
      debugPrint(fcmToken);
    } else {
      String decodedBody = utf8.decode(response.bodyBytes);
      throw Exception('Failed to load data $decodedBody, $fcmToken');
    }
  }
}
