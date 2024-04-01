import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bada_kids_front/model/route_info.dart';
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:bada_kids_front/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ExistingRouteScreen extends StatefulWidget {
  const ExistingRouteScreen({super.key});

  @override
  State<ExistingRouteScreen> createState() => _ExistingRouteScreenState();
}

// TODO : 경로 삭제 버튼 추가
class _ExistingRouteScreenState extends State<ExistingRouteScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late KakaoMapController mapController;
  MapProvider mapProvider = MapProvider.instance;
  final ProfileProvider _profileProvider = ProfileProvider.instance;
  Future<List>? myPlaces;
  late int memberId;
  List<LatLng> pathPoints = []; // 경로 포인트 리스트
  Set<Marker> markers = {}; // 마커 변수
  Set<Polyline> polylines = {}; // 폴리라인 변수
  LatLng? middle;
  Future<bool>? _loadPath;
  String? placeName;
  String? addressName;
  LatLng? currentLocation;
  LatLng? destination;
  double? verticalForLevel;
  double? horizontalForLevel;

  Future<bool> _requestPath() async {
    int memberId = _profileProvider.memberId; // 멤버 ID 가져오기
    debugPrint('멤버 아이디: $memberId');

    var accessToken = await secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      debugPrint('Access Token이 존재하지 않습니다.');
      throw Exception('Access Token이 필요합니다.');
    }

    var url = Uri.parse('https://j10b207.p.ssafy.io/api/route/$memberId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      RouteInfo routeInfo = RouteInfo.fromJson(jsonData);
      // 시작점 추가
      pathPoints.add(LatLng(routeInfo.startLat, routeInfo.startLng));

      List<Point> pointList = routeInfo.pointList;
      for (var point in pointList) {
        double lat = point.latitude;
        double lng = point.longitude;
        pathPoints.add(LatLng(lat, lng));
      }

      // 종점 추가
      pathPoints.add(LatLng(routeInfo.endLat, routeInfo.endLng));

      setState(() {
        middle = LatLng(
          (routeInfo.startLat + routeInfo.endLat) / 2,
          (routeInfo.startLng + routeInfo.endLng) / 2,
        );
        addressName = routeInfo.addressName;
        placeName = routeInfo.placeName;
        verticalForLevel = (routeInfo.startLat - routeInfo.endLat).abs();
        horizontalForLevel = (routeInfo.startLng - routeInfo.endLng).abs();
      });

      debugPrint('startLng: ${routeInfo.startLng}');
      debugPrint('startLat: ${routeInfo.startLat}');
      debugPrint('endLng: ${routeInfo.endLng}');
      debugPrint('endLat: ${routeInfo.endLat}');
      debugPrint('placeName: ${routeInfo.placeName}');
      debugPrint('addressName: ${routeInfo.addressName}');

      return true; // RouteInfo 객체를 반환
    } else {
      debugPrint('요청 실패: HTTP 상태 코드 ${response.statusCode}');
      return false; // 실패 시 false 반환
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPath = _requestPath();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadPath,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Future가 완료되지 않은 경우
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff4d7cfe),
                foregroundColor: Colors.white,
                title: Row(
                  // Flex 대신 Row 사용
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    Expanded(
                      // Flexible 대신 Expanded 사용
                      child: Center(
                        child: Text(
                          addressName!,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 시 생략
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      // Flexible 대신 Expanded 사용
                      child: Center(
                        child: Text(
                          placeName!,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 시 생략
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios), // 원하는 아이콘으로 변경
                  onPressed: () {
                    Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아가기
                  },
                  padding: const EdgeInsets.only(right: 0),
                ),
              ),
              body: KakaoMap(
                onMapCreated: ((controller) {
                  mapController = controller;
                  if (verticalForLevel! > 0.127 ||
                      horizontalForLevel! > 0.096) {
                    mapController.setLevel(9);
                  } else if (verticalForLevel! > 0.0676 ||
                      horizontalForLevel! > 0.0518) {
                    mapController.setLevel(8);
                  } else if (verticalForLevel! > 0.0395 ||
                      horizontalForLevel! > 0.0246) {
                    mapController.setLevel(7);
                  } else if (verticalForLevel! > 0.0177 ||
                      horizontalForLevel! > 0.014) {
                    mapController.setLevel(6);
                  } else if (verticalForLevel! > 0.009 ||
                      horizontalForLevel! > 0.00551) {
                    mapController.setLevel(5);
                  } else if (verticalForLevel! > 0.0049 ||
                      horizontalForLevel! > 0.0023) {
                    mapController.setLevel(4);
                  } else {
                    mapController.setLevel(3);
                  }
                  // 경로를 지도에 그리기 위한 Polyline 객체 생성
                  polylines.add(
                    Polyline(
                      polylineId: 'path_${polylines.length}',
                      points: pathPoints,
                      strokeColor: Colors.blue,
                      strokeOpacity: 1,
                      strokeWidth: 5,
                      strokeStyle: StrokeStyle.solid,
                    ),
                  );
                  setState(() {});
                }),
                markers: markers.toList(),
                polylines: polylines.toList(),
                center: middle,
              ),
            );
          }
        });
  }
}
