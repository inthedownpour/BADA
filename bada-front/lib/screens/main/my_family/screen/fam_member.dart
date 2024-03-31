import 'package:bada/screens/main/alarm/alarm_list.dart';
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
    return Column(
      children: [
        Container(
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
                    SizedBox(
                      height: 10 * UIhelper.scaleHeight(context),
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
                      child: CircleAvatar(
                        backgroundColor: Colors.purple,
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
                    ),
                  ],
                ),
              ),
              if (widget.isParent == 0)
                Column(
                  children: [
                    if (widget.movingState == 0)
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('정지'),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Lottie.asset(
                          'assets/lottie/walking.json',
                          width: 80 * UIhelper.scaleWidth(context),
                          height: 80 * UIhelper.scaleHeight(context),
                          controller: _lottieController,
                          onLoaded: (p0) {
                            _lottieController.duration = p0.duration;
                            if (widget.movingState == 0 ||
                                widget.movingState == null) {
                              _lottieController.stop();
                            } else {
                              _lottieController.repeat();
                            }
                          },
                        ),
                        Lottie.asset(
                          'assets/lottie/forward-arrow.json',
                          width: 60 * UIhelper.scaleWidth(context),
                          height: 30 * UIhelper.scaleHeight(context),
                          controller: _lottieController,
                          onLoaded: (p0) {
                            _lottieController.duration = p0.duration;
                            _lottieController.forward();
                          },
                        ),
                        if (widget.movingState == 0)
                          Lottie.asset(
                            'assets/lottie/cross.json',
                            width: 80 * UIhelper.scaleWidth(context),
                            height: 80 * UIhelper.scaleHeight(context),
                            controller: _lottieController,
                            onLoaded: (p0) {
                              _lottieController.duration = p0.duration;
                              _lottieController.stop();
                            },
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          height: UIhelper.deviceHeight(context) * 0.01,
        ),
      ],
    );
  }
}

class FamilyMember2 extends StatefulWidget {
  final String name;
  final String? profileUrl;
  final int isParent, memberId;
  final int? movingState;
  const FamilyMember2({
    super.key,
    required this.name,
    required this.isParent,
    this.profileUrl,
    this.movingState,
    required this.memberId,
  });

  @override
  State<FamilyMember2> createState() => _FamilyMember2State();
}

class _FamilyMember2State extends State<FamilyMember2>
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
    return Row(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlarmList(
                      name: widget.name,
                      memberId: widget.memberId,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
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
                      ) // Default icon for null profileUrl
                    : null,
              ),
            ),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        SizedBox(width: 20 * UIhelper.scaleWidth(context)),
      ],
    );
  }
}
