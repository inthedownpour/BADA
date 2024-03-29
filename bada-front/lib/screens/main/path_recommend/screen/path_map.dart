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
        title: const Text('경로 추천'),
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
