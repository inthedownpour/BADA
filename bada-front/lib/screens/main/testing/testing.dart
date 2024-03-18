import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
// import 'package:kakao_map_plugin_example/src/home_screen.dart';

/// 키워드로 장소검색하기
/// https://apis.map.kakao.com/web/sample/keywordBasic/
class Test extends StatefulWidget {
  const Test({super.key, this.title});

  final String? title;

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late KakaoMapController mapController;

  bool draggable = true;
  bool zoomable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'selectedTitle'),
      ),
      body: KakaoMap(
        onMapCreated: ((controller) async {
          mapController = controller;

          await controller.keywordSearch();
        }),
      ),
    );
  }
}
