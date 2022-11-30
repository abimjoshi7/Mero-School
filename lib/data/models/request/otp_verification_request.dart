/// otp_num : "333361"

class OtpVerificationRequest {
  String? _otpNum;
  String? _phone_num;

  String? get phone_num => _phone_num;

  set phone_num(String? value) {
    _phone_num = value;
  }

  String? get otpNum => _otpNum;

  OtpVerificationRequest({String? otpNum, String? phoneNUm}) {
    _otpNum = otpNum;
    _phone_num = phoneNUm;
  }

  OtpVerificationRequest.fromJson(dynamic json) {
    _otpNum = json["otp_num"];
    _phone_num = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["otp_num"] = _otpNum;
    map["phone_number"] = _phone_num;
    return map;
  }
}
