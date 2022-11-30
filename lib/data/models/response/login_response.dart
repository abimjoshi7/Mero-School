/// status : true
/// message : "login success"
/// data : {"user_id":"160","first_name":"user","last_name":"demo","email":"user@gmail.com","role":"user","validity":1,"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTYwIiwiZmlyc3RfbmFtZSI6InVzZXIiLCJsYXN0X25hbWUiOiJkZW1vIiwiZW1haWwiOiJ1c2VyQGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwidmFsaWRpdHkiOjF9.IBx-3jnpvZusulSosJG_MQNKidybBqHgFMf9GdfNPqo"}

class ErrResponse {
  // int _status;
  String? _message;

  // int get status => _status;
  String? get message => _message;
  // String get data => _data;

  UserImageResponse(
      {
      // int status,
      String? message}) {
    // _status = status;
    _message = message;
  }

  ErrResponse.fromJson(dynamic json) {
    print("json: ${json.toString()}");

    // _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    // map["status"] = _status;
    map["message"] = _message;
    return map;
  }
}

class LoginResponse {
  // int _status;
  String? _message;
  Data? _data;

  // int get status => _status;
  String? get message => _message;
  Data? get data => _data;

  LoginResponse({int? status, String? message, Data? data}) {
    // _status = status;
    _message = message;
    _data = data;
  }

  LoginResponse.fromJson(dynamic json) {
    // _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    // map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

/// user_id : "160"
/// first_name : "user"
/// last_name : "demo"
/// email : "user@gmail.com"
/// role : "user"
/// validity : 1
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTYwIiwiZmlyc3RfbmFtZSI6InVzZXIiLCJsYXN0X25hbWUiOiJkZW1vIiwiZW1haWwiOiJ1c2VyQGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwidmFsaWRpdHkiOjF9.IBx-3jnpvZusulSosJG_MQNKidybBqHgFMf9GdfNPqo"

class Data {
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _role;
  int? _validity;
  String? _token;

  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get role => _role;
  int? get validity => _validity;
  String? get token => _token;

  Data(
      {String? userId,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? role,
      int? validity,
      String? token}) {
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _role = role;
    _validity = validity;
    _token = token;
  }

  Data.fromJson(dynamic json) {
    _userId = json["user_id"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _email = json["email"];
    _phoneNumber = json["phone_number"];
    _role = json["role"];
    _validity = json["validity"];
    _token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = _userId;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["email"] = _email;
    map["phone_number"] = _phoneNumber;
    map["role"] = _role;
    map["validity"] = _validity;
    map["token"] = _token;
    return map;
  }
}
