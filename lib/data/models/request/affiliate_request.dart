import 'dart:io';

class AffiliateRequest {
  // String? id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _youtubeChannel;
  String? _website;
  String? _promoteReason;
  String? _password;
  String? _confirmPassword;
  String _userFrom = Platform.isIOS ? "ios" : "app";
  String? _authToken;
  // String? _provider;

  // String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get youtubeChannel => _youtubeChannel;
  String? get website => _website;
  String? get promoteReason => _promoteReason;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  String? get userFrom => _userFrom;
  String? get authToken => _authToken;
  // String? get provider => _provider;

  AffiliateRequest({
    // String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? youtubeChannel,
    String? website,
    String? promoteReason,
    String? password,
    String? confirmPassword,
    String? userFrom,
    String? authToken,
    // String? provider,
  }) {
    // _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _youtubeChannel = youtubeChannel;
    _website = website;
    _promoteReason = promoteReason;
    _password = password;
    _confirmPassword = confirmPassword;
    _userFrom = "app";
    _authToken = authToken;
    // _provider = provider;
  }

  AffiliateRequest.fromJson(dynamic json) {
    // _id = json["auth_token"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _email = json["email"];
    _phoneNumber = json["phone_number"];
    _youtubeChannel = json["youtube_channel"];
    _website = json["website"];
    _promoteReason = json["reason_promote"];
    _password = json["password"];
    _confirmPassword = json["confirm_password"];
    _userFrom = json["user_from"];
    _authToken = json["auth_token"];
    // _provider = json["provider"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["email"] = _email;
    map["phone_number"] = _phoneNumber;
    map["youtube_channel"] = _youtubeChannel;
    map["website"] = _website;
    map["password"] = _password;
    map["confirm_password"] = _confirmPassword;
    map["user_from"] = _userFrom;
    map["auth_token"] = _authToken;
    // map["provider"] = _provider;
    return map;
  }
}
