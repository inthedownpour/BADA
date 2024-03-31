import 'dart:developer';
import 'dart:io';

import 'package:bada/screens/main/path_recommend/model/path_response.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class PathMap extends StatefulWidget {
  List<Point> pathList;

  // TODO : 경로 List 받아오기 및 경로 폴리라인 그리기
  PathMap({super.key, required this.pathList});

  @override
  State<PathMap> createState() => _PathMapState();
}

class _PathMapState extends State<PathMap> {
  late KakaoMapController mapController;
  late List<LatLng> latLngList;
  late LatLng center;
  Set<Polyline> polylines = {};

  // Point 리스트를 LatLng 리스트로 변환하는 함수
  List<LatLng> convertPointsToLatLng(List<Point> pathList) {
    // Point 객체의 리스트를 순회하면서 각각의 Point 객체로부터 새로운 LatLng 객체를 생성
    return pathList
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    latLngList = convertPointsToLatLng(widget.pathList);
    LatLng start = latLngList.first;
    debugPrint("start: $start");
    LatLng end = latLngList.last;
    debugPrint("end: $end");
    double lat = (start.latitude + end.latitude) / 2;
    double lng = (start.longitude + end.longitude) / 2;
    center = LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4d7cfe),
        foregroundColor: Colors.white,
        title: Row(
          // Flex 대신 Row 사용
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: [
            const Expanded(
              // Flexible 대신 Expanded 사용
              child: Center(
                child: Text(
                  '현재 위치asdasdasd',
                  style: TextStyle(fontSize: 18),
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
            const Expanded(
              // Flexible 대신 Expanded 사용
              child: Center(
                child: Text(
                  '목적지asdasdasdasd',
                  style: TextStyle(fontSize: 18),
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
              polylines.add(
                Polyline(
                  polylineId: 'polyline_${polylines.length}',
                  points: latLngList,
                  strokeColor: Colors.blue,
                  strokeOpacity: 1,
                  strokeWidth: 10,
                  strokeStyle: StrokeStyle.solid,
                ),
              );
              setState(() {});
            },
            polylines: polylines.toList(),
          ),
          Positioned(
            right: 12, // 오른쪽으로부터 20px 떨어진 위치
            top: 15, // 상단으로부터 20px 떨어진 위치
            child: GestureDetector(
              onTap: () {
                debugPrint("CircleAvatar 터치!");
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
