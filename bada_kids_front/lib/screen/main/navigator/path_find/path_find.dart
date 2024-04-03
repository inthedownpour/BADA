import 'dart:convert';
import 'dart:ffi';
import 'package:bada_kids_front/model/route_info.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:bada_kids_front/provider/profile_provider.dart';
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
        "myPlaceId": widget.placeId,
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude,
        "content": '보낸 시각은 : ${DateTime.now().toString()}',
        "childName": profile.name,
        "phone": profile.phone,
        "profileUrl": profile.profileUrl,
        "destinationName": widget.destinationName,
        "destinationIcon": widget.destinationIcon
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('79 성공');
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
      postArrive();
    } else {
      debugPrint('1. ${res1.statusCode} 2.${res2.statusCode}');
    }
  }

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
      "placeName": widget.placeName,
      "addressName": widget.addressName,
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
      debugPrint('path 추가 완료 132');

      pathPoints.add(LatLng(routeInfo.startLat, routeInfo.startLng));
      debugPrint('path 추가 완료 135');

      List<Point> pointList = routeInfo.pointList;
      for (var point in pointList) {
        pathPoints.add(LatLng(point.latitude, point.longitude));
      }
      debugPrint('path 추가 완료 141');

      pathPoints.add(LatLng(routeInfo.endLat, routeInfo.endLng));
      debugPrint('path 추가 완료 145');

      setState(() {});
      for (var point in pathPoints) {
        debugPrint('point: $point');
      }

      debugPrint('path 추가 완료 152');

      debugPrint('Request successful: ${response.body}');
      mapProvider.startLatLng = currentLocation;
      mapProvider.endLatLng = destination;
      mapProvider.destinationName = widget.placeName;
      mapProvider.destinationIcon = widget.destinationIcon;
      mapProvider.destinationId = widget.placeId;
      await mapProvider.initCurrentLocationUpdate();

      return true;
    } else {
      debugPrint('리퀘스트 실패 167 : ${response.statusCode}. 지금 158');
      return false;
    }
  }

  late final AnimationController _lottieController;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lottieController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _lottieController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

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
          // appBar: AppBar(
          //   backgroundColor: const Color.fromARGB(255, 132, 138, 154),
          //   foregroundColor: Colors.white,
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: Center(
          //           child: Text(
          //             widget.addressName,
          //             style: const TextStyle(fontSize: 18),
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //       ),
          //       const Icon(
          //         Icons.arrow_forward,
          //         size: 20,
          //       ),
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       Expanded(
          //         child: Center(
          //           child: Text(
          //             widget.placeName,
          //             style: const TextStyle(fontSize: 18),
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //     ],
          //   ),
          //   centerTitle: true,
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back_ios),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     padding: const EdgeInsets.only(right: 0),
          //   ),
          // ),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.85,
                    child: KakaoMap(
                      onMapCreated: ((controller) async {
                        mapController = controller;
                        if (verticalForLevel > 0.127 ||
                            horizontalForLevel > 0.096) {
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
                  ),
                  Container(
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
                            Image.asset(
                              widget.destinationIcon,
                              width: UIhelper.deviceWidth(context) * 0.12,
                              height: UIhelper.deviceHeight(context) * 0.12,
                            ),
                            Column(
                              children: [
                                const Text('목적지'),
                                SizedBox(
                                  height: UIhelper.deviceHeight(context) * 0.02,
                                ),
                                Text(
                                  widget.destinationName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
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
                  )
                ],
              ),
              Positioned(
                top: 0,
                child: Container(
                  color: const Color.fromARGB(225, 79, 79, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: UIhelper.deviceWidth(context),
                  height: UIhelper.deviceHeight(context) * 0.13,
                  child: Column(
                    children: [
                      SizedBox(
                        height: UIhelper.deviceHeight(context) * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 30,
                                color: Colors.white,
                              )),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.addressName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.placeName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
