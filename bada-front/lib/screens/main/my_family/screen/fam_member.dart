import 'package:bada/screens/main/my_family/screen/alarm_list.dart';
import 'package:bada/screens/main/my_family/screen/child_setting.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

class FamilyMember extends StatefulWidget {
  final String name;
  final String? profileUrl;
  final int isParent;
  final int? movingState;
  const FamilyMember({
    super.key,
    required this.name,
    required this.isParent,
    this.profileUrl,
    this.movingState,
  });

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  String myName = '';

  @override
  void initState() {
    super.initState();
    loadMyName();
    _lottieController = AnimationController(vsync: this);
  }

  void loadMyName() async {
    const storage = FlutterSecureStorage();
    String? name = await storage.read(key: 'nickname');
    if (name != null) {
      setState(() {
        myName = name;
      });
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 5, 20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff696DFF), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: 100 * UIhelper.scaleWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 35,
                  backgroundImage: widget.profileUrl != null
                      ? NetworkImage(widget.profileUrl!)
                      : null,
                  child: widget.profileUrl == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ) // Example: default icon
                      : null,
                ),
                SizedBox(
                  height: 10 * UIhelper.scaleHeight(context),
                ),
                if (widget.name == myName)
                  const Text(
                    '나!',
                    style: TextStyle(fontSize: 20),
                  )
                else
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          Lottie.asset(
            'assets/lottie/walking.json',
            width: 100 * UIhelper.scaleWidth(context),
            height: 100 * UIhelper.scaleHeight(context),
            controller: _lottieController,
            onLoaded: (p0) {
              _lottieController.duration = p0.duration;
              _lottieController.forward();
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlarmList(name: widget.name),
                        ),
                      );
                    },
                    child: Lottie.asset(
                      'assets/lottie/notification.json',
                      width: UIhelper.scaleWidth(context) * 40,
                      height: UIhelper.scaleHeight(context) * 40,
                      controller: _lottieController,
                      onLoaded: ((p0) {
                        _lottieController.duration = p0.duration;
                        _lottieController.forward();
                      }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChildeSetting(name: widget.name),
                        ),
                      );
                    },
                    child: Lottie.asset(
                      'assets/lottie/kid-setting.json',
                      width: UIhelper.scaleWidth(context) * 40,
                      height: UIhelper.scaleHeight(context) * 40,
                      controller: _lottieController,
                      onLoaded: ((p0) {
                        _lottieController.duration = p0.duration;
                        _lottieController.stop();
                      }),
                    ),
                  ),
                ],
              ),
              // const Button281_77(label: Text('정지 중')),
            ],
          ),
          if (widget.isParent == 0) ...[],
        ],
      ),
    );
  }
}
