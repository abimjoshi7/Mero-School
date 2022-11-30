/// status : true
/// message : ""
/// data : [{"id":"22","rating":"5","user_id":"231","ratable_type":"course","date_added":"Apr 11 2021","name":"niraj kumar","profilePic":"http://demo.mero.school/uploads/user_image/231.jpg","review":"This is great course learning","isMyReview":true,"status":"Pending"}]

class ReviewResponse {
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  ReviewResponse({bool? status, String? message, List<Data>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ReviewResponse.fromJson(dynamic json) {
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

/// id : "22"
/// rating : "5"
/// user_id : "231"
/// ratable_type : "course"
/// date_added : "Apr 11 2021"
/// name : "niraj kumar"
/// profilePic : "http://demo.mero.school/uploads/user_image/231.jpg"
/// review : "This is great course learning"
/// isMyReview : true
/// status : "Pending"

class Data {
  String? _id;
  String? _rating;
  String? _userId;
  String? _ratableType;
  String? _dateAdded;
  String? _name;
  String? _profilePic;
  String? _review;
  bool? _isMyReview;
  String? _status;

  String? get id => _id;
  String? get rating => _rating;
  String? get userId => _userId;
  String? get ratableType => _ratableType;
  String? get dateAdded => _dateAdded;
  String? get name => _name;
  String? get profilePic => _profilePic;
  String? get review => _review;
  bool? get isMyReview => _isMyReview;
  String? get status => _status;

  Data(
      {String? id,
      String? rating,
      String? userId,
      String? ratableType,
      String? dateAdded,
      String? name,
      String? profilePic,
      String? review,
      bool? isMyReview,
      String? status}) {
    _id = id;
    _rating = rating;
    _userId = userId;
    _ratableType = ratableType;
    _dateAdded = dateAdded;
    _name = name;
    _profilePic = profilePic;
    _review = review;
    _isMyReview = isMyReview;
    _status = status;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _rating = json["rating"];
    _userId = json["user_id"];
    _ratableType = json["ratable_type"];
    _dateAdded = json["date_added"];
    _name = json["name"];
    _profilePic = json["profilePic"];
    _review = json["review"];
    _isMyReview = json["isMyReview"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["rating"] = _rating;
    map["user_id"] = _userId;
    map["ratable_type"] = _ratableType;
    map["date_added"] = _dateAdded;
    map["name"] = _name;
    map["profilePic"] = _profilePic;
    map["review"] = _review;
    map["isMyReview"] = _isMyReview;
    map["status"] = _status;
    return map;
  }
}
