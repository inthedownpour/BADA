import 'dart:convert';

import 'package:bada/screens/main/my_family/my_family.dart';
import 'package:bada/screens/main/my_place/my_place.dart';
import 'package:bada/screens/main/path_recommend/searching_path.dart';
import 'package:bada/screens/main/profile_edit.dart';
import 'package:bada/screens/main/setting/settings.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();
  Future<void>? load;
  String? profileUrl;
  String? nickname;

  @override
  void initState() {
    super.initState();
    load = _loadProfileFromStorage();
  }

  Future<void> _loadProfileFromStorage() async {
    profileUrl = await _storage.read(key: 'profileImage');
    nickname = await _storage.read(key: 'nickname');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load,
      builder: (constext, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Transform.translate(
                offset: const Offset(60, 570),
                child: Image.asset('assets/img/map-bg.png'),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: UIhelper.scaleHeight(context) * 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEdit(
                                  nickname: nickname,
                                  profileUrl: profileUrl,
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: profileUrl == '' ||
                                    profileUrl == null
                                ? Image.asset('assets/img/default_profile.png')
                                    .image
                                : NetworkImage(
                                    profileUrl!,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: UIhelper.scaleWidth(context) * 10,
                        ),
                        Text(
                          '안녕하세요, \n${nickname ?? '사용자'}님!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: UIhelper.scaleHeight(context) * 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button330_220(
                          label: '우리 가족',
                          backgroundColor: const Color(0xff777CFF),
                          foregroundColor: Colors.white,
                          buttonImage: Image.asset(
                            'assets/img/family-button.png',
                          ),
                          imageWidth: UIhelper.scaleWidth(context) * 120,
                          padBottom: 0,
                          padRight: 5,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyFamily(),
                              ),
                            );
                          },
                        ),
                        Button330_220(
                          label: '내 장소',
                          buttonImage: Lottie.asset(
                            'assets/lottie/location-pin.json',
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyPlace(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: UIhelper.scaleHeight(context) * 15,
                    ),
                    Button714_300(
                      label: '경로 추천 받기',
                      buttonImage: Image.asset('assets/img/map-phone.png'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchingPath(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: UIhelper.scaleHeight(context) * 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button330_220(
                          label: '설정',
                          buttonImage:
                              Lottie.asset('assets/lottie/settings.json'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Settings(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: UIhelper.scaleWidth(context) * 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
