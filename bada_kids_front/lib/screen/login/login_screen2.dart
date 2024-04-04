import 'dart:convert';

import 'package:bada_kids_front/model/appbar.dart';
import 'package:bada_kids_front/model/buttons.dart';
import 'package:bada_kids_front/screen/main/home_screen.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../firebase_options.dart';

class LoginScreen2 extends StatefulWidget {
  final String authCode;

  const LoginScreen2({super.key, required this.authCode});

  @override
  State<LoginScreen2> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen2> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? _phone;
  final String _profileUrl =
      'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/defaultprofile.png';

  Future<bool>? _load;

  bool _isValidPhone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load = _loadData();
    _phoneController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final text = _phoneController.text;
    bool shouldEnable = text.length >= 10 &&
        text.replaceAll(RegExp(r'[^0-9]'), '').length >= 10;
    if (_isValidPhone != shouldEnable) {
      setState(() {
        _isValidPhone = shouldEnable;
      });
    }
  }

  Future<bool> _loadData() async {
    await _requestToken();
    await _requestPhone();
    setState(() {
      _phoneController.text = _phone!;
    });
    return true;
  }

  Future<void> _requestToken() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token: $_token");
  }

  Future<void> _requestPhone() async {
    _phone = await SmsAutoFill().hint;
    if (_phone != null && _phone!.startsWith('+82')) {
      _phone = '0${_phone!.substring(3)}';
    } else {
      // `_phone`가 `null`이거나 '+82'로 시작하지 않는 경우의 처리를 추가하세요.
      _phone = '';
      debugPrint('전화번호를 가져올 수 없거나, 올바른 형식이 아닙니다.');
    }
  }

  void login() async {
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/auth/joinChild');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식의 데이터를 보낸다고 명시
      },
      body: jsonEncode({
        "name": _nameController.text,
        "phone": _phone ?? '000-0000-0000',
        "profileUrl": _profileUrl,
        "code": widget.authCode, // StatefulWidget에서 전달받은 authCode 사용
        "fcmToken": _token, // 실제 FCM 토큰 값으로 교체해야 합니다.
      }),
    );

    debugPrint(
        'name: ${_nameController.text},\n phone: $_phone,\n profileUrl: $_profileUrl,\n code: ${widget.authCode},\n fcmToken: $_token');

    if (response.statusCode == 200) {
      // JSON 형식의 응답 본문을 디코드합니다.
      var responseBody = jsonDecode(response.body);

      // familyCode와 accessToken을 저장합니다.
      await _storage.write(
          key: 'familyCode', value: responseBody['familyCode']);
      await _storage.write(
          key: 'accessToken', value: responseBody['accessToken']);

      await _storage.read(key: 'familyCode').then((value) {
        debugPrint('familyCode: $value');
      });
      await _storage.read(key: 'accessToken').then((value) {
        debugPrint('accessToken: $value');
      });

      // 요청이 성공적으로 처리된 경우
      debugPrint("성공: ${response.body}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // 요청 처리 실패
      debugPrint("실패: ${response.body}");
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_updateButtonState);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);

    return FutureBuilder(
      future: _load,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: '정보 입력',
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(deviceWidth * 0.07,
                deviceHeight * 0.05, deviceWidth * 0.07, deviceHeight * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('이름',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: deviceHeight * 0.01), // 여백 추가 (높이 1%)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff696DFF).withOpacity(0.2),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '이름을 입력해주세요',
                    hintStyle: TextStyle(
                      color: const Color(0xff696DFF).withOpacity(0.5),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.04,
                        deviceHeight * 0.02,
                        deviceWidth * 0.04,
                        deviceHeight * 0.02),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                const Text('휴대전화 번호',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: deviceHeight * 0.01), // 여백 추가 (높이 1%)
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff696DFF).withOpacity(0.2),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '휴대전화 번호를 입력해주세요',
                    hintStyle: TextStyle(
                      color: const Color(0xff696DFF).withOpacity(0.5),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.04,
                        deviceHeight * 0.02,
                        deviceWidth * 0.04,
                        deviceHeight * 0.02),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.38),
                _isValidPhone
                    ? Button714_150(
                        label: const Text(
                          '다음으로',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_phoneController.text.isNotEmpty) {
                            login();
                          }
                        },
                      )
                    : const Button714_150(
                        label: Text('핸드폰 번호를 입력해주세요'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
