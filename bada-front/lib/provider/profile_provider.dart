import 'package:bada/login/kakao_login.dart';
import 'package:bada/main_view_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider();

  String? _nickname;
  String? _profileImage;
  String? _email;
  bool _isLogined = false;

  String? get nickname => _nickname;
  String? get profileImage => _profileImage;
  String? get email => _email;
  bool get isLogined => _isLogined;

  Future<void> initProfile() async {
    try {
      final viewModel = MainViewModel(KakaoLogin());
      await viewModel.login();
      if (viewModel.isLogined) {
        _nickname = viewModel.user?.kakaoAccount?.profile?.nickname;
        _profileImage = viewModel.user?.kakaoAccount?.profile?.profileImageUrl;
        _email = viewModel.user?.kakaoAccount?.email;
        _isLogined = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }
}
