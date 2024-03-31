import 'package:bada/widgets/alarm.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    String? token = await _storage.read(key: 'accessToken');
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
      appBar: CustomAppBar(title: '${widget.name}님의 알림'),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: UIhelper.scaleWidth(context) * 10,
                  ),
                  const Text(
                    '알림',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Alarm(
                iconType: 2,
                context: '도착함',
                time: '오전 9:00',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
