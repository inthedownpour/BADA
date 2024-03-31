import 'dart:convert';

import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ExistingRouteScreen extends StatefulWidget {
  const ExistingRouteScreen({super.key});

  @override
  State<ExistingRouteScreen> createState() => _ExistingRouteScreenState();
}

// TODO : 기존 경로를 불러오는 기능 구현
class _ExistingRouteScreenState extends State<ExistingRouteScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  KakaoMapController? mapController;
  MapProvider mapProvider = MapProvider.instance;
  Future<List>? myPlaces;
  int? memberId;
  List<LatLng> pathPoints = []; // 경로 포인트 리스트
  Set<Marker> markers = {}; // 마커 변수
  Set<Polyline> polylines = {}; // 폴리라인 변수
  late LatLng middle;
  Future<void>? _loadPath;
  late String placeName;
  late String addressName;

  // future memberId 불러오기
  Future<void> _loadMemberId() async {
    memberId = int.parse((await secureStorage.read(key: 'memberId'))!);
  }

  Future<void> _requestPath() async {
    await _loadMemberId();
    var accessToken = (await secureStorage.read(key: 'accessToken'))!;
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/route/$memberId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      debugPrint('리퀘스트 성공 : ${response.body}');
      final responseData = json.decode(response.body);

      // 시작점 추가
      pathPoints.add(LatLng(double.parse(responseData['startLat']),
          double.parse(responseData['startLng'])));

      // 경로 추가
      if (responseData.containsKey('pointList') &&
          responseData['pointList'].isNotEmpty) {
        List<dynamic> pointList = responseData['pointList'];
        for (var point in pointList) {
          double lat = double.parse(point['latitude']);
          double lng = double.parse(point['longitude']);
          pathPoints.add(LatLng(lat, lng));
        }
      }

      // 종점 추가
      pathPoints.add(LatLng(double.parse(responseData['endLat']),
          double.parse(responseData['endLng'])));

      // 경로를 지도에 그리기 위한 Polyline 객체 생성
      Polyline polyline = Polyline(
        polylineId: 'path',
        points: pathPoints,
        fillColor: Colors.blue, // 경로 색상 설정
      );

      // 지도에 경로 표시
      polylines.add(polyline);

      placeName = responseData['placeName'];
      addressName = responseData['addressName'];

      debugPrint('Request successful: ${response.body}');
    } else {
      // 오류가 발생했을 때의 로직
      debugPrint('리퀘스트 실패 : ${response.statusCode}.');
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
                      addressName,
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
                      placeName,
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
            onMapCreated: ((controller) async {
              mapController = controller;
            }),
            markers: markers.toList(),
            polylines: polylines.toList(),
            center: middle,
          ),
        );
      },
    );
  }
}
