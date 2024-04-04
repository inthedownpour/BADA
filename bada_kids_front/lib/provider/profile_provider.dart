import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _accessToken;
  String? _profileUrl;
  String? _name;
  String? _phone;
  String? _familyCode;
  int? _memberId;
  int? _movingState;

  // private static 인스턴스
  static final ProfileProvider _instance = ProfileProvider._internal();

  // private 생성자
  ProfileProvider._internal();

  // public static 메서드
  static ProfileProvider get instance => _instance;
  String? get profileUrl => _instance._profileUrl;
  String get name => _instance._name!;
  String get phone => _instance._phone!;
  String get familyCode => _instance._familyCode!;
  int get memberId => _instance._memberId!;
  String get accessToken => _instance._accessToken!;
  int get movingState => _instance._movingState!;

  Future<void> loadProfile() async {
    // TODO : 사용자 프로필 정보를 서버에서 불러오는 코드 작성
    _accessToken = await _storage.read(key: 'accessToken');

    debugPrint('accessToken: $accessToken');

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      _profileUrl = data['profileUrl'];
      _name = data['name'];
      _memberId = data['memberId'];
      _phone = data['phone'];
      _familyCode = data['familyCode'];
      _movingState = data['movingState'];
    }
  }

  // 추가된 초기화 메서드
  Future<void> init() async {
    await loadProfile();
  }
}
