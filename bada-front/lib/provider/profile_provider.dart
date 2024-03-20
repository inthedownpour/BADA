import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bada/login/kakao_login.dart';
import 'package:bada/login/login_platform.dart';
import 'package:bada/login/naver_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ProfileProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  ProfileProvider() {
    _loadProfileFromStorage();
  }

  String? _nickname, _profileImage, _email, _phoneNumber, _social;
  bool _isLogined = false;

  String? get nickname => _nickname;
  String? get profileImage => _profileImage;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get social => _social;

  // Define keys for storage
  final _nicknameKey = 'nickname';
  final _profileImageKey = 'profileImage';
  final _emailKey = 'email';
  final _phoneNumberKey = 'phoneNumber';
  final _socialKey = 'social';
  final _isLoginedKey = 'isLogined';

  bool get isLogined => _isLogined;

  Future<void> initProfile(LoginPlatform loginPlatform) async {
    switch (loginPlatform) {
      case LoginPlatform.kakao:
        await _initKakaoProfile();
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.naver:
        await _initNaverProfile();
        break;
      case LoginPlatform.none:
        break;
    }
    _phoneNumber = await SmsAutoFill().hint;
    notifyListeners();
  }

  Future<void> _loadProfileFromStorage() async {
    _nickname = await _storage.read(key: _nicknameKey);
    _profileImage = await _storage.read(key: _profileImageKey);
    _email = await _storage.read(key: _emailKey);
    _phoneNumber = await _storage.read(key: _phoneNumberKey);
    _social = await _storage.read(key: _socialKey);
    _isLogined = await _storage.read(key: _isLoginedKey) == 'true';
    notifyListeners();
  }

  Future<void> _saveProfileToStorage() async {
    // Fetch accessToken from secure storage
    final accessToken = await _storage.read(key: 'accessToken');

    // Set up headers for the GET request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // Perform the GET request to fetch the profile data
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: headers,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Save the data to local storage
      await _storage.write(key: 'memberId', value: data['memberId'].toString());
      await _storage.write(key: 'nickname', value: data['nickname']);
      await _storage.write(key: 'phone', value: data['phone']);
      await _storage.write(key: 'email', value: data['email']);
      await _storage.write(key: 'social', value: data['social']);
      await _storage.write(key: 'createdAt', value: data['createdAt']);
      await _storage.write(
        key: 'profileUrl',
        value: data['profileUrl'] ?? 'null',
      );
    } else {
      // Handle errors or unsuccessful responses
      print(
        'Failed to fetch profile data. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> _initKakaoProfile() async {
    try {
      // final viewModel = MainViewModel(KakaoLogin() as SocialLogin);
      KakaoLogin kakaoLogin = KakaoLogin();
      await kakaoLogin.login();
      User? user = await UserApi.instance.me();
      _nickname = user.kakaoAccount?.profile?.nickname;
      _profileImage = user.kakaoAccount?.profile?.profileImageUrl;
      _email = user.kakaoAccount?.email;
      _isLogined = true;
      _social = 'KAKAO';
      notifyListeners();
      _saveProfileToStorage();
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }

  Future<void> _initNaverProfile() async {
    try {
      NaverLogin naverLogin = NaverLogin();
      await naverLogin.login();
      NaverAccountResult result = await FlutterNaverLogin.currentAccount();
      _nickname = result.nickname;
      _profileImage = result.profileImage;
      _email = result.email;
      _isLogined = true;
      _social = 'NAVER';
      _saveProfileToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }

  Future<void> logout() async {
    // Delete all stored data
    await _storage.delete(key: _nicknameKey);
    await _storage.delete(key: _profileImageKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _phoneNumberKey);
    await _storage.delete(key: _socialKey);
    await _storage.delete(key: _isLoginedKey);

    // Reset local variables to their default values
    _nickname = null;
    _profileImage = null;
    _email = null;
    _phoneNumber = null;
    _social = null;
    _isLogined = false;

    // Notify listeners about changes to the model
    notifyListeners();
  }
}
