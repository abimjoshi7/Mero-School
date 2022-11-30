/// status : true
/// message : "enrolled successful"
/// data : true

class EnrolledToFreeCourseResponse {
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  EnrolledToFreeCourseResponse({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  EnrolledToFreeCourseResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map['data'] = _data;
    return map;
  }
}

class Data {
  bool? _is_enrolled;
  String? _plan_exp_date;

  bool? get is_enrolled => _is_enrolled;

  set is_enrolled(bool? value) {
    _is_enrolled = value;
  }

  String? get plan_exp_date => _plan_exp_date;

  set plan_exp_date(String? value) {
    _plan_exp_date = value;
  }

  Data.fromJson(dynamic json) {
    _is_enrolled = json["is_enrolled"];
    _plan_exp_date = json["plan_exp_date"];
  }
}
