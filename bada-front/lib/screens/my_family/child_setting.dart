import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ChildeSetting extends StatelessWidget {
  const ChildeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이름 수정'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            CircleAvatar(
              radius: 100,
            ),
            SizedBox(
              height: 50,
            ),
            InputChip(label: Text('hi')),
            SizedBox(
              height: 170,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button300_115(label: Text('완료')),
                SizedBox(
                  width: 20,
                ),
                Button300_115(label: Text('삭제')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
