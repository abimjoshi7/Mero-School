/// message : "OTP Sent to 9823225046"
/// url : "http://mero.school/Api/reset/9823225046"

class ResetPasswodResponse {
  String? _message;
  String? _url;

  String? get message => _message;
  String? get url => _url;

  ResetPasswodResponse({String? message, String? url}) {
    _message = message;
    _url = url;
  }

  ResetPasswodResponse.fromJson(dynamic json) {
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
