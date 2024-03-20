import 'package:bada/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class Test extends StatefulWidget {
  const Test({super.key, this.title});

  final String? title;

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late KakaoMapController mapController;
  late MapProvider mapProvider;
  LatLng currentLocation = LatLng(127.29801308566, 36.351073954997);
  bool isLocationServiceEnabled = false;
  Set<Marker> markers = {}; // 마커 Set

  @override
  void initState() {
    super.initState();
    mapProvider = MapProvider(); // MapProvider 인스턴스 생성
    mapProvider.addListener(_updateCurrentLocation); // 리스너 등록
    isLocationServiceEnabled = mapProvider.isLocationServiceEnabled;

    if (isLocationServiceEnabled) {
      _updateCurrentLocation(); // 초기 위치 설정
    }
  }

  Future<void> _updateCurrentLocation() async {
    if (!mounted) return;
    LatLng currentLocation = mapProvider.currentLocation;
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: 'current_location',
          latLng: currentLocation,
          width: 30,
          height: 44,
          offsetX: 15,
          offsetY: 44,
          markerImageSrc:
              'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
        ),
      );
    });

    mapController.panTo(currentLocation); // 현재 위치로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '현재 위치'),
      ),
      body: KakaoMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: markers.toList(),
      ),
    );
  }
}
