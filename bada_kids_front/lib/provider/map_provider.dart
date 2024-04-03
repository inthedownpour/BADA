import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bada_kids_front/provider/profile_provider.dart';
import 'package:bada_kids_front/screen/main/api/alarm_api.dart';
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
  late String destinationName;
  late String destinationIcon;
  late int destinationId;
  List<LatLng> currentPassedPoints = [];

  // private static 인스턴스
  static final MapProvider _instance = MapProvider._internal();

  // private 생성자
  MapProvider._internal() {
    AlarmApi alarmApi = AlarmApi();
    ProfileProvider profileProvider = ProfileProvider.instance;
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
          double distance = haversine(
              currentPassedPoints.first.latitude,
              currentPassedPoints.first.longitude,
              currentPassedPoints.last.latitude,
              currentPassedPoints.last.longitude); // 5분 전 위치와 현재 위치 사이의 거리

          // 5분간 정지해있는 경우
          if (currentPassedPoints.length == 59) {
            // 5분 전 위치와 현재 위치 사이의 거리가 0.0012도 이내이고 0.0006도 이내인 경우
            if ((currentPassedPoints.first.latitude -
                            currentPassedPoints.last.latitude)
                        .abs() <
                    0.0012 &&
                currentPassedPoints.first.longitude -
                        currentPassedPoints.last.longitude <
                    0.0006) {
              await alarmApi.sendAlarm(
                familyCode: profileProvider.familyCode,
                childeName: profileProvider.name,
                type: 'STAY',
                phone: profileProvider.phone,
                profileUrl: profileProvider.profileUrl,
                destinationName: destinationName,
                destinationIcon: destinationIcon,
                destinationId: destinationId,
                latitude: currentLocation.latitude.toStringAsFixed(5),
                longitude: currentLocation.longitude.toStringAsFixed(5),
                memberId: profileProvider.memberId,
              );
            }
            // 시속 30km 이상으로 이동한 경우
            if (distance > 2.5) {
              await alarmApi.sendAlarm(
                familyCode: profileProvider.familyCode,
                childeName: profileProvider.name,
                type: 'TOO FAST',
                phone: profileProvider.phone,
                profileUrl: profileProvider.profileUrl,
                destinationName: destinationName,
                destinationIcon: destinationIcon,
                destinationId: destinationId,
                latitude: currentLocation.latitude.toStringAsFixed(5),
                longitude: currentLocation.longitude.toStringAsFixed(5),
                memberId: profileProvider.memberId,
              );
            }
            // 경로를 이탈한 경우
            if ((_currentLocation.latitude - endLatLng!.latitude).abs() >
                    (startLatLng!.latitude - endLatLng!.latitude).abs() +
                        0.0012 ||
                (_currentLocation.longitude - endLatLng!.longitude).abs() >
                    (startLatLng!.longitude - endLatLng!.longitude).abs() +
                        0.0006 ||
                (_currentLocation.latitude - startLatLng!.latitude).abs() >
                    (startLatLng!.latitude - endLatLng!.latitude).abs() +
                        0.0012 ||
                (_currentLocation.longitude - startLatLng!.longitude).abs() >
                    (startLatLng!.longitude - endLatLng!.longitude).abs() +
                        0.0006) {
              await alarmApi.sendAlarm(
                familyCode: profileProvider.familyCode,
                childeName: profileProvider.name,
                type: 'OFF COURSE',
                phone: profileProvider.phone,
                profileUrl: profileProvider.profileUrl,
                destinationName: destinationName,
                destinationIcon: destinationIcon,
                destinationId: destinationId,
                latitude: currentLocation.latitude.toStringAsFixed(5),
                longitude: currentLocation.longitude.toStringAsFixed(5),
                memberId: profileProvider.memberId,
              );
            }
            // 목적지에 도착한 경우
            if (_currentLocation.latitude > endLatLng!.latitude - 0.0012 &&
                _currentLocation.latitude < endLatLng!.latitude + 0.0012 &&
                _currentLocation.longitude > endLatLng!.longitude - 0.0006 &&
                _currentLocation.longitude < endLatLng!.longitude + 0.0006) {
              await deleteCurrentLocationUpdate();

              await alarmApi.sendAlarm(
                familyCode: profileProvider.familyCode,
                childeName: profileProvider.name,
                type: 'ARRIVE',
                phone: profileProvider.phone,
                profileUrl: profileProvider.profileUrl,
                destinationName: destinationName,
                destinationIcon: destinationIcon,
                destinationId: destinationId,
                latitude: currentLocation.latitude.toStringAsFixed(5),
                longitude: currentLocation.longitude.toStringAsFixed(5),
                memberId: profileProvider.memberId,
              );
            }
          }
          _isFunctionAsync = false; // 비동기 함수 끝
        }
      }
    });
  }

  // public static 메서드
  static MapProvider get instance => _instance;

  // 현재 위치 정보에 대한 getter
  LatLng get currentLocation => _currentLocation;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  double haversine(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0; // 지구의 반지름(km)
    double lat1Rad = lat1 * (pi / 180.0);
    double lon1Rad = lon1 * (pi / 180.0);
    double lat2Rad = lat2 * (pi / 180.0);
    double lon2Rad = lon2 * (pi / 180.0);

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = R * c;
    return distance;
  }

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
    debugPrint('map_provider 58줄 ${_currentLocation.longitude}');
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
        debugPrint('여기까진 성공');
        AlarmApi alarmApi = AlarmApi();
        await alarmApi.sendAlarm(
          familyCode: profileProvider.familyCode,
          childeName: profileProvider.name,
          type: 'DEPART',
          phone: profileProvider.phone,
          profileUrl: profileProvider.profileUrl,
          destinationName: destinationName,
          destinationIcon: destinationIcon,
          destinationId: destinationId,
          latitude: currentLocation.latitude.toStringAsFixed(5),
          longitude: currentLocation.longitude.toStringAsFixed(5),
          memberId: profileProvider.memberId,
        );

        debugPrint('서버 응답: ${response.body}');
      } else {
        // 서버 응답이 200이 아닐 때의 처리
        debugPrint('요청 실패map provider 234: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생했을 때의 처리
      debugPrint('에러 발생: $e');
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
        debugPrint('서버 응답: ${response.body}');
        if (currentPassedPoints.length == 60) {
          currentPassedPoints.removeAt(0);
        }
        currentPassedPoints.add(currentLocation);
      } else {
        // 서버 응답이 200이 아닐 때의 처리
        debugPrint('요청 실패 map provider 272: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생했을 때의 처리
      debugPrint('에러 발생: $e');
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
        debugPrint('서버 응답: ${response.body}');
      } else {
        // 서버 응답이 200이 아닐 때의 처리
        debugPrint('요청 실패 map provider 301: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생했을 때의 처리
      debugPrint('에러 발생: $e');
    }
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel(); // Timer를 취소합니다.
    super.dispose();
  }
}
