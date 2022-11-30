/// message : "OTP Sent to 9818126609"
/// url : "http://mero.school/Api/otpverification/9818126609"

class RegistrationResponse {
  String? _message;
  String? _url;

  String? get message => _message;
  String? get url => _url;

  RegistrationResponse({String? message, String? url}) {
    _message = message;
    _url = url;
  }

  RegistrationResponse.fromJson(dynamic json) {
    _message = json["message"];
    _url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["message"] = _message;
    map["url"] = _url;
    return map;
  }
}
