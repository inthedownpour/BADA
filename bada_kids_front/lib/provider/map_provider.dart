import 'dart:async';
import 'dart:convert';

import 'package:bada_kids_front/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:http/http.dart' as http;

class MapProvider with ChangeNotifier {
  late final KakaoMapController mapController;
  Timer? _locationUpdateTimer;
  late LatLng _currentLocation;
  bool _isLocationServiceEnabled = false;
  bool _isFunctionAsync = false;
  LatLng? startLatLng;
  LatLng? endLatLng;

  // private static 인스턴스
  static final MapProvider _instance = MapProvider._internal();

  // private 생성자
  MapProvider._internal() {
    setCurrentLocation();
    _locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      // 5초 주기로 현재 위치 정보 업데이트
      debugPrint("타이머 실행 중");
      if (!_isFunctionAsync) {
        _isFunctionAsync = true; // 비동기 함수 시작
        await setCurrentLocation();
        if (isLocationServiceEnabled) {
          await currentLocationUpdate();
          if (endLatLng != null &&
              _currentLocation.latitude > endLatLng!.latitude - 0.0012 &&
              _currentLocation.latitude < endLatLng!.latitude + 0.0012 &&
              _currentLocation.longitude > endLatLng!.longitude - 0.0006 &&
              _currentLocation.longitude < endLatLng!.longitude + 0.0006) {
            await deleteCurrentLocationUpdate();
          }
        }
        _isFunctionAsync = false; // 비동기 함수 끝
      }
    });
  }

  // public static 메서드
  static MapProvider get instance => _instance;

  // 현재 위치 정보에 대한 getter
  LatLng get currentLocation => _currentLocation;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  // void startCurrentLocationUpdate() {}

  Future<void> setCurrentLocation([VoidCallback? onCompleted]) async {
    // 위치 서비스 활성화 여부 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }

    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 정보 접근 권한이 거부되었습니다.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 정보 접근 권한이 영구적으로 거부되었습니다.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentLocation = LatLng(position.latitude, position.longitude);
    print('map_provider 58줄 ${_currentLocation.longitude}');
    notifyListeners(); // 위치 정보가 업데이트되면 리스너에게 알림
    onCompleted?.call();
  }

  Future<void> initCurrentLocationUpdate() async {
    ProfileProvider profileProvider = ProfileProvider.instance;
    var accessToken = profileProvider.accessToken;
    // 요청 URL
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/currentLocation');

    // 요청 헤더
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // 요청 본문
    var requestBody = jsonEncode({
      "currentLatitude": currentLocation.latitude.toStringAsFixed(5),
      "currentLongitude": currentLocation.longitude.toStringAsFixed(5)
    });

    // POST 요청 보내기
    try {
      var response = await http.post(url, headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        // 성공적으로 요청을 보냈을 때의 처리
        _isLocationServiceEnabled = true;
        print('서버 응답: ${response.body}');
      } else {
        // 서버 응답이 200이 아닐 때의 처리
        print('요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생했을 때의 처리
      print('에러 발생: $e');
    }
  }

  Future<void> currentLocationUpdate() async {
    ProfileProvider profileProvider = ProfileProvider.instance;
    var accessToken = profileProvider.accessToken;
    // 요청 URL
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/currentLocation');

    // 요청 헤더
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // 요청 본문
    var requestBody = jsonEncode({
      "currentLatitude": currentLocation.latitude.toStringAsFixed(5),
      "currentLongitude": currentLocation.longitude.toStringAsFixed(5)
    });

    // POST 요청 보내기
    try {
      var response = await http.patch(url, headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        // 성공적으로 요청을 보냈을 때의 처리
        print('서버 응답: ${response.body}');
      } else {
        // 서버 응답이 200이 아닐 때의 처리
        print('요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생했을 때의 처리
      print('에러 발생: $e');
    }
  }

  Future<void> deleteCurrentLocationUpdate() async {
    ProfileProvider profileProvider = ProfileProvider.instance;
    var accessToken = profileProvider.accessToken;
    // 요청 URL
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/currentLocation');

    // 요청 헤더
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // delete 요청 보내기
    try {
      var response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        // 성공적으로 요청을 보냈을 때의 처리
        _isLocationServiceEnabled = false;
        print('서버 응답: ${response.body}');
      } else {
        // 서버 응답이 200이 아닐 때의 처리
        print('요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생했을 때의 처리
      print('에러 발생: $e');
    }
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel(); // Timer를 취소합니다.
    super.dispose();
  }
}
