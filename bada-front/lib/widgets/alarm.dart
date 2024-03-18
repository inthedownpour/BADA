import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Alarm extends StatefulWidget {
  final String iconType, context, time;

  const Alarm({
    super.key,
    required this.iconType,
    required this.context,
    required this.time,
  });

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff696DFF), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      width: 400,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Lottie.asset(widget.iconType),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 200,
            child: Text(widget.context),
          ),
          SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
