/// confirm_password : "123456"
/// otp_num : "1234"
/// password : "123456"

class ResetRequest {
  String? _confirmPassword;
  String? _otpNum;
  String? _password;

  String? get confirmPassword => _confirmPassword;
  String? get otpNum => _otpNum;
  String? get password => _password;

  ResetRequest({String? confirmPassword, String? otpNum, String? password}) {
    _confirmPassword = confirmPassword;
    _otpNum = otpNum;
    _password = password;
  }

  ResetRequest.fromJson(dynamic json) {
    _confirmPassword = json["confirm_password"];
    _otpNum = json["otp_num"];
    _password = json["password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["confirm_password"] = _confirmPassword;
    map["otp_num"] = _otpNum;
    map["password"] = _password;
    return map;
  }
}
