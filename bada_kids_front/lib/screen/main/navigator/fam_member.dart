import 'dart:convert';

import 'package:bada_kids_front/model/member.dart';
import 'package:bada_kids_front/provider/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class FamMember extends StatefulWidget {
  const FamMember({super.key});

  @override
  State<FamMember> createState() => _FamMemberState();
}

class _FamMemberState extends State<FamMember> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ProfileProvider _profileProvider = ProfileProvider.instance;
  Future<List<Member>>? _familyList;
  String? _profileUrl;
  String? _name;
  String? _phone;
  int? _memberId;

  @override
  void initState() {
    super.initState();
    _profileProvider.init().then((_) {
      setState(() {
        _profileUrl = _profileProvider.profileUrl;
        _name = _profileProvider.name;
        _phone = _profileProvider.phone;
        _memberId = _profileProvider.memberId;
      });
    });
    _familyList = loadFamilyList(); // 여기서 Future를 저장합니다.
  }

  Future<List<Member>> loadFamilyList() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    debugPrint('accessToken: $accessToken');

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/family'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final familyListJson = data['familyList'] as List;
      List<Member> tmpList =
          familyListJson.map((json) => Member.fromJson(json)).toList();

      List<Member> familyList = tmpList
          .where((member) =>
              member.memberId != _memberId &&
              member.phone != null &&
              member.phone != "")
          .toList();
      return familyList; // Future<List<Member>>를 반환합니다.
    } else {
      debugPrint('프로필 정보를 불러오는데 실패했습니다: ${response.body}');
      throw Exception('Failed to load family list');
    }
  }

  String formatPhoneNumber(String phone) {
    // 문자열이 충분히 길면 '-'를 추가합니다.
    if (phone.length == 11) {
      return '${phone.substring(0, 3)}-${phone.substring(3, 7)}-${phone.substring(7, 11)}';
    }
    return phone; // 그렇지 않으면 원본 문자열을 반환합니다.
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '전화하기',
          style: TextStyle(fontFamily: 'Pretendard-Bold.otf'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // 원하는 아이콘으로 변경
          onPressed: () {
            Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: deviceWidth * 0.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Member>>(
                future: _familyList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("데이터 로드에 실패했습니다.");
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        // 리스트의 마지막 인덱스인 경우 구분선을 추가합니다.
                        if (index == snapshot.data!.length) {
                          return const Divider();
                        }
                        Member member = snapshot.data![index];

                        return Row(children: [
                          Expanded(
                            child: ListTile(
                              dense: true,
                              leading: member.profileUrl != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(member.profileUrl!),
                                    )
                                  : const Icon(Icons.account_circle, size: 50),
                              title: Text(
                                member.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              subtitle: Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight * 0.01),
                                child:
                                    Text(formatPhoneNumber(member.phone ?? "")),
                              ),
                              onTap: () async {},
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: member.phone,
                              );
                              if (await canLaunchUrl(launchUri)) {
                                await launchUrl(launchUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("이 장치에서는 전화를 걸 수 없습니다."),
                                  ),
                                );
                              }
                            },
                            child: const Icon(
                              Icons.phone,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: deviceWidth * 0.05)
                        ]);
                      },
                      separatorBuilder: (context, index) {
                        // 마지막 아이템의 경우 구분선을 렌더링하지 않습니다.
                        if (index == snapshot.data!.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return const Divider();
                      },
                    );
                  } else {
                    return const Text("데이터가 없습니다.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
