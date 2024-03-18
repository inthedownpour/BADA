import 'package:bada/widgets/alarm.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlarmList extends StatelessWidget {
  const AlarmList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '알림',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '알림',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Alarm(
                iconType: 'assets/lottie/arrival.json',
                context: '도착함',
                time: '오전 9:00',
              ),
              Lottie.asset(
                'assets/lottie/arrival2.json',
                width: 50,
              ),
              Lottie.asset(
                'assets/lottie/arrival3.json',
                width: 50,
              ),
              Lottie.asset(
                'assets/lottie/connection-lost.json',
                width: 50,
              ),
              Lottie.asset(
                'assets/lottie/departure.json',
                width: 50,
              ),
              Lottie.asset(
                'assets/lottie/off-road.json',
                width: 50,
              ),
              Lottie.asset(
                'assets/lottie/off-road2.json',
                width: 50,
              ),
              Lottie.asset(
                'assets/lottie/quick-moving.json',
                width: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
