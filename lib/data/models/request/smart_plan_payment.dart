/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjMxIiwiZmlyc3RfbmFtZSI6InVzZXIiLCJsYXN0X25hbWUiOiJkZW1vIiwiZW1haWwiOiJjIGMiLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.MnYukY0Sy9Qp3ggt2QF0BNN6Lm2t8BFQNJEF-spS_Qk"
/// endside : "app"
/// plan_vilid : "7"
/// subscription_id : "2"
/// subscription_plan : "Android Application Beyond Basic"
/// total_price : 10

class SmartPlanPayment {
  String? _authToken;
  String? _endside;
  String? _planVilid;
  String? _subscriptionId;
  String? _subscriptionPlan;
  String? _totalPrice;

  String? get authToken => _authToken;
  String? get endside => _endside;
  String? get planVilid => _planVilid;
  String? get subscriptionId => _subscriptionId;
  String? get subscriptionPlan => _subscriptionPlan;
  String? get totalPrice => _totalPrice;

  SmartPlanPayment(
      {String? authToken,
      String? endside,
      String? planVilid,
      String? subscriptionId,
      String? subscriptionPlan,
      String? totalPrice}) {
    _authToken = authToken;
    _endside = endside;
    _planVilid = planVilid;
    _subscriptionId = subscriptionId;
    _subscriptionPlan = subscriptionPlan;
    _totalPrice = totalPrice;
  }

  SmartPlanPayment.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _endside = json["endside"];
    _planVilid = json["plan_vilid"];
    _subscriptionId = json["subscription_id"];
    _subscriptionPlan = json["subscription_plan"];
    _totalPrice = json["total_price"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["endside"] = _endside;
    map["plan_vilid"] = _planVilid;
    map["subscription_id"] = _subscriptionId;
    map["subscription_plan"] = _subscriptionPlan;
    map["total_price"] = _totalPrice;
    return map;
  }
}
