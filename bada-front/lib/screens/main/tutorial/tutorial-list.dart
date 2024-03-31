import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TutorialList extends StatelessWidget {
  final String intro = '''
바래다줄게는 2024년 2월 26일부터 2024년 4월 4일까지 개발된 어플리케이션으로, 
아이들과 학부모님께 안전한 등교길, 하원길을 제공합니다.
''';

  const TutorialList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '바래다줄게 설명서'),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              height: UIhelper.deviceHeight(context) * 0.3,
              width: UIhelper.deviceWidth(context) * 0.85,
              child: Text(intro),
            ),
            SizedBox(
              height: UIhelper.deviceHeight(context) * 0.01,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              height: UIhelper.deviceHeight(context) * 0.1,
              width: UIhelper.deviceWidth(context) * 0.85,
              child: GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('경로 추천 원리'),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: UIhelper.deviceHeight(context) * 0.01,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              height: UIhelper.deviceHeight(context) * 0.1,
              width: UIhelper.deviceWidth(context) * 0.85,
              child: GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('알림의 종류'),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: UIhelper.deviceHeight(context) * 0.01,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              height: UIhelper.deviceHeight(context) * 0.1,
              width: UIhelper.deviceWidth(context) * 0.85,
              child: GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('만든이'),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: UIhelper.deviceHeight(context) * 0.01,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              height: UIhelper.deviceHeight(context) * 0.1,
              width: UIhelper.deviceWidth(context) * 0.85,
              child: GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('B207 최종 결과물'),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
