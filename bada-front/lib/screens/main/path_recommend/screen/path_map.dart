import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bada/screens/main/path_recommend/model/path_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class PathMap extends StatefulWidget {
  List<Point> pathList;
  String departure;
  String destination;
  LatLng departureLatLng;
  LatLng destinationLatLng;

  // TODO : 경로 List 받아오기 및 경로 폴리라인 그리기
  PathMap({
    super.key,
    required this.pathList,
    required this.departure,
    required this.destination,
    required this.departureLatLng,
    required this.destinationLatLng,
  });

  @override
  State<PathMap> createState() => _PathMapState();
}

class _PathMapState extends State<PathMap> {
  late KakaoMapController mapController;
  late List<LatLng> latLngList;
  late LatLng center;
  late double verticalForLevel;
  late double horizontalForLevel;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  bool isCctvActivated = false;

  Future<List<Marker>> loadCctvData() async {
    // assets에서 JSON 파일 읽기
    String jsonString =
        await rootBundle.loadString('assets/safe_facility/cctv.json');
    List<dynamic> jsonResponse = jsonDecode(jsonString);

    // JSON 데이터를 LatLng 리스트로 변환
    List<Marker> cctvList = jsonResponse
        .map(
          (item) => Marker(
            markerId: 'cctv',
            latLng: LatLng(
              double.parse(item['facility_latitude']),
              double.parse(item['facility_longitude']),
            ),
            width: 30,
            height: 30,
          ),
        )
        .toList();

    return cctvList;
  }

  // Point 리스트를 LatLng 리스트로 변환하는 함수
  List<LatLng> convertPointsToLatLng(List<Point> pathList) {
    // Point 객체의 리스트를 순회하면서 각각의 Point 객체로부터 새로운 LatLng 객체를 생성
    return pathList
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  Future<List<Marker>>? cctvData;

  @override
  void initState() {
    super.initState();
    cctvData = loadCctvData();
    latLngList = convertPointsToLatLng(widget.pathList);
    LatLng start = latLngList.first;
    debugPrint("start: $start");
    LatLng end = latLngList.last;
    debugPrint("end: $end");
    verticalForLevel = (start.latitude - end.latitude).abs();
    horizontalForLevel = (start.longitude - end.longitude).abs();
    double lat = (start.latitude + end.latitude) / 2;
    double lng = (start.longitude + end.longitude) / 2;
    center = LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    const startSrc =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/start.png';
    const endSrc =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/end.png';
    return FutureBuilder(
      future: cctvData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                      widget.departure,
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
                      widget.destination,
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
                ),
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
          body: Stack(
            // TODO : 아이의 정보를 받아오기 POST요청 및 그 숫자만큼 CircleAvatar 생성
            // TODO : circleAvatar를 터치하면 아이의 위치를 표시할 수 있도록 함
            children: [
              KakaoMap(
                onMapCreated: (controller) {
                  mapController = controller;
                  mapController.setCenter(center);
                  if (verticalForLevel > 0.127 || horizontalForLevel > 0.096) {
                    mapController.setLevel(9);
                  } else if (verticalForLevel > 0.0676 ||
                      horizontalForLevel > 0.0518) {
                    mapController.setLevel(8);
                  } else if (verticalForLevel > 0.0395 ||
                      horizontalForLevel > 0.0246) {
                    mapController.setLevel(7);
                  } else if (verticalForLevel > 0.0177 ||
                      horizontalForLevel > 0.014) {
                    mapController.setLevel(6);
                  } else if (verticalForLevel > 0.009 ||
                      horizontalForLevel > 0.00551) {
                    mapController.setLevel(5);
                  } else if (verticalForLevel > 0.0049 ||
                      horizontalForLevel > 0.0023) {
                    mapController.setLevel(4);
                  } else {
                    mapController.setLevel(3);
                  }

                  polylines.add(
                    Polyline(
                      polylineId: 'polyline_${polylines.length}',
                      points: latLngList,
                      strokeColor: Colors.blue,
                      strokeOpacity: 1,
                      strokeWidth: 5,
                      strokeStyle: StrokeStyle.solid,
                    ),
                  );
                  markers.add(
                    Marker(
                      markerId: 'departure',
                      latLng: widget.departureLatLng,
                      markerImageSrc: startSrc,
                      offsetX: 15,
                      offsetY: 30,
                      width: 28,
                      height: 35,
                    ),
                  );
                  markers.add(
                    Marker(
                      markerId: 'destination',
                      latLng: widget.destinationLatLng,
                      markerImageSrc: endSrc,
                      offsetX: 15,
                      offsetY: 30,
                      width: 28,
                      height: 35,
                    ),
                  );

                  setState(() {});
                },
                polylines: polylines.toList(),
                markers: markers.toList(),
              ),
              Positioned(
                bottom: 80,
                right: 20,
                child: GestureDetector(
                  onTap: () async {
                    if (isCctvActivated) {
                      isCctvActivated = !isCctvActivated;
                      markers
                          .removeWhere((marker) => marker.markerId == 'cctv');
                    } else {
                      isCctvActivated = !isCctvActivated;
                      // cctv 리스트 마커 추가
                      for (var cctv in snapshot.data as List<Marker>) {
                        markers.add(
                          Marker(
                            markerId: 'cctv',
                            latLng: cctv.latLng,
                            markerImageSrc:
                                'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/cctv2.png',
                            offsetX: 12,
                            offsetY: 12,
                            width: 30,
                            height: 30,
                          ),
                        );
                      }
                    }
                    setState(() {});
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/cctv1.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
