/// receipt_data : "QQ67K6zmpXHwjVlyI8Pl7jyvKRRtuRofkOTQ9Bdx+jiF4AwpgQ0OLUH14/TvwqtVEX1PJ/SF2xvJnnevSIOss+hA6T+2Iz0FY/1Cfxt1OoVBGwrNkxtlj"
/// password : "bc8b1af6244246faa425ab1eacf54be9"
/// course_id : "12"

class InAppReceiptValidateRequest {
  String? _receiptData;
  String? _password;
  String? _courseId;
  String? _authToken;

  String? get authToken => _authToken;

  set authToken(String? value) {
    _authToken = value;
  }

  String? get receiptData => _receiptData;
  String? get password => _password;
  String? get courseId => _courseId;

  InAppReceiptValidateRequest(
      {String? receiptData,
      String? password,
      String? courseId,
      String? authToken}) {
    _receiptData = receiptData;
    _password = password;
    _courseId = courseId;
    _authToken = authToken;
  }

  InAppReceiptValidateRequest.fromJson(dynamic json) {
    _receiptData = json['receipt_data'];
    _password = json['password'];
    _courseId = json['course_id'];
    _authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['receipt_data'] = _receiptData;
    map['password'] = _password;
    map['course_id'] = _courseId;
    map['auth_token'] = _authToken;
    return map;
  }
}
