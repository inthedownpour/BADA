import 'package:bada/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:bada/screens/login/login_screen.dart';
import 'package:bada/screens/loading_screen.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_API'] ?? '');
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '9d4c295f031b5c1f50269e353e895e12',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        // 다른 프로바이더들...
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          // Check if the future is completed
          if (snapshot.connectionState == ConnectionState.done) {
            // Return the main screen if initialization is complete
            return const LoginScreen(); // Your main screen widget
          } else {
            // Return the loading screen while waiting
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
