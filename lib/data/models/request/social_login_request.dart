import 'dart:io';

/// displayName : "Suraj kumar"
/// email : "suraz.syangden123@gmail.com"
/// familyName : "Tamang"
/// fcm_token : "eCSs7YOIQLe7DWA0kGFyg7:APA91bHNozZvWUZ1NMTXO6JvhSS6bLXW8xCSkDvJEmzGzHx47TPKZdqe47onrEGF4tW55l5wzHde7xVGse6oKw-jS-jpHw4sfDwJhM2nHxmDG_DriAgj4I9BGr2VUNN6fSHX_BFUZ1so"
/// id : "102413869311388631003"
/// provider : "google"

class SocialLoginRequest {
  String? _displayName;
  String? _email;
  String? _familyName;
  String? _phoneNumber;
  String? _fcmToken;
  String? _id;
  String? _provider;
  String? _page;
  String? _platform = Platform.isIOS ? "ios" : "app";

  String? get displayName => _displayName;
  String? get email => _email;
  String? get familyName => _familyName;
  String? get phoneNumber => _phoneNumber;
  String? get fcmToken => _fcmToken;
  String? get id => _id;
  String? get provider => _provider;
  String? get page => _page;

  SocialLoginRequest(
      {String? displayName,
      String? email,
      String? familyName,
      String? phoneNumber,
      String? fcmToken,
      String? id,
      String? provider,
      String? page}) {
    _displayName = displayName;
    _email = email;
    _familyName = familyName;
    _phoneNumber = phoneNumber;
    _fcmToken = fcmToken;
    _id = id;
    _provider = provider;
    _page = page;
  }

  SocialLoginRequest.fromJson(dynamic json) {
    _displayName = json["displayName"];
    _email = json["email"];
    _familyName = json["familyName"];
    _phoneNumber = json["phoneNumber"];
    _fcmToken = json["fcm_token"];
    _id = json["id"];
    _provider = json["provider"];
    _page = json["page"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["displayName"] = _displayName;
    map["email"] = _email;
    map["familyName"] = _familyName;
    map["phoneNumber"] = _phoneNumber;
    map["fcm_token"] = _fcmToken;
    map["id"] = _id;
    map["provider"] = _provider;
    map["page"] = _page;
    map["user_from"] = _platform;
    return map;
  }
}
