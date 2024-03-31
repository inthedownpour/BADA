import 'dart:convert';

import 'package:bada/screens/main/alarm/alarm_screen.dart';
import 'package:bada/screens/main/my_family/my_family.dart';
import 'package:bada/screens/main/my_place/my_place.dart';
import 'package:bada/screens/main/path_recommend/searching_path.dart';
import 'package:bada/screens/main/profile_edit.dart';
import 'package:bada/screens/main/setting/settings.dart';
import 'package:bada/screens/main/tutorial/tutorial-list.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  final _storage = const FlutterSecureStorage();
  Future<void>? load;
  String? profileUrl;
  String? nickname;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    load = _loadProfileFromStorage();
  }

  Future<void> _loadProfileFromStorage() async {
    profileUrl = await _storage.read(key: 'profileImage');
    nickname = await _storage.read(key: 'nickname');
  }

  @override
  void dispose() {
    _lottieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load,
      builder: (constext, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Row(
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
                              backgroundImage:
                                  profileUrl == '' || profileUrl == null
                                      ? Image.asset(
                                          'assets/img/default_profile.png',
                                        ).image
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
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Settings(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainLarge(
                      label: '우리 가족',
                      backgroundColor: const Color(0xff777CFF),
                      foregroundColor: Colors.white,
                      buttonImage: Image.asset('assets/img/family-button.png'),
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
                    MainSmall(
                      label: '알림',
                      buttonImage: Lottie.asset(
                        'assets/lottie/notification.json',
                        controller: _lottieController,
                        onLoaded: ((p0) {
                          _lottieController.duration = p0.duration;
                          _lottieController.forward();
                        }),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlarmScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainSmall(
                      label: '내 장소',
                      buttonImage: Lottie.asset(
                        'assets/lottie/location-pin.json',
                        controller: _lottieController,
                        onLoaded: ((p0) {
                          _lottieController.duration = p0.duration;
                          _lottieController.forward();
                        }),
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
                    MainLarge(
                      label: '경로 추천 받기',
                      buttonImage: Image.asset(
                        'assets/img/map-bg.png',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchingPath(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button714_300(
                      label: '바래다줄게 설명서',
                      buttonImage: Lottie.asset(
                        'assets/lottie/tutorial.json',
                        height: 50,
                        width: 50,
                        controller: _lottieController,
                        onLoaded: ((p0) {
                          _lottieController.duration = p0.duration;
                          _lottieController.forward();
                        }),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TutorialList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
