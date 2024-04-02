import 'dart:convert';

class FcmMessage {
  final String token;
  final NotificationData notification;
  final Data data;

  FcmMessage({
    required this.token,
    required this.notification,
    required this.data,
  });

  factory FcmMessage.fromJson(Map<String, dynamic> json) {
    return FcmMessage(
      token: json['token'],
      notification: NotificationData.fromJson(json['notification']),
      data: Data.fromJson(json['data']),
    );
  }
}

class NotificationData {
  final String title;
  final String body;

  NotificationData({
    required this.title,
    required this.body,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      body: json['body'],
    );
  }
}

class Data {
  final String childName;
  final String phone;
  final String profileUrl;
  final String destinationName;
  final String destinationIcon;

  Data({
    required this.childName,
    this.phone = '',
    this.profileUrl = '',
    required this.destinationName,
    required this.destinationIcon,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      childName: json['childName'],
      phone: json['phone'],
      profileUrl: json['profileUrl'],
      destinationName: json['destinationName'],
      destinationIcon: json['destinationIcon'],
    );
  }
}

// Example of how to parse the JSON message
void handleIncomingFcmMessage(String jsonString) {
  final parsedJson = json.decode(jsonString);
  final fcmMessage = FcmMessage.fromJson(parsedJson['message']);

  // Now you can access your data easily
  print(fcmMessage.data.childName);
  // Add your handling logic here
}
