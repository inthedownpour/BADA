import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/main/setting/alarm_setting.dart';
import 'package:bada/screens/main/setting/setting_list.dart';
import 'package:bada/screens/main/setting/terms_of_policy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width:
                    double.infinity, // Make the Container fit the screen width
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData.name!),
                      const Text('010-1234-5678'),
                      Text(userData.email!),
                      const Text('가입일: 어제오늘'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              InkResponse(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationCode(),
                    ),
                  );
                },
                containedInkWell: true,
                child: const Text(
                  '인증코드 발급',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
              InkResponse(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlarmSetting(),
                    ),
                  );
                },
                containedInkWell: true,
                child: const Text(
                  '알림 설정',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
              InkResponse(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsOfPolicy(),
                    ),
                  );
                },
                containedInkWell: true,
                child: const Text(
                  '이용약관',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
              InkResponse(
                onTap: () {},
                containedInkWell: true,
                child: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
              InkResponse(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('회원탈퇴'),
                        content: const Text(
                          '회원탈퇴를 진행하시겠습니까?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('탈퇴하기'),
                          ),
                          // Delete button
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소'),
                          ),
                        ],
                      );
                    },
                  );
                },
                containedInkWell: true,
                child: const Text(
                  '회원탈퇴',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
