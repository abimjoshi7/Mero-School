class AffiliateResponse {
  // String? _status;
  String? _message;

  // String? get status => _status;
  String? get message => _message;

  AffiliateResponse({String? status, String? message}) {
    // _status = status;
    _message = message;
  }

  AffiliateResponse.fromJson(dynamic json) {
    // _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    // map["status"] = _status;
    // map["status"] = _status;
    map["message"] = _message;

    return map;
  }
}

// class Data {
//   String? _id;
//   String? _firstName;
//   String? _lastName;
//   String? _email;
//   String? _phoneNumber;
//   String? _youtubeChannel;
//   String? _website;
//   String? _promoteReason;
//   String? _password;
//   String? _confirmPassword;
//   String? _userFrom;
//   String? _authToken;
//
//   String? get id => _id;
//   String? get firstName => _firstName;
//   String? get lastName => _lastName;
//   String? get email => _email;
//   String? get phoneNumber => _phoneNumber;
//   String? get youtubeChannel => _youtubeChannel;
//   String? get website => _website;
//   String? get promoteReason => _promoteReason;
//   String? get password => _password;
//   String? get confirmPassword => _confirmPassword;
//   String? get userFrom => Platform.isIOS ? "ios" : "app";
//   String? get authToken => _authToken;
//
//   Data.fromJson(dynamic json) {
//     _id = json["auth_token"];
//     _firstName = json["first_name"];
//     _lastName = json["last_name"];
//     _email = json["email"];
//     _phoneNumber = json["phone_number"];
//     _youtubeChannel = json["youtube_channel"];
//     _website = json["website"];
//     _promoteReason = json["reason_promote"];
//     _password = json["password"];
//     _confirmPassword = json["confirm_password"];
//     _userFrom = json["user_from"];
//     _authToken = json["auth_token"];
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map["first_name"] = _firstName;
//     map["last_name"] = _lastName;
//     map["email"] = _email;
//     map["phone_number"] = _phoneNumber;
//     map["youtube_channel"] = _youtubeChannel;
//     map["website"] = _website;
//     map["reason_promote"] = _promoteReason;
//     map["password"] = _password;
//     map["confirm_password"] = _confirmPassword;
//     map["user_from"] = _userFrom;
//     map["auth_token"] = _authToken;
//     return map;
//   }
// }
