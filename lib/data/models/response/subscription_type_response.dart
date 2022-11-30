/// status : true
/// message : ""
/// data : [{"id":"1","plan_id":"1","plans":"Gold Plan","plan_description":"Gold Plan ","package_id":"3","package":"Weekly Recurring","validity":"7","price":"20","currency":"₨","course_id":null,"video_url":"","is_purchase":false,"plan_exp_date":"","course_plan":[{"id":"14","title":"Account 10"},{"id":"25","title":"Physics"}]},{"id":"3","plan_id":"1","plans":"Gold Plan","plan_description":"Gold Plan ","package_id":"4","package":"Monthly","validity":"30","price":"30","currency":"₨","course_id":null,"video_url":"","is_purchase":false,"plan_exp_date":"","course_plan":[{"id":"14","title":"Account 10"},{"id":"25","title":"Physics"}]},{"id":"4","plan_id":"3","plans":"Gold Class 10","plan_description":"Hello Plan","package_id":"4","package":"Monthly","validity":"30","price":"12","currency":"₨","course_id":null,"video_url":"","is_purchase":false,"plan_exp_date":"","course_plan":[{"id":"16","title":"Electrical Machine 2"}]}]

class SubscriptionTypeResponse {
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  SubscriptionTypeResponse({bool? status, String? message, List<Data>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SubscriptionTypeResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "1"
/// plan_id : "1"
/// plans : "Gold Plan"
/// plan_description : "Gold Plan "
/// package_id : "3"
/// package : "Weekly Recurring"
/// validity : "7"
/// price : "20"
/// currency : "₨"
/// course_id : null
/// video_url : ""
/// is_purchase : false
/// plan_exp_date : ""
/// course_plan : [{"id":"14","title":"Account 10"},{"id":"25","title":"Physics"}]

class Data {
  String? _id;
  String? _planId;
  String? _plans;
  String? _planDescription;
  String? _packageId;
  String? _package;
  String? _validity;
  String? _price;
  String? _currency;
  dynamic _courseId;
  String? _videoUrl;
  bool? _isPurchase;
  String? _planExpDate;
  List<Course_plan>? _coursePlan;

  String? get id => _id;
  String? get planId => _planId;
  String? get plans => _plans;
  String? get planDescription => _planDescription;
  String? get packageId => _packageId;
  String? get package => _package;
  String? get validity => _validity;
  String? get price => _price;
  String? get currency => _currency;
  dynamic get courseId => _courseId;
  String? get videoUrl => _videoUrl;
  bool? get isPurchase => _isPurchase;
  String? get planExpDate => _planExpDate;
  List<Course_plan>? get coursePlan => _coursePlan;

  Data(
      {String? id,
      String? planId,
      String? plans,
      String? planDescription,
      String? packageId,
      String? package,
      String? validity,
      String? price,
      String? currency,
      dynamic courseId,
      String? videoUrl,
      bool? isPurchase,
      String? planExpDate,
      List<Course_plan>? coursePlan}) {
    _id = id;
    _planId = planId;
    _plans = plans;
    _planDescription = planDescription;
    _packageId = packageId;
    _package = package;
    _validity = validity;
    _price = price;
    _currency = currency;
    _courseId = courseId;
    _videoUrl = videoUrl;
    _isPurchase = isPurchase;
    _planExpDate = planExpDate;
    _coursePlan = coursePlan;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _planId = json["plan_id"];
    _plans = json["plans"];
    _planDescription = json["plan_description"];
    _packageId = json["package_id"];
    _package = json["package"];
    _validity = json["validity"];
    _price = json["price"];
    _currency = json["currency"];
    _courseId = json["course_id"];
    _videoUrl = json["video_url"];
    _isPurchase = json["is_purchase"];
    _planExpDate = json["plan_exp_date"];
    if (json["course_plan"] != null) {
      _coursePlan = [];
      json["course_plan"].forEach((v) {
        _coursePlan!.add(Course_plan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["plan_id"] = _planId;
    map["plans"] = _plans;
    map["plan_description"] = _planDescription;
    map["package_id"] = _packageId;
    map["package"] = _package;
    map["validity"] = _validity;
    map["price"] = _price;
    map["currency"] = _currency;
    map["course_id"] = _courseId;
    map["video_url"] = _videoUrl;
    map["is_purchase"] = _isPurchase;
    map["plan_exp_date"] = _planExpDate;
    if (_coursePlan != null) {
      map["course_plan"] = _coursePlan!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "14"
/// title : "Account 10"

class Course_plan {
  String? _id;
  String? _title;

  String? get id => _id;
  String? get title => _title;

  Course_plan({String? id, String? title}) {
    _id = id;
    _title = title;
  }

  Course_plan.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    return map;
  }
}
