import 'dart:io';

/// confirm_password : "123467"
/// fcm_token : "c_zVkh4xS7SJNsu1NmCQXd:APA91bGvdYf_itkq0nLkqtkOXxd-PBwLDpQvlVMLdtyyn6rZqjfrYw0QhLhNOR0PTj3WPUgX-MpLVwIxL3SdHDpzvoQeSI8evItASdTyv9zEwfsF1zUqxfQdu8AJ4eiezWNxZd4ETagz"
/// password : "123467"
/// phone_number : "9818126609"

class RegistrationRequest {
  String? _confirmPassword;
  String? _fcmToken;
  String? _password;
  String? _phoneNumber;

  String? get confirmPassword => _confirmPassword;
  String? get fcmToken => _fcmToken;
  String? get password => _password;
  String? get phoneNumber => _phoneNumber;

  String? _platform  = Platform.isIOS?"ios":"app";

  RegistrationRequest(
      {String? confirmPassword,
      String? fcmToken,
      String? password,
      String? phoneNumber}) {
    _confirmPassword = confirmPassword;
    _fcmToken = fcmToken;
    _password = password;
    _phoneNumber = phoneNumber;
  }

  RegistrationRequest.fromJson(dynamic json) {
    _confirmPassword = json["confirm_password"];
    _fcmToken = json["fcm_token"];
    _password = json["password"];
    _phoneNumber = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["confirm_password"] = _confirmPassword;
    map["fcm_token"] = _fcmToken;
    map["password"] = _password;
    map["phone_number"] = _phoneNumber;
    map["user_from"] = _platform;
    return map;
  }
}
