import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bada_kids_front/model/route_info.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:bada_kids_front/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart' as kakao;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:lottie/lottie.dart';

class ExistingRouteScreen extends StatefulWidget {
  const ExistingRouteScreen({super.key});

  @override
  State<ExistingRouteScreen> createState() => _ExistingRouteScreenState();
}

// TODO : 경로 삭제 버튼 추가
class _ExistingRouteScreenState extends State<ExistingRouteScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late kakao.KakaoMapController mapController;
  late final AnimationController _lottieController;
  MapProvider mapProvider = MapProvider.instance;
  final ProfileProvider _profileProvider = ProfileProvider.instance;
  Future<List>? myPlaces;
  late int memberId;
  List<kakao.LatLng> pathPoints = []; // 경로 포인트 리스트
  List<kakao.Marker> cctvList = []; // cctv 리스트
  Set<kakao.Marker> markers = {}; // 마커 변수
  Set<kakao.Polyline> polylines = {}; // 폴리라인 변수
  Future<List<kakao.Marker>>? _loadPath;
  String? placeName, addressName, destinationIcon;
  kakao.LatLng? departureLatLng, destinationLatLng, middle;
  double? verticalForLevel, horizontalForLevel;
  int? placeId;
  bool isCctvActivated = false;

  Future<List<kakao.Marker>> loadCctvData() async {
    // assets에서 JSON 파일 읽기
    String jsonString =
        await rootBundle.loadString('assets/safe_facility/cctv.json');
    List<dynamic> jsonResponse = jsonDecode(jsonString);

    // JSON 데이터를 kakao.LatLng 리스트로 변환
    List<kakao.Marker> cctvList = jsonResponse
        .map(
          (item) => kakao.Marker(
            markerId: 'cctv',
            latLng: kakao.LatLng(
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

  Future<void> postArrive() async {
    ProfileProvider profile = ProfileProvider.instance;

    var url = Uri.parse('https://j10b207.p.ssafy.io/api/kafka/alarm');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "type": 'ARRIVE',
        "memberId": profile.memberId,
        "familyCode": profile.familyCode,
        "myPlaceId": placeId,
        "latitude": mapProvider.currentLocation.latitude,
        "longitude": mapProvider.currentLocation.longitude,
        "content": '보낸 시각은 : ${DateTime.now().toString()}',
        "childName": profile.name,
        "phone": profile.phone,
        "profileUrl": profile.profileUrl,
        "destinationName": placeName,
        "destinationIcon": destinationIcon
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('79 성공');
      arrived();
    }
  }

  Future<void> arrived() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var token = await secureStorage.read(key: 'accessToken');
    var url1 = Uri.parse('https://j10b207.p.ssafy.io/api/route');
    var url2 = Uri.parse('https://j10b207.p.ssafy.io/api/currentLocation');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var res1 = await http.delete(url1, headers: headers);
    var res2 = await http.delete(url2, headers: headers);

    if (res1.statusCode == 200 && res2.statusCode == 200) {
      debugPrint('도착');
    } else {
      debugPrint('1. ${res1.statusCode} 2.${res2.statusCode}');
    }
  }

  Future<List<kakao.Marker>> _requestPath() async {
    int memberId = _profileProvider.memberId; // 멤버 ID 가져오기
    List<kakao.Marker> cctvData = [];
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
      pathPoints.add(kakao.LatLng(routeInfo.startLat, routeInfo.startLng));

      List<Point> pointList = routeInfo.pointList;
      for (var point in pointList) {
        double lat = point.latitude;
        double lng = point.longitude;
        pathPoints.add(kakao.LatLng(lat, lng));
      }

      // 종점 추가
      pathPoints.add(kakao.LatLng(routeInfo.endLat, routeInfo.endLng));

      setState(() {
        middle = kakao.LatLng(
          (routeInfo.startLat + routeInfo.endLat) / 2,
          (routeInfo.startLng + routeInfo.endLng) / 2,
        );
        addressName = routeInfo.addressName;
        placeName = routeInfo.placeName;
        departureLatLng = kakao.LatLng(routeInfo.startLat, routeInfo.startLng);
        destinationLatLng = kakao.LatLng(routeInfo.endLat, routeInfo.endLng);
        destinationIcon = routeInfo.destinationIcon;
        placeId = routeInfo.placeId;
        verticalForLevel = (routeInfo.startLat - routeInfo.endLat).abs();
        horizontalForLevel = (routeInfo.startLng - routeInfo.endLng).abs();
      });

      debugPrint('startLng: ${routeInfo.startLng}');
      debugPrint('startLat: ${routeInfo.startLat}');
      debugPrint('endLng: ${routeInfo.endLng}');
      debugPrint('endLat: ${routeInfo.endLat}');
      debugPrint('placeName: ${routeInfo.placeName}');
      debugPrint('addressName: ${routeInfo.addressName}');

      cctvData = await loadCctvData();

      return cctvData; // RouteInfo 객체를 반환
    } else {
      debugPrint('요청 실패: HTTP 상태 코드 ${response.statusCode}');
      throw Exception('경로 가져오기 실패'); // 실패 시 false 반환
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _lottieController = AnimationController(vsync: this);
    _loadPath = _requestPath();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer를 해제합니다.
    _lottieController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 다시 활성화될 때 애니메이션을 재시작합니다.
    if (state == AppLifecycleState.resumed) {
      _lottieController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    const startSrc =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/start.png';
    const endSrc =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/end.png';
    const childrenLocation =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/defaultprofile.png';

    return FutureBuilder(
        future: _loadPath,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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
              body: Stack(
                children: [
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.85,
                    child: KakaoMap(
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
                        // 경로를 지도에 그리기 위한 kakao.Polyline 객체 생성
                        polylines.add(
                          kakao.Polyline(
                            polylineId: 'path_${polylines.length}',
                            points: pathPoints,
                            strokeColor: Colors.blue,
                            strokeOpacity: 1,
                            strokeWidth: 5,
                            strokeStyle: StrokeStyle.solid,
                          ),
                        );
                        markers.add(
                          kakao.Marker(
                            markerId: 'departure',
                            latLng: departureLatLng!,
                            markerImageSrc: startSrc,
                            offsetX: 15,
                            offsetY: 30,
                            width: 28,
                            height: 35,
                          ),
                        );
                        markers.add(
                          kakao.Marker(
                            markerId: 'destination',
                            latLng: destinationLatLng!,
                            markerImageSrc: endSrc,
                            offsetX: 15,
                            offsetY: 30,
                            width: 28,
                            height: 35,
                          ),
                        );
                        setState(() {});
                      }),
                      markers: markers.toList(),
                      polylines: polylines.toList(),
                      center: middle,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      height: UIhelper.deviceHeight(context) * 0.15,
                      width: UIhelper.deviceWidth(context),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (destinationIcon != null)
                                Image.asset(
                                  destinationIcon!,
                                  width: UIhelper.deviceWidth(context) * 0.12,
                                  height: UIhelper.deviceHeight(context) * 0.12,
                                ),
                              SizedBox(
                                width: UIhelper.deviceWidth(context) * 0.45,
                                child: Column(
                                  children: [
                                    const Text('목적지'),
                                    SizedBox(
                                      height:
                                          UIhelper.deviceHeight(context) * 0.02,
                                    ),
                                    Text(
                                      placeName ?? '못받음',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  arrived();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Debug Alert'),
                                        content: const Text(
                                          'Arrived method has been called.',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              postArrive();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('도착'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 200,
                    right: 20,
                    child: GestureDetector(
                      onTap: () async {
                        // await _requestCurrentLocation();
                        // kakao.markerId가 'currentLocation'인 마커를 markers 집합에서 제거
                        markers.removeWhere(
                          (marker) => marker.markerId == 'currentLocation',
                        );
                        markers.add(
                          kakao.Marker(
                            markerId: 'currentLocation',
                            latLng: mapProvider.currentLocation,
                            markerImageSrc: childrenLocation,
                            offsetX: 12,
                            offsetY: 12,
                            width: 30,
                            height: 30,
                          ),
                        );

                        await mapController.panTo(mapProvider.currentLocation);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/down-arrow.json',
                            width: 60,
                            height: 60,
                            controller: _lottieController,
                            onLoaded: (p0) {
                              _lottieController.duration = p0.duration;
                              _lottieController.repeat();
                            },
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(_profileProvider.profileUrl!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 130,
                    right: 20,
                    child: GestureDetector(
                      onTap: () async {
                        if (isCctvActivated) {
                          isCctvActivated = !isCctvActivated;
                          markers.removeWhere(
                              (marker) => marker.markerId == 'cctv');
                        } else {
                          isCctvActivated = !isCctvActivated;
                          // cctv 리스트 마커 추가
                          for (var cctv
                              in snapshot.data as List<kakao.Marker>) {
                            markers.add(
                              kakao.Marker(
                                markerId: 'cctv',
                                latLng: cctv.latLng,
                                markerImageSrc:
                                    'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/cctv2.png',
                                offsetX: 12,
                                offsetY: 12,
                                width: 24,
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
          }
        });
  }
}
