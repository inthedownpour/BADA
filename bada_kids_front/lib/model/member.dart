class Member {
  int? _memberId;
  String? _name;
  String? _phone;
  int? _isParent;
  String? _profileUrl;
  String? _familyCode;
  String? _movingState;
  String? _fcmToken;

  Member(
      {int? memberId,
      String? name,
      String? phone,
      int? isParent,
      String? profileUrl,
      String? familyCode,
      String? movingState,
      String? fcmToken}) {
    _memberId = memberId;
    _name = name;
    _phone = phone;
    _isParent = isParent;
    _profileUrl = profileUrl;
    _familyCode = familyCode;
    _movingState = movingState;
    _fcmToken = fcmToken;
  }

  String get fcmToken => _fcmToken!;
  String get movingState => _movingState!;
  String get familyCode => _familyCode!;
  String get profileUrl => _profileUrl!;
  int get isParent => _isParent!;
  String get phone => _phone!;
  String get name => _name!;
  int get memberId => _memberId!;

  // JSON에서 Member 객체로 변환하기 위한 팩토리 생성자
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      name: json['name'],
      phone: json['phone'],
      isParent: json['isParent'],
      profileUrl: json['profileUrl'],
      familyCode: json['familyCode'],
      movingState: json['movingState'],
      fcmToken: json['fcmToken'],
    );
  }
}
