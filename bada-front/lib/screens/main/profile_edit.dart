import 'package:bada/api_request/member_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileEdit extends StatefulWidget {
  var nickname;
  var profileUrl;

  ProfileEdit({
    super.key,
    memberId,
    required this.nickname,
    required this.profileUrl,
  });

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _storage = const FlutterSecureStorage();
  final membersApi = MembersApi();
  TextEditingController nicknameController = TextEditingController();
  Future<void>? load;
  String? profileUrl;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    load = _loadProfile();
  }

  Future<void> _loadProfile() async {
    String? storageNickname = await _storage.read(key: 'nickname');
    profileUrl = await _storage.read(key: 'profileImage');
    accessToken = await _storage.read(key: 'accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load,
      builder: (context, snapshot) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '프로필 수정',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '프로필 사진',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        profileUrl = pickedFile.path;
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              profileUrl == '' || profileUrl == null
                                  ? const AssetImage(
                                      'assets/img/default_profile.png',
                                    ) as ImageProvider<Object>?
                                  : NetworkImage(profileUrl!),
                        ),
                        Container(
                          width: 100, // CircleAvatar와 동일한 크기로 설정
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        const Text(
                          "수정",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '닉네임',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '닉네임을 입력해주세요',
                  ),
                  controller: nicknameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await membersApi.updateProfile(
                      accessToken!,
                      profileUrl!,
                      nicknameController.text,
                    );
                  },
                  child: const Text('저장'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
