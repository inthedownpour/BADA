import 'package:bada/models/category_icon_mapper.dart';
import 'package:bada/provider/map_provider.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:bada/models/search_results.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart'; // SearchResultItem 모델 import 필요

class SearchMapScreen extends StatefulWidget {
  final SearchResultItem item;
  final String keyword;

  const SearchMapScreen({
    super.key,
    required this.item,
    required this.keyword,
  });

  @override
  State<SearchMapScreen> createState() => _SearchMapScreenState();
}

class _SearchMapScreenState extends State<SearchMapScreen> {
  late KakaoMapController mapController;
  late MapProvider mapProvider;
  late LatLng searchedLocation;

  Set<Marker> markers = {};

  // 현재 위치 업데이트 및 현재 위치로 화면 이동
  Future<void> _updateSearchedLocation() async {
    LatLng searchedLocation =
        LatLng(double.parse(widget.item.y), double.parse(widget.item.x));
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: 'searched_location',
          latLng: searchedLocation,
          width: 30,
          height: 44,
          offsetX: 15,
          offsetY: 44,
        ),
      );
    });
  }

  void moveToSearchedLocation() async {
    searchedLocation =
        LatLng(double.parse(widget.item.y), double.parse(widget.item.x));
    await mapController.setCenter(searchedLocation);
  }

  void backToPreviousScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // KakaoMap 위치 표시 (실제 KakaoMap 위젯으로 대체 필요)
          Positioned.fill(
            child: Container(
              child: KakaoMap(
                onMapCreated: (controller) {
                  mapController = controller;
                  _updateSearchedLocation();
                  moveToSearchedLocation();
                },
                markers: markers.toList(),
              ),
            ),
          ),
          // 상단에 위치한 검색 키워드 표시
          Positioned(
            top: 40, // 상태바 높이를 고려한 여백
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: TextEditingController(text: widget.keyword),
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 0.1,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // 아이콘 버튼을 눌렀을 때 수행할 동작
                    },
                  ),
                ),
              ),
            ),
          ),
          // 하단에 위치한 주소, 카테고리, 장소이름 표시
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.placeName,
                        style: const TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: UIhelper.scaleHeight(context) * 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.item.addressName,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UIhelper.scaleHeight(context) * 8,
                      ),
                    ],
                  ),

                  Image.asset(
                    CategoryIconMapper.getIconUrl(
                      widget.item.categoryGroupName,
                    ),
                    width: UIhelper.scaleWidth(context) * 60,
                  ),
                  // Text(
                  //   item.categoryGroupName,
                  //   style: const TextStyle(fontSize: 18),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
