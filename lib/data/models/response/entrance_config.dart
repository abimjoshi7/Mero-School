/// status : true
/// message : ""
/// data : {"user_id":"14847","email":"niraj.tamang.2022@gmail.com","phone_number":"","course_id":15,"level":"Beginner","subscription_id":"","thumbnail":"http://demo.mero.school/uploads/course.jpg","title":"Account 10","subtitle":"Account class 10 videos ,According to Curriculum Development Centre, Nepal Designed for SEE Students."}

class Entrance_config {
  Entrance_config({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Entrance_config.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data!.toJson();
    }
    return map;
  }
}

/// user_id : "14847"
/// email : "niraj.tamang.2022@gmail.com"
/// phone_number : ""
/// course_id : 15
/// level : "Beginner"
/// subscription_id : ""
/// thumbnail : "http://demo.mero.school/uploads/course.jpg"
/// title : "Account 10"
/// subtitle : "Account class 10 videos ,According to Curriculum Development Centre, Nepal Designed for SEE Students."
/// tag: "MeroSchool"

class Data {
  Data({String? thumbnail, String? title, String? subtitle, String? url}) {
    _thumbnail = thumbnail;
    _title = title;
    _subtitle = subtitle;
    _url = url;
  }

  Data.fromJson(dynamic json) {
    _thumbnail = json['thumbnail'];
    _title = json['title'];
    _subtitle = json['subtitle'];
    _url = json['url'];
  }

  String? _thumbnail;
  String? _title;
  String? _subtitle;
  String? _url;

  String? get url => _url;

  set url(String? value) {
    _url = value;
  }

  String? get thumbnail => _thumbnail;
  String? get title => _title;
  String? get subtitle => _subtitle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['thumbnail'] = _thumbnail;
    map['title'] = _title;
    map['subtitle'] = _subtitle;
    map['url'] = _subtitle;
    return map;
  }
}
