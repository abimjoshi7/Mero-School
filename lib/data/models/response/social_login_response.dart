/// status : true
/// message : "login success"
/// data : {"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiOTEiLCJmaXJzdF9uYW1lIjoiU3VyYWogS3VtYXIiLCJsYXN0X25hbWUiOiJUYW1hbmciLCJlbWFpbCI6InN1cmF6LnN5YW5nZGVuMTIzQGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwidmFsaWRpdHkiOjF9.00KONrYZYk_PNnZ654g857Mzuca3q_Al-sa-KU6qN14"}

class SocialLoginResponse {
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  SocialLoginResponse({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SocialLoginResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];

    if (json["data"] != null && json["data"].toString().isNotEmpty) {
      _data = Data.fromJson(json["data"]);
    } else {
      _data = Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null && _data.toString().isNotEmpty) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiOTEiLCJmaXJzdF9uYW1lIjoiU3VyYWogS3VtYXIiLCJsYXN0X25hbWUiOiJUYW1hbmciLCJlbWFpbCI6InN1cmF6LnN5YW5nZGVuMTIzQGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwidmFsaWRpdHkiOjF9.00KONrYZYk_PNnZ654g857Mzuca3q_Al-sa-KU6qN14"

class Data {
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _role;
  int? _validity;
  String? _redis;
  String? _appStatus;
  String? _token;
  bool? _isFirstLogin;

  bool? get isFirstLogin => _isFirstLogin;

  set isFirstLogin(bool? value) {
    _isFirstLogin = value;
  }

  String? get userId => _userId;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  String? get phoneNumber => _phoneNumber;

  String? get role => _role;

  int? get validity => _validity;

  String? get redis => _redis;

  String? get appStatus => _appStatus;

  String? get token => _token;

  Data(
      {String? userId,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? role,
      int? validity,
      String? redis,
      String? appStatus,
      String? token,
      bool? isFirstLogin}) {
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _role = role;
    _validity = validity;
    _redis = redis;
    _appStatus = appStatus;
    _token = token;
    _isFirstLogin = isFirstLogin;
  }

  Data.fromJson(dynamic json) {
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _role = json['role'];
    _validity = json['validity'];
    _redis = json['redis'];
    _appStatus = json['app_status'];
    _token = json['token'];
    _isFirstLogin = json['is_first_login'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['phone_number'] = _phoneNumber;
    map['role'] = _role;
    map['validity'] = _validity;
    map['redis'] = _redis;
    map['app_status'] = _appStatus;
    map['token'] = _token;
    map['is_first_login'] = _isFirstLogin;
    return map;
  }
}
