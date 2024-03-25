import 'package:bada_kids_front/screen/home_screen.dart';
import 'package:bada_kids_front/screen/loading_screen.dart';
import 'package:bada_kids_front/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    String? accessToken = await _storage.read(key: 'accessToken');

    // Set up headers for the GET request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // Perform the GET request to fetch the profile data
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: headers,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: FutureBuilder<bool>(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
