import 'dart:ui';

import 'package:bada/models/alarm_model.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class Alarm extends StatefulWidget {
  final String context, time;
  final int iconType;
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
  String getIconPath(int iconType) {
    switch (iconType) {
      case 1:
        return 'assets/lottie/departure.json';

      case 2:
        return 'assets/lottie/arrival3.json';

      default:
        return 'assets/lottie/arrival2.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff696DFF), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      width: UIhelper.scaleWidth(context) * 400,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: UIhelper.scaleWidth(context) * 50,
            height: UIhelper.scaleHeight(context) * 50,
            child: Lottie.asset(getIconPath(widget.iconType)),
          ),
          SizedBox(width: UIhelper.scaleWidth(context) * 30),
          SizedBox(
            width: UIhelper.scaleWidth(context) * 200,
            child: Text(widget.context),
          ),
          SizedBox(
            height: UIhelper.scaleHeight(context) * 50,
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

class ForeGroundAlarm extends StatelessWidget {
  final FcmMessage fcmMessage;
  // final String childId, message, type;
  // name,
  // phone,
  // profileUrl,
  // destination,
  // icon;
  // final Map<String, dynamic> data;
  final VoidCallback onConfirm, onClose;

  const ForeGroundAlarm({
    super.key,
    // required this.childId,
    // required this.message,
    // required this.type,
    // required this.data,
    // required this.name,
    // required this.phone,
    // required this.profileUrl,
    // required this.destination,
    // required this.icon,
    required this.fcmMessage,
    required this.onConfirm,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final title = fcmMessage.notification.title;
    final body = fcmMessage.notification.body;
    final childName = fcmMessage.data.childName;
    final profileUrl = fcmMessage.data.profileUrl;
    final phone = fcmMessage.data.phone;
    final destinationName = fcmMessage.data.destinationName;
    final destinationIcon = fcmMessage.data.destinationIcon;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (profileUrl != '')
              CircleAvatar(
                radius: 40,
                child: Image.network(
                  profileUrl,
                  width: 40,
                ),
              )
            else
              const Text('Placeholder Text'),
            SizedBox(width: UIhelper.deviceWidth(context) * 0.015),
            Expanded(
              // This makes the Column fill the available horizontal space
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  // Removed Expanded here to prevent unbounded height issue
                  Row(
                    children: [
                      SizedBox(
                        width: UIhelper.scaleWidth(context) * 280,
                        child: Text(
                          '"$childName"님께서 $destinationName으로 출발하였습니다!',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: onConfirm,
                        child: const Text('확인하기'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed: onClose,
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
