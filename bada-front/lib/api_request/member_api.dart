import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bada/functions/profile_edit_func.dart';
import 'package:bada/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MembersApi {
  static const String _baseUrl = 'https://j10b207.p.ssafy.io/api/members';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // TODO : 회원 정보 수정 (파일 업로드 부분 에러 뜸)
  Future<void> updateProfile(
    String? filePath,
    String nickname,
    int? childId,
  ) async {
    // _storage 인스턴스를 사용하여 accessToken을 비동기적으로 불러옵니다.
    String? accessToken = await _storage.read(key: 'accessToken');
    if (filePath != null) {
      ProfileEditFunc profileEditFunc = ProfileEditFunc();
      filePath = await profileEditFunc.compressImage(filePath);
    }

    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    debugPrint('액세스 토큰 : $accessToken');
    debugPrint('childId : $childId');
    var uri = Uri.parse('https://j10b207.p.ssafy.io/api/members');
    http.MultipartRequest request = http.MultipartRequest('PATCH', uri);
    request.fields['name'] = nickname; // 닉네임 필드
    if (childId != null) {
      request.fields['childId'] = childId.toString(); // childId 필드, 문자열로 변환
    } else {
      request.fields['childId'] = '';
    }

    // TODO : 기존 파일과 새로운 파일이 다를 경우에만 파일 추가
    if (filePath != null) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // 서버에서 요구하는 필드명
            filePath,
          ),
        );
        debugPrint(request.fields.toString());
        debugPrint(filePath);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    // 헤더 설정. PATCH 요청에서 'Content-Type': 'application/json'는 필요 없습니다.
    // MultipartRequest는 자동으로 'Content-Type': 'multipart/form-data' 헤더를 사용합니다.
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('프로필 업데이트 성공');
      UserProfile userProfile = await fetchProfile();
      _storage.write(key: 'nickname', value: userProfile.name);
      _storage.write(key: 'profileImage', value: userProfile.profileUrl);
      // 성공 처리 로직
    } else {
      debugPrint('프로필 업데이트 실패: ${response.statusCode}');
      // 실패 처리 로직
    }
  }

  Future<UserProfile> fetchProfile() async {
    // _storage 인스턴스를 사용하여 accessToken을 비동기적으로 불러옵니다.
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
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

  Future<void> deleteMember() async {
    try {
      // _storage 인스턴스를 사용하여 accessToken을 비동기적으로 불러옵니다.
      String? accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found');
      }
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.delete(Uri.parse(_baseUrl), headers: headers);

      if (response.statusCode == 200) {
        debugPrint('Member deleted successfully');
      } else {
        throw Exception('Failed to delete member');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting member');
    }
  }
}
