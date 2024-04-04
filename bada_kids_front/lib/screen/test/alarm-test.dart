import 'dart:convert';

import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class AlarmTest extends StatefulWidget {
  const AlarmTest({super.key});

  @override
  State<AlarmTest> createState() => _AlarmTestState();
}

class _AlarmTestState extends State<AlarmTest> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _familyCode, _name, _phone, _profileUrl;
  int? _memberId;
  MapProvider mapProvider = MapProvider.instance;

  late LatLng currentLocation;
  late Future<String?> fcmToken;
  Future<bool>? _load;

  Future<bool> _loadProfileFromBackEnd() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    debugPrint('accessToken: $accessToken');

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      setState(() {
        _familyCode = data['familyCode'];
        _name = data['name'];
        _memberId = data['memberId'];
        _phone = data['phone'];
        _profileUrl = data['profileUrl'];
        currentLocation = mapProvider.currentLocation;

        fcmToken = FirebaseMessaging.instance.getToken();
      });
      return true;
    } else {
      debugPrint('Failed to load data');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _load = _loadProfileFromBackEnd();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _load,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('테스트'),
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sendAlarm(
                        familyCode: _familyCode!,
                        memberId: _memberId!,
                        childeName: _name!,
                        latitude: currentLocation.latitude.toString(),
                        longitude: currentLocation.longitude.toString(),
                        type: 'DEFAULT',
                        phone: _phone ?? '',
                        profileUrl: _profileUrl ?? '',
                        destinationName: '10시35분 테스트',
                        destinationIcon: 'assets/img/bag.png',
                      );
                    },
                    child: const Text('test'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> sendAlarm({
    required String familyCode,
    required String childeName,
    required String type,
    required String phone,
    required String profileUrl,
    required String destinationName,
    required String destinationIcon,
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
        "myPlaceId": 10,
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
