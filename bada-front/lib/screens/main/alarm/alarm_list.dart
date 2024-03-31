import 'dart:convert';

import 'package:bada/widgets/alarm.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AlarmList extends StatefulWidget {
  final String name;
  final int memberId;

  const AlarmList({
    super.key,
    required this.name,
    required this.memberId,
  });

  @override
  State<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final Future<List<dynamic>> _alarmList;

  Future<List<dynamic>> fetchAlarmList(String childId) async {
    String? accessToken = await _storage.read(key: 'accessToken');

    if (accessToken == null) {
      throw Exception('Access Token is not available');
    }

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/alarmLog/list/$childId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'https://j10b207.p.ssafy.io/api/alarmLog/list/$childId ${response.statusCode}',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _alarmList = fetchAlarmList(widget.memberId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '${widget.name}님의 알림',
      ), // Assuming widget.name contains the name to be displayed
      body: FutureBuilder<List<dynamic>>(
        future: _alarmList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If we ran into an error, display it
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // When we have data, we'll display it with ListView.builder
            return ListView.builder(
              itemCount:
                  snapshot.data!.length, // The count of items in the data list
              itemBuilder: (context, index) {
                var alarm = snapshot.data![index]; // Get the current alarm item
                // Adjust the following lines to match the structure of your alarm data
                String title = alarm['title'] ?? 'No Title'; // Example field
                String description =
                    alarm['description'] ?? 'No Description'; // Example field

                return ListTile(
                  title: Text(title), // Display the title
                  subtitle: Text(description), // Display the description
                  // You can add more widgets here to display other pieces of data
                );
              },
            );
          } else {
            // This will handle the case where there's no data
            return const Center(child: Text('No alarms found.'));
          }
        },
      ),
    );
  }
}
      
      // Container(
      //   padding: const EdgeInsets.all(20),
      //   child: Center(
      //     child: Column(
      //       children: [
      //         Row(
      //           children: [
      //             SizedBox(
      //               width: UIhelper.scaleWidth(context) * 10,
      //             ),
      //             const Text(
      //               '알림',
      //               style: TextStyle(fontSize: 18),
      //             ),
      //           ],
      //         ),
      //         const Alarm(
      //           iconType: 2,
      //           context: '도착함',
      //           time: '오전 9:00',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

