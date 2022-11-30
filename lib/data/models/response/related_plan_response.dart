/// status : true
/// message : ""
/// data : [{"id":"3","title":"Electrical Engineering First Sem","short_description":"The videos herein are strictly based on syllabus of Institute of Engineering Tribhuvan University, Nepal promoting e-Learning in Nepal and are made with intention to provide guidance to the Bachelor in Engineering (BE) appearing students, for securing good results. This plan Includes Subjects like Applied Mechanics, Engineering Drawing I and Engineering Mathematics I.","label":"Starting from","price":"Rs 3999","thumbnail":"https://mero.school/uploads/thumbnails/plans_thumbnails/Electrical-Eng-1st-Sem1.png","total_courses":3,"courses":["Engineering Drawing I","Applied Mechanics","Engineering Mathematics I"],"total_duration":"30:26:31 Hours","package":"3Months"},{"id":"8","title":"Civil Engineering 1st Sem","short_description":"The videos herein are strictly based on syllabus of Institute of Engineering Tribhuvan University, Nepal promoting e-Learning in Nepal and are made with intention to provide guidance to the Bachelor i","label":"Starting from","price":"Rs 3999","thumbnail":"https://mero.school/uploads/thumbnails/plans_thumbnails/CIVIL-ENGINEERING-1st-SEM1.png","total_courses":3,"courses":["Engineering Drawing I","Thermodynamics","Engineering Mathematics I"],"total_duration":"36:55:13 Hours","package":"3Months"},{"id":"29","title":"Engineering Drawing I","short_description":"Course Plan for Class 8 for 3 Months@ 20% Discount on Actual Price.","label":"Starting from","price":"Rs 12","thumbnail":"https://mero.school/uploads/thumbnails/plans_thumbnails/Electrical-Eng-1st-Sem1.png","total_courses":1,"courses":["Engineering Drawing I"],"total_duration":"15:03:05 Hours","package":"3Days"}]

class RelatedPlanResponse {
  RelatedPlanResponse({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  RelatedPlanResponse.fromJson(dynamic json) {
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

/// id : "3"
/// title : "Electrical Engineering First Sem"
/// short_description : "The videos herein are strictly based on syllabus of Institute of Engineering Tribhuvan University, Nepal promoting e-Learning in Nepal and are made with intention to provide guidance to the Bachelor in Engineering (BE) appearing students, for securing good results. This plan Includes Subjects like Applied Mechanics, Engineering Drawing I and Engineering Mathematics I."
/// label : "Starting from"
/// price : "Rs 3999"
/// thumbnail : "https://mero.school/uploads/thumbnails/plans_thumbnails/Electrical-Eng-1st-Sem1.png"
/// total_courses : 3
/// courses : ["Engineering Drawing I","Applied Mechanics","Engineering Mathematics I"]
/// total_duration : "30:26:31 Hours"
/// package : "3Months"

class Data {
  Data({
      String? id, 
      String? title, 
      String? shortDescription, 
      String? label, 
      String? price, 
      String? thumbnail, 
      int? totalCourses, 
      List<String>? courses, 
      String? totalDuration, 
      String? package,}){
    _id = id;
    _title = title;
    _shortDescription = shortDescription;
    _label = label;
    _price = price;
    _thumbnail = thumbnail;
    _totalCourses = totalCourses;
    _courses = courses;
    _totalDuration = totalDuration;
    _package = package;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _shortDescription = json['short_description'];
    _label = json['label'];
    _price = json['price'];
    _thumbnail = json['thumbnail'];
    _totalCourses = json['total_courses'];
    _courses = json['courses'] != null ? json['courses'].cast<String>() : [];
    _totalDuration = json['total_duration'];
    _package = json['package'];
  }
  String? _id;
  String? _title;
  String? _shortDescription;
  String? _label;
  String? _price;
  String? _thumbnail;
  int? _totalCourses;
  List<String>? _courses;
  String? _totalDuration;
  String? _package;

  String? get id => _id;
  String? get title => _title;
  String? get shortDescription => _shortDescription;
  String? get label => _label;
  String? get price => _price;
  String? get thumbnail => _thumbnail;
  int? get totalCourses => _totalCourses;
  List<String>? get courses => _courses;
  String? get totalDuration => _totalDuration;
  String? get package => _package;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['short_description'] = _shortDescription;
    map['label'] = _label;
    map['price'] = _price;
    map['thumbnail'] = _thumbnail;
    map['total_courses'] = _totalCourses;
    map['courses'] = _courses;
    map['total_duration'] = _totalDuration;
    map['package'] = _package;
    return map;
  }

}