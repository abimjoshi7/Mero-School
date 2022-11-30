/// status : true
/// message : ""
/// data : [{"id":"1","code":"1f011ec2c0","name":"Science","parent":"0","slug":"science","date_added":"1612742400","last_modified":"1613865600","font_awesome_class":"fas fa-chess","thumbnail":"http://demo.mero.school/uploads/thumbnails/category_thumbnails/759f5663f2e88f6db6ad64e868eb427e.jpg","number_of_courses":7},{"id":"3","code":"bad617b19e","name":"class 11","parent":"0","slug":"class-11","date_added":"1612742400","last_modified":null,"font_awesome_class":"fab fa-accusoft","thumbnail":"http://demo.mero.school/uploads/thumbnails/category_thumbnails/category-thumbnail.png","number_of_courses":0},{"id":"5","code":"0048ec5c5d","name":"Programming","parent":"0","slug":"programming","date_added":"1613865600","last_modified":null,"font_awesome_class":"fas fa-chess","thumbnail":"http://demo.mero.school/uploads/thumbnails/category_thumbnails/13637d41766d56c4a256c61a3771a58a.jpg","number_of_courses":3}]

class CategoriesResponse {
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  CategoriesResponse({bool? status, String? message, List<Data>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  CategoriesResponse.fromJson(dynamic json) {
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

class Data {
  String? _id;
  String? _code;
  String? _name;
  String? _parent;
  String? _slug;
  String? _dateAdded;
  String? _lastModified;
  String? _fontAwesomeClass;
  String? _thumbnail;
  int? _numberOfCourses;

  String? get id => _id;
  String? get code => _code;
  String? get name => _name;
  String? get parent => _parent;
  String? get slug => _slug;
  String? get dateAdded => _dateAdded;
  String? get lastModified => _lastModified;
  String? get fontAwesomeClass => _fontAwesomeClass;
  String? get thumbnail => _thumbnail;
  int? get numberOfCourses => _numberOfCourses;

  Data(
      {String? id,
      String? code,
      String? name,
      String? parent,
      String? slug,
      String? dateAdded,
      String? lastModified,
      String? fontAwesomeClass,
      String? thumbnail,
      int? numberOfCourses}) {
    _id = id;
    _code = code;
    _name = name;
    _parent = parent;
    _slug = slug;
    _dateAdded = dateAdded;
    _lastModified = lastModified;
    _fontAwesomeClass = fontAwesomeClass;
    _thumbnail = thumbnail;
    _numberOfCourses = numberOfCourses;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _code = json["code"];
    _name = json["name"];
    _parent = json["parent"];
    _slug = json["slug"];
    _dateAdded = json["date_added"];
    _lastModified = json["last_modified"];
    _fontAwesomeClass = json["font_awesome_class"];
    _thumbnail = json["thumbnail"];
    _numberOfCourses = json["number_of_courses"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["code"] = _code;
    map["name"] = _name;
    map["parent"] = _parent;
    map["slug"] = _slug;
    map["date_added"] = _dateAdded;
    map["last_modified"] = _lastModified;
    map["font_awesome_class"] = _fontAwesomeClass;
    map["thumbnail"] = _thumbnail;
    map["number_of_courses"] = _numberOfCourses;
    return map;
  }
}
