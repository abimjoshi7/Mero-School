/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjMxIiwiZmlyc3RfbmFtZSI6InVzZXIiLCJsYXN0X25hbWUiOiJkZW1vIiwiZW1haWwiOiJjIGMiLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.MnYukY0Sy9Qp3ggt2QF0BNN6Lm2t8BFQNJEF-spS_Qk"
/// courses : "Account 10 "
/// courses_id : "14,"
/// endside : "app"
/// total_price : 999

class SmartCoursePaymentRequest {
  String? _authToken;
  String? _courses;
  String? _coursesId;
  String? _endside;
  String? _totalPrice;
  String? _couponCode;

  String? get couponCode => _couponCode;

  set couponCode(String? value) {
    _couponCode = value;
  }

  String? get authToken => _authToken;
  String? get courses => _courses;
  String? get coursesId => _coursesId;
  String? get endside => _endside;
  String? get totalPrice => _totalPrice;

  SmartCoursePaymentRequest({
    String? authToken,
    String? courses,
    String? coursesId,
    String? endside,
    String? totalPrice,
  }) {
    _authToken = authToken;
    _courses = courses;
    _coursesId = coursesId;
    _endside = endside;
    _totalPrice = totalPrice;
  }

  SmartCoursePaymentRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _courses = json["courses"];
    _coursesId = json["courses_id"];
    _endside = json["endside"];
    _totalPrice = json["total_price"];
    _couponCode = json["coupon_code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["courses"] = _courses;
    map["courses_id"] = _coursesId;
    map["endside"] = _endside;
    map["total_price"] = _totalPrice;
    map["coupon_code"] = _couponCode;
    return map;
  }
}

class SmartPlanPaymentRequest {
  String? _authToken;
  String? _totalPrice;
  String? _endside;

  String? _subscription_plan;
  String? _subscription_id;
  String? _planValid;

  String? get planValid => _planValid;

  set planValid(String? value) {
    _planValid = value;
  }

  String? get authToken => _authToken;

  String? get endside => _endside;
  String? get totalPrice => _totalPrice;

  String? get subscription_plan => _subscription_plan;

  set subscription_plan(String? value) {
    _subscription_plan = value;
  }

  SmartPlanPaymentRequest(
      {String? authToken,
      String? courses,
      String? coursesId,
      String? endside,
      String? totalPrice,
      String? planValid}) {
    _authToken = authToken;
    _subscription_plan = courses;
    _subscription_id = coursesId;
    _endside = endside;
    _totalPrice = totalPrice;
    _planValid = planValid;
  }

  SmartPlanPaymentRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _subscription_plan = json["subscription_plan"];
    _subscription_id = json["subscription_id"];
    _planValid = json["plan_vilid"];
    _endside = json["endside"];
    _totalPrice = json["total_price"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["subscription_plan"] = _subscription_plan;
    map["subscription_id"] = _subscription_id;
    map["endside"] = _endside;
    map["total_price"] = _totalPrice;
    map["plan_vilid"] = _planValid;
    return map;
  }

  String? get subscription_id => _subscription_id;

  set subscription_id(String? value) {
    _subscription_id = value;
  }
}
