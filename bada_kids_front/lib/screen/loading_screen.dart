import 'package:bada_kids_front/model/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer를 해제합니다.
    _lottieController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 다시 활성화될 때 애니메이션을 재시작합니다.
    if (state == AppLifecycleState.resumed) {
      _lottieController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    // Provider.of<ScreenSizeModel>(context, listen: false).screenWidth =
    //     screenSize.width;
    // Provider.of<ScreenSizeModel>(context, listen: false).screenHeight =
    //     screenSize.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF9E88FF).withOpacity(0.18),
              const Color(0xFF83A3FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.15,
              ),
              const Text(
                '바래다줄게',
                style: TextStyle(
                  color: Color(0xff7B79FF),
                  fontSize: 34,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.125,
              ),
              Stack(
                children: [
                  Lottie.asset(
                    'assets/lottie/walking-cloud.json',
                    width: deviceWidth * 0.7,
                    controller: _lottieController,
                    onLoaded: ((p0) {
                      _lottieController.duration = p0.duration;
                      _lottieController.repeat();
                    }),
                  ),
                  Lottie.asset(
                    'assets/lottie/walking-pencil.json',
                    width: deviceWidth * 0.7,
                    controller: _lottieController,
                    onLoaded: ((p0) {
                      _lottieController.duration = p0.duration;
                      _lottieController.repeat();
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
