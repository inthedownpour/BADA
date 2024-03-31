import 'package:bada/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class AlarmSetting extends StatelessWidget {
  const AlarmSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '알림 설정'),
      body: Column(
        children: <Widget>[
          Text('displaySize : ${MediaQuery.of(context).size}'),
          Text('displayHeight : ${MediaQuery.of(context).size.height}'),
          Text('displayWidth : ${MediaQuery.of(context).size.width}'),
          Text(
            'devicePixelRatio : ${MediaQuery.of(context).devicePixelRatio}',
          ),
          Text('statusBarHeight : ${MediaQuery.of(context).padding.top}'),
          Text('window.physicalSize : ${window.physicalSize}'),
        ],
      ),
    );
  }
}
