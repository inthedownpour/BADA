import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPlace extends StatelessWidget {
  const MyPlace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 장소'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '편집',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}