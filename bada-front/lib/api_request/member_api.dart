import 'dart:convert';

import 'package:bada/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MembersApi {
  static const String _baseUrl = 'https://j10b207.p.ssafy.io/api/members';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> updateProfile(
    String accessToken,
    String filePath,
    String nickname,
  ) async {
    var uri = Uri.parse('https://j10b207.p.ssafy.io/api/members');
    var request = http.MultipartRequest('PATCH', uri)
      ..fields['name'] = nickname; // 닉네임 필드

    // 파일이 선택되었다면 요청에 추가
    if (filePath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // 서버에서 요구하는 필드명
          filePath,
        ),
      );
    }

    // 헤더 설정, 필요한 경우 Authorization 헤더 등을 추가하세요
    request.headers.addAll({
      'Content-Type': 'application/json',
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      print('프로필 업데이트 성공');
      // 성공 처리 로직
    } else {
      print('프로필 업데이트 실패: ${response.statusCode}');
      // 실패 처리 로직
    }
  }

  Future<UserProfile> fetchProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 서버로부터 응답 받은 데이터를 JSON으로 디코드
      final Map<String, dynamic> data = json.decode(response.body);
      // JSON 데이터를 UserProfile 객체로 변환
      return UserProfile.fromJson(data);
    } else {
      // 서버 응답이 200이 아닌 경우 오류 처리
      throw Exception('Failed to load profile');
    }
  }

  Future<void> deleteMember(String accessToken) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.delete(Uri.parse(_baseUrl), headers: headers);

      if (response.statusCode == 200) {
        debugPrint('Member deleted successfully');
      } else {
        throw Exception('Failed to delete member ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting member');
    }
  }
}
