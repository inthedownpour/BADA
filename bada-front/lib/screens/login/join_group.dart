import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';

class JoinFamily extends StatelessWidget {
  final String title, buttonName;

  const JoinFamily({
    super.key,
    this.title = '그룹 참가하기',
    this.buttonName = '참가하기',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: UIhelper.scaleHeight(context) * 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '인증 코드 입력',
                    style: TextStyle(
                      fontSize: 19,
                      color: Color(0xff696DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 20),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff696DFF).withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide(
                      color: const Color(0xff696DFF).withOpacity(0.4),
                    ),
                  ),
                  labelText: '작성해주세요',
                ),
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 400),
              const Button714_150(label: Text('참가하기')),
            ],
          ),
        ),
      ),
    );
  }
}
