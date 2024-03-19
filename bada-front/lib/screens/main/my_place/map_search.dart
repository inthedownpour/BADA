import 'dart:convert';

import 'package:bada/models/search_results.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapSearch extends StatefulWidget {
  const MapSearch({super.key});

  @override
  State<MapSearch> createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final TextEditingController _controller = TextEditingController();
  Future<List<SearchResultItem>>? _searchResult;
  final bool _isSearching = false;

  Future<List<SearchResultItem>> fetchSearchResults(String keyword) async {
    var url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/keyword.json?query=$keyword',
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'KakaoAK be8a38ff76c199cc88b459e8c29957be'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body)['documents'];
      List<SearchResultItem> items = jsonList
          .map((jsonItem) => SearchResultItem.fromJson(jsonItem))
          .toList();
      return items;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.1),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: '키워드를 입력해주세요',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchResult = fetchSearchResults(_controller.text);
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<SearchResultItem>>(
                future: _searchResult,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        SearchResultItem item = snapshot.data![index];
                        return ListTile(
                          title: Text(item.placeName),
                          subtitle: Text(item.addressName),
                          tileColor: Colors.white,
                        );
                      },
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    child: const Text('아직 검색된 키워드가 없습니다.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
