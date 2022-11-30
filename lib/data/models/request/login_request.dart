/// phone_number : "9823225046"
/// password : "123456"
/// fcm_token : "1233561awdsasafsaddsa"

class LoginRequest {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _password;
  String? _fcmToken;
  String? _appStatus = "new";

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;
  String? get fcmToken => _fcmToken;
  String? get appStatus => _appStatus;

  set fcmToken(String? value) {
    _fcmToken = value;
  }

  LoginRequest(
      {String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? password,
      String? fcmToken}) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _password = password;
    _fcmToken = fcmToken;
  }

  LoginRequest.fromJson(dynamic json) {
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _email = json["email"];
    _phoneNumber = json["phone_number"];
    _password = json["password"];
    _fcmToken = json["fcm_token"];
    _appStatus = json["app_status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["email"] = _email;
    map["phone_number"] = _phoneNumber;
    map["password"] = _password;
    map["fcm_token"] = _fcmToken;
    map["app_status"] = _appStatus;
    return map;
  }
}
