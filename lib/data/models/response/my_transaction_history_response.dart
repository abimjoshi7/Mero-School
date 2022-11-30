/// status : true
/// message : ""
/// data : [{"id":"540","course_id":"15","course":"Thermodynamics","subscription_id":"","plan":"","user_id":"14867","agent":"KHALTI","couse_plan":"","status":"SUCCESS","transaction_date":"2021-12-23 12:26:18","transaction_id":"f3cfce9c2033","ref_id":"BdMjLW6PCLYXj","amount":"989","couponAmount":"Coupon Amount : Rs 10","couponUsed":"Coupon Status : Coupon Used ","no_of_course":1,"enrolled_status":false,"package":"","package_id":"","plan_vilid":""}]

class MyTransactionHistoryResponse {
  MyTransactionHistoryResponse({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  MyTransactionHistoryResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "540"
/// course_id : "15"
/// course : "Thermodynamics"
/// subscription_id : ""
/// plan : ""
/// user_id : "14867"
/// agent : "KHALTI"
/// couse_plan : ""
/// status : "SUCCESS"
/// transaction_date : "2021-12-23 12:26:18"
/// transaction_id : "f3cfce9c2033"
/// ref_id : "BdMjLW6PCLYXj"
/// amount : "989"
/// couponAmount : "Coupon Amount : Rs 10"
/// couponUsed : "Coupon Status : Coupon Used "
/// no_of_course : 1
/// enrolled_status : false
/// package : ""
/// package_id : ""
/// plan_vilid : ""

class Data {
  Data({
      String? id, 
      String? courseId, 
      String? course, 
      String? subscriptionId, 
      String? plan, 
      String? userId, 
      String? agent, 
      String? cousePlan, 
      String? status, 
      String? transactionDate, 
      String? transactionId, 
      String? refId, 
      String? amount, 
      String? couponAmount, 
      String? couponUsed, 
      int? noOfCourse, 
      bool? enrolledStatus, 
      String? package, 
      String? packageId, 
      String? planVilid,}){
    _id = id;
    _courseId = courseId;
    _course = course;
    _subscriptionId = subscriptionId;
    _plan = plan;
    _userId = userId;
    _agent = agent;
    _cousePlan = cousePlan;
    _status = status;
    _transactionDate = transactionDate;
    _transactionId = transactionId;
    _refId = refId;
    _amount = amount;
    _couponAmount = couponAmount;
    _couponUsed = couponUsed;
    _noOfCourse = noOfCourse;
    _enrolledStatus = enrolledStatus;
    _package = package;
    _packageId = packageId;
    _planVilid = planVilid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _courseId = json['course_id'];
    _course = json['course'];
    _subscriptionId = json['subscription_id'];
    _plan = json['plan'];
    _userId = json['user_id'];
    _agent = json['agent'];
    _cousePlan = json['couse_plan'];
    _status = json['status'];
    _transactionDate = json['transaction_date'];
    _transactionId = json['transaction_id'];
    _refId = json['ref_id'];
    _amount = json['amount'];
    _couponAmount = json['couponAmount'];
    _couponUsed = json['couponUsed'];
    _noOfCourse = json['no_of_course'];
    _enrolledStatus = json['enrolled_status'];
    _package = json['package'];
    _packageId = json['package_id'];
    _planVilid = json['plan_vilid'];
  }
  String? _id;
  String? _courseId;
  String? _course;
  String? _subscriptionId;
  String? _plan;
  String? _userId;
  String? _agent;
  String? _cousePlan;
  String? _status;
  String? _transactionDate;
  String? _transactionId;
  String? _refId;
  String? _amount;
  String? _couponAmount;
  String? _couponUsed;
  int? _noOfCourse;
  bool? _enrolledStatus;
  String? _package;
  String? _packageId;
  String? _planVilid;

  String? get id => _id;
  String? get courseId => _courseId;
  String? get course => _course;
  String? get subscriptionId => _subscriptionId;
  String? get plan => _plan;
  String? get userId => _userId;
  String? get agent => _agent;
  String? get cousePlan => _cousePlan;
  String? get status => _status;
  String? get transactionDate => _transactionDate;
  String? get transactionId => _transactionId;
  String? get refId => _refId;
  String? get amount => _amount;
  String? get couponAmount => _couponAmount;
  String? get couponUsed => _couponUsed;
  int? get noOfCourse => _noOfCourse;
  bool? get enrolledStatus => _enrolledStatus;
  String? get package => _package;
  String? get packageId => _packageId;
  String? get planVilid => _planVilid;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['course_id'] = _courseId;
    map['course'] = _course;
    map['subscription_id'] = _subscriptionId;
    map['plan'] = _plan;
    map['user_id'] = _userId;
    map['agent'] = _agent;
    map['couse_plan'] = _cousePlan;
    map['status'] = _status;
    map['transaction_date'] = _transactionDate;
    map['transaction_id'] = _transactionId;
    map['ref_id'] = _refId;
    map['amount'] = _amount;
    map['couponAmount'] = _couponAmount;
    map['couponUsed'] = _couponUsed;
    map['no_of_course'] = _noOfCourse;
    map['enrolled_status'] = _enrolledStatus;
    map['package'] = _package;
    map['package_id'] = _packageId;
    map['plan_vilid'] = _planVilid;
    return map;
  }

}