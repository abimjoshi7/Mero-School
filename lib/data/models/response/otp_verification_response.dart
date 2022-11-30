/// message : "OTP didn't match try again"

class OtpVerificationResponse {
  String? _message;

  String? get message => _message;

  OtpVerificationResponse({String? message}) {
    _message = message;
  }

  OtpVerificationResponse.fromJson(dynamic json) {
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = _message;
    return map;
  }
}
