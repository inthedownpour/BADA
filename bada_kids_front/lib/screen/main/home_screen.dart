import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bada_kids_front/model/buttons.dart';
import 'package:bada_kids_front/model/member.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:bada_kids_front/provider/profile_provider.dart';
import 'package:bada_kids_front/screen/main/navigator/destination_select_screen.dart';
import 'package:bada_kids_front/screen/main/navigator/path_find/existing_route_screen.dart';
import 'package:bada_kids_front/screen/main/navigator/fam_member.dart';
import 'package:bada_kids_front/screen/main/navigator/profile_edit.dart';
import 'package:bada_kids_front/screen/main/navigator/settings.dart';
import 'package:bada_kids_front/widget/fam_member.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();

  late ProfileProvider _profileProvider;
  late MapProvider _mapProvider;

  // 변수
  XFile? _imageFile;
  final bool _hasProfileUrl = false;
  String? _profileUrl;
  String? _name;
  int? _memberId;
  int? _movingState;
  Future<bool>? _load;

  Future<bool> _loadProfile() async {
    try {
      await _profileProvider.loadProfile();
      setState(() {
        _profileUrl = _profileProvider.profileUrl;
        _name = _profileProvider.name;
        _memberId = _profileProvider.memberId;
        _movingState = _profileProvider.movingState;
      });
      return true;
    } catch (e) {
      debugPrint('프로필 정보를 불러오는데 실패했습니다.');
      return false;
    }
  }

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _lottieController = AnimationController(vsync: this);
    _mapProvider = MapProvider.instance;
    _profileProvider = ProfileProvider.instance;

    _load = _loadProfile();
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
      _profileProvider = ProfileProvider.instance;
      _load = _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);

    return FutureBuilder(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Positioned(
                    top: UIhelper.scaleHeight(context) * -120,
                    child: Lottie.asset(
                      'assets/lottie/walking-cloud.json',
                      width: UIhelper.scaleWidth(context) * 400,
                      height: UIhelper.scaleHeight(context) * 400,
                    ),
                  ),
                  Positioned(
                    right: UIhelper.scaleWidth(context) * -130,
                    top: UIhelper.scaleHeight(context) * 0,
                    child: Lottie.asset(
                      'assets/lottie/loading-cat.json',
                      width: UIhelper.scaleWidth(context) * 400,
                      controller: _lottieController,
                      onLoaded: ((p0) {
                        _lottieController.duration = p0.duration;
                        _lottieController.repeat();
                      }),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      deviceWidth * 0.05,
                      deviceHeight * 0.08,
                      deviceWidth * 0.05,
                      deviceHeight * 0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: deviceHeight * 0.185),
                        Button714_300(
                          label: '출발하기',
                          onPressed: () {
                            _profileProvider.movingState == 1
                                ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ExistingRouteScreen()))
                                    .then((_) {
                                    // 화면 복귀 후 실행할 로직
                                    _load = _loadProfile(); // _load 재할당
                                    setState(() {}); // 필요 시 상태 업데이트
                                  })
                                : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DestinationSelectScreen()))
                                    .then((_) {
                                    // 화면 복귀 후 실행할 로직
                                    _load = _loadProfile(); // _load 재할당
                                    setState(() {}); // 필요 시 상태 업데이트
                                  });
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: deviceWidth * 0.06,
              top: deviceHeight * 0.15,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEdit(
                        nickname: _name,
                        memberId: _memberId,
                        profileUrl: _profileUrl,
                      ),
                    ),
                  ).then((_) {
                    // 화면 복귀 후 실행할 로직
                    _load = _loadProfile(); // _load 재할당
                    setState(() {}); // 필요 시 상태 업데이트
                  });
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent, // 백그라운드 색을 투명하게 설정
                  backgroundImage: _profileUrl != null
                      ? NetworkImage(_profileUrl!) as ImageProvider<Object>?
                      : const AssetImage('assets/img/account-circle.png'),
                ),
              ),
            ),
            Positioned(
              top: deviceHeight * 0.19,
              left: deviceWidth * 0.15,
              child: IconButton(
                icon: const Icon(Icons.add_circle,
                    color: Color(0xff696DFF), size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEdit(
                        nickname: _name,
                        memberId: _memberId,
                        profileUrl: _profileUrl,
                      ),
                    ),
                  ).then((_) {
                    // 화면 복귀 후 실행할 로직
                    _load = _loadProfile(); // _load 재할당
                    setState(() {}); // 필요 시 상태 업데이트
                  });
                },
              ),
            ),
            Positioned(
              left: deviceWidth * 0.26,
              top: deviceHeight * 0.161,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_name님',
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  const Text(
                    '안녕하세요!',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Positioned(
              right: deviceWidth * 0.1, // 오른쪽에서부터의 위치 조정
              top: deviceHeight * 0.35,
              width: deviceWidth * 0.25,
              height: deviceHeight * 0.2,
              child: IgnorePointer(
                  child: Lottie.asset(
                'assets/lottie/map.json',
                controller: _lottieController,
                onLoaded: ((p0) {
                  _lottieController.duration = p0.duration;
                  _lottieController.repeat();
                }),
              )), // 아래에서부터의 위치 조정
            ),
            Positioned(
              left: deviceWidth * 0.05, // 왼쪽에서부터의 위치 조정
              bottom: deviceHeight * 0.202, // 아래에서부터의 위치 조정
              child: MainSmallButton(
                label: '설정',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: deviceWidth * 0.23, // 오른쪽에서부터의 위치 조정
              bottom: deviceHeight * 0.17,
              width: deviceWidth * 0.25,
              height: deviceHeight * 0.2,
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/lottie/settings.json',
                  controller: _lottieController,
                  onLoaded: ((p0) {
                    _lottieController.duration = p0.duration;
                    _lottieController.repeat();
                  }),
                ),
              ), // 아래에서부터의 위치 조정
            ),
            Positioned(
              right: deviceWidth * 0.05, // 오른쪽에서부터의 위치 조정
              bottom: deviceHeight * 0.202, // 아래에서부터의 위치 조정
              child: MainSmallButton(
                label: '전화하기',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FamMember(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: deviceWidth * -0.09, // 오른쪽에서부터의 위치 조정
              bottom: deviceHeight * 0.125,
              width: deviceWidth * 0.5,
              height: deviceHeight * 0.3,
              child: IgnorePointer(
                  child: Lottie.asset(
                'assets/lottie/phone-call.json',
                controller: _lottieController,
                onLoaded: ((p0) {
                  _lottieController.duration = p0.duration;
                  _lottieController.repeat();
                }),
              )), // 아래에서부터의 위치 조정
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(16.0), // 원하는 만큼 패딩을 조절하세요.
                child: Text(
                  '© 2024 Bada. All rights reserved.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    decoration: TextDecoration.none,
                    fontFamily: 'Pretendard-Regular.otf',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
