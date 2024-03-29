import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
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
  final String childId, title, message, type, imageUrl;
  final VoidCallback onConfirm, onClose;
  const ForeGroundAlarm({
    super.key,
    required this.childId,
    required this.title,
    required this.message,
    required this.type,
    required this.onConfirm,
    required this.onClose,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(
                  child: Image.asset(
                    imageUrl,
                    width: 40,
                  ), // Using a network image
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(message),
                    ],
                  ),
                ),
              ],
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
    );
  }
}
