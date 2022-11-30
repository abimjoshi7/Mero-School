
/// status : true
/// message : "Payment proceed"
/// data : {"payment_proceed":"http://sandbox.thesmartgateway.com:8080/pay?payload=eyJyaWQiOiJNenBzWTFGT2NXMW1ibGxPUTJSS1pIUlVabGxQUWpveGJGQktNM1U2UTBaWlRreGxVVmhIU0ZocU0yZG5NSEJZWDJGMGRqbDBTRmt3IiwiYWdlbnRzIjpbMSwyLDMsNCw1LDddLCJpZGVudGlmaWVyIjoiYjFkMjY3MzcwYjMxMWViYjU5YjZlOTVmZDA0ZGRhODRmN2Y0YjE4OCIsInJlc3BvbnNlX3VybCI6Imh0dHA6XC9cL2RlbW8ubWVyby5zY2hvb2xcL2hvbWVcL3NtYXJ0X2NoZWNrb3V0X3N0YXR1cz9wYXlsb2FkPWV5SjBlWEFpT2lKS1YxUWlMQ0poYkdjaU9pSklVekkxTmlKOS5leUp6ZEdGMGRYTWlPaUpHUVVsTVJVUWlMQ0owY21GdWMyRmpkR2x2Ymw5cFpDSTZJbUl4WkRJMk56TTNNR0l6TVRGbFltSTFPV0kyWlRrMVptUXdOR1JrWVRnMFpqZG1OR0l4T0RnaUxDSnlaV1pmYVdRaU9tNTFiR3dzSW1GblpXNTBJanB1ZFd4c2ZRLml2OGJrNWhTc0ZJY3FsNWpnOTQ4X3ZxRzZMSHhpbXR2VFhrWnVtWUR1X28iLCJ0bnhpZCI6ImIxZDI2NzM3MGIzMTFlYmI1OWI2ZTk1ZmQwNGRkYTg0ZjdmNGIxODgiLCJvcmRlcl9yZW1hcmtzIjoiQWNjb3VudCAxMCIsImFtb3VudCI6OTk5MDAuMCwibG9nbyI6Imh0dHA6XC9cL2FwaXNhbmRib3gudGhlc21hcnRnYXRld2F5LmNvbTo4MDgwXC9tZWRpYVwvcHVibGljXC9NZXJjaGFudF9Mb2dvXC9iaHVrdGFuaUVuZ2xpc2hfaS5wbmciLCJleHRyYSI6e319","transaction_id":"b1d267370b311ebb59b6e95fd04dda84f7f4b188"}

class SmartCoursePaymentResponse {
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  SmartCoursePaymentResponse({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SmartCoursePaymentResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

/// payment_proceed : "http://sandbox.thesmartgateway.com:8080/pay?payload=eyJyaWQiOiJNenBzWTFGT2NXMW1ibGxPUTJSS1pIUlVabGxQUWpveGJGQktNM1U2UTBaWlRreGxVVmhIU0ZocU0yZG5NSEJZWDJGMGRqbDBTRmt3IiwiYWdlbnRzIjpbMSwyLDMsNCw1LDddLCJpZGVudGlmaWVyIjoiYjFkMjY3MzcwYjMxMWViYjU5YjZlOTVmZDA0ZGRhODRmN2Y0YjE4OCIsInJlc3BvbnNlX3VybCI6Imh0dHA6XC9cL2RlbW8ubWVyby5zY2hvb2xcL2hvbWVcL3NtYXJ0X2NoZWNrb3V0X3N0YXR1cz9wYXlsb2FkPWV5SjBlWEFpT2lKS1YxUWlMQ0poYkdjaU9pSklVekkxTmlKOS5leUp6ZEdGMGRYTWlPaUpHUVVsTVJVUWlMQ0owY21GdWMyRmpkR2x2Ymw5cFpDSTZJbUl4WkRJMk56TTNNR0l6TVRGbFltSTFPV0kyWlRrMVptUXdOR1JrWVRnMFpqZG1OR0l4T0RnaUxDSnlaV1pmYVdRaU9tNTFiR3dzSW1GblpXNTBJanB1ZFd4c2ZRLml2OGJrNWhTc0ZJY3FsNWpnOTQ4X3ZxRzZMSHhpbXR2VFhrWnVtWUR1X28iLCJ0bnhpZCI6ImIxZDI2NzM3MGIzMTFlYmI1OWI2ZTk1ZmQwNGRkYTg0ZjdmNGIxODgiLCJvcmRlcl9yZW1hcmtzIjoiQWNjb3VudCAxMCIsImFtb3VudCI6OTk5MDAuMCwibG9nbyI6Imh0dHA6XC9cL2FwaXNhbmRib3gudGhlc21hcnRnYXRld2F5LmNvbTo4MDgwXC9tZWRpYVwvcHVibGljXC9NZXJjaGFudF9Mb2dvXC9iaHVrdGFuaUVuZ2xpc2hfaS5wbmciLCJleHRyYSI6e319"
/// transaction_id : "b1d267370b311ebb59b6e95fd04dda84f7f4b188"

class Data {
  String? _paymentProceed;
  String? _transactionId;
  bool? _isSuccess;
  String? _couponMessage;
  int? _amount;
  dynamic _courses;

  bool? get isSuccess => _isSuccess;

  set isSuccess(bool? value) {
    _isSuccess = value;
  }

  String? get paymentProceed => _paymentProceed;
  String? get transactionId => _transactionId;

  Data(
      {String? paymentProceed,
      String? transactionId,
      String? couponMessage,
      bool? isSuccess,
      int? amount,
      List<Courses?>? courses}) {
    _paymentProceed = paymentProceed;
    _transactionId = transactionId;
    _couponMessage = couponMessage;
    _isSuccess = isSuccess;
    _amount = amount;
    _courses = courses;
  }

  Data.fromJson(dynamic json) {
    _paymentProceed = json["payment_proceed"];
    _transactionId = json["transaction_id"];
    _couponMessage = json["coupon_message"];
    _isSuccess = json["is_valid"];
    _amount = json["amount"];
    _courses = json["courses"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["payment_proceed"] = _paymentProceed;
    map["transaction_id"] = _transactionId;
    map["is_valid"] = _isSuccess;
    map["coupon_message"] = _couponMessage;
    map["amount"] = _amount;
    map["courses"] = _courses;
    return map;
  }

  String? get couponMessage => _couponMessage;
  dynamic get courses => _courses;

  int? get amount => _amount;

  set couponMessage(String? value) {
    _couponMessage = value;
  }
}

class Courses {
  String? _status;
  String? _title;
  String? _id;
  dynamic? _data;
  Courses({String? status, String? title, String? id, dynamic? data}) {
    _status = status;
    _title = title;
    _data = data;
    _id = id;
  }
  Courses.fromJson(dynamic json) {
    _status = json["status"];
    _title = json["title"];
    _id = json["id"];
    _data = json["data"];
  }
  String? get id => _id;
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["title"] = _title;
    map["id"] = _id;
    map["data"] = _data;

    return map;
  }
}
