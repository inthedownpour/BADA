import 'dart:convert';

import 'package:bada_kids_front/model/route_info.dart';
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:http/http.dart' as http;

class PathFind extends StatefulWidget {
  final String destinationName;
  final String destinationIcon;
  final LatLng destination;
  final String addressName;
  final String placeName;
  final int placeId;
  const PathFind({
    super.key,
    required this.destinationName,
    required this.destinationIcon,
    required this.destination,
    required this.placeName,
    required this.placeId,
    required this.addressName,
  });

  @override
  State<PathFind> createState() => _PathFindState();
}

class _PathFindState extends State<PathFind>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late KakaoMapController mapController;
  List<LatLng> pathPoints = []; // 경로 포인트 리스트
  Set<Marker> markers = {}; // 마커 변수
  Set<Polyline> polylines = {}; // 폴리라인 변수
  late LatLng destination;
  late LatLng middle;
  late LatLng currentLocation;
  Future<bool>? _loadPath;
  late double verticalForLevel;
  late double horizontalForLevel;
  StrokeStyle strokeStyle = StrokeStyle.solid;

  // 현재 위치 정보와 목적지 위치 정보를 POST 요청으로 보내기
  Future<bool> requestPath() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    MapProvider mapProvider = MapProvider.instance;
    var accessToken = (await secureStorage.read(key: 'accessToken'))!;
    debugPrint('accessToken: $accessToken');

    var url = Uri.parse('https://j10b207.p.ssafy.io/api/route');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    var requestBody = jsonEncode({
      "startLng": currentLocation.longitude.toStringAsFixed(5),
      "startLat": currentLocation.latitude.toStringAsFixed(5),
      "endLng": destination.longitude.toStringAsFixed(5),
      "endLat": destination.latitude.toStringAsFixed(5),
      "placeName": widget.placeName, // "목적지 이름"
      "addressName": widget.addressName, // "출발지 이름"
    });
    debugPrint("startLng: ${currentLocation.longitude.toStringAsFixed(5)}");
    debugPrint("startLat: ${currentLocation.latitude.toStringAsFixed(5)}");
    debugPrint("endLng: ${destination.longitude.toStringAsFixed(5)}");
    debugPrint("endLat: ${destination.latitude.toStringAsFixed(5)}");
    debugPrint("placeName: ${widget.placeName}");
    debugPrint("addressName: ${widget.addressName}");

    var response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      debugPrint('리퀘스트 성공 : ${response.body}');
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      debugPrint('responseData: $responseData');

      RouteInfo routeInfo = RouteInfo.fromJson(responseData);

      // 시작점 추가
      pathPoints.add(LatLng(routeInfo.startLat, routeInfo.startLng));

      // 경로 추가
      List<Point> pointList = routeInfo.pointList;
      for (var point in pointList) {
        pathPoints.add(LatLng(point.latitude, point.longitude));
      }

      // 종점 추가
      pathPoints.add(LatLng(routeInfo.endLat, routeInfo.endLng));

      setState(() {});
      for (var point in pathPoints) {
        debugPrint('point: $point');
      }

      debugPrint('Request successful: ${response.body}');
      mapProvider.startLatLng = currentLocation;
      mapProvider.endLatLng = destination;
      mapProvider.destinationName = widget.placeName;
      mapProvider.destinationIcon = widget.destinationIcon;
      mapProvider.destinationId = widget.placeId;
      mapProvider.initCurrentLocationUpdate();

      debugPrint('전부 성공적으로 처리되었습니다.');
      return true;
    } else {
      // 오류가 발생했을 때의 로직
      debugPrint('리퀘스트 실패 : ${response.statusCode}.');
      return false;
    }
  }

  late final AnimationController _lottieController;

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
      _lottieController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _lottieController = AnimationController(vsync: this);
    MapProvider mapProvider = MapProvider.instance;

    destination = widget.destination;
    currentLocation = mapProvider.currentLocation;
    middle = LatLng(
      (destination.latitude + currentLocation.latitude) / 2,
      (destination.longitude + currentLocation.longitude) / 2,
    );
    _loadPath = requestPath();
    verticalForLevel = (destination.latitude - currentLocation.latitude).abs();
    horizontalForLevel =
        (destination.longitude - currentLocation.longitude).abs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPath,
      builder: (context, snapshot) {
        // if (snapshot.connectionState != ConnectionState.done) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (!snapshot.hasData) {
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
                      widget.addressName,
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
                      widget.placeName,
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
      },
    );
  }
}
