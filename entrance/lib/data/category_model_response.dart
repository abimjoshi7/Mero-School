import 'dart:math';

import 'package:entrance/data/model.dart';
import 'package:flutter/material.dart';

/// status : true
/// message : ""
/// data : [{"id":"1","code":"c0123534e9","name":"Class 10","parent":"0","slug":"class-10","date_added":"1612310400","last_modified":"1633371300","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/103388dd3361eec20e487bc2b03f06d5.jpg","number_of_courses":10},{"id":"6","code":"076b1ab1df","name":"Engineering","parent":"0","slug":"engineering","date_added":"1612656000","last_modified":"1628100900","font_awesome_class":"fas fa-calculator","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/e340c1a3e62db8bb23ac5c659b877f2f.jpg","number_of_courses":14},{"id":"24","code":"7fe787a734","name":"Class 9 ","parent":"0","slug":"class-9","date_added":"1613001600","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/869c931232744ff309a5b3fffa4341db.jpg","number_of_courses":4},{"id":"31","code":"df61c8aef2","name":"Class 8","parent":"0","slug":"class-8","date_added":"1613260800","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/03ee40ef238d0f847709ecc2a4d64f4e.jpg","number_of_courses":4},{"id":"39","code":"2aefbccf69","name":"Language ","parent":"0","slug":"language","date_added":"1613347200","last_modified":"1631816100","font_awesome_class":"fab fa-accessible-icon","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/e596b3914b0ff52a58e875f09d8b28d4.jpg","number_of_courses":3},{"id":"40","code":"307468c5f6","name":"Class 11 ","parent":"0","slug":"class-11","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fab fa-accusoft","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/25956e8aca30c7dcce3046f711c5712c.jpg","number_of_courses":1},{"id":"41","code":"ee403d4eb9","name":"Class 12","parent":"0","slug":"class-12","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fab fa-adn","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/b26fc6d938d30992c2128bc5717b90b5.jpg","number_of_courses":0},{"id":"42","code":"9b62eb7dbc","name":"Bachelor","parent":"0","slug":"bachelor","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fab fa-accessible-icon","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/c80aef4924e4bd79616a0cab6b633644.jpg","number_of_courses":0},{"id":"43","code":"c127ae0d06","name":"Class 1","parent":"0","slug":"class-1","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/111647fb4afb252356548b18a14412be.jpg","number_of_courses":1},{"id":"44","code":"5457f180f7","name":"Class 2 ","parent":"0","slug":"class-2","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/a59ea6f8a3305ccd20edceaeffa98d23.jpg","number_of_courses":0},{"id":"45","code":"241ace4557","name":"Class 3 ","parent":"0","slug":"class-3","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/bb0206a5d299e8825f2f90a19164b891.jpg","number_of_courses":0},{"id":"46","code":"0bf4824a9c","name":"Class 4 ","parent":"0","slug":"class-4","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/a97d86e251f3322f32320a2518d7f468.jpg","number_of_courses":0},{"id":"47","code":"ef4f9882ea","name":"Class 5 ","parent":"0","slug":"class-5","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/76ac65b6bbab49b8b0a1fac4b9f22e7b.jpg","number_of_courses":1},{"id":"48","code":"8b8383ff4a","name":"Class 6 ","parent":"0","slug":"class-6","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/748f8a1af7e59e664467323f6f582a16.jpg","number_of_courses":1},{"id":"49","code":"a11983fb04","name":"Class 7 ","parent":"0","slug":"class-7","date_added":"1613347200","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/3c7d2959acaf0effd1b05a845f7ff011.jpg","number_of_courses":1},{"id":"76","code":"a56c0f5942","name":"Engineering Entrance Preparation","parent":"0","slug":"engineering-entrance-preparation","date_added":"1617840000","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/bd0ea959a49e81628215251c6b88f1e4.jpg","number_of_courses":2},{"id":"79","code":"4f1d02cf04","name":"Graphics Design and Illustration","parent":"0","slug":"graphics-design-and-illustration","date_added":"1618272000","last_modified":"1628100900","font_awesome_class":"fas fa-chess","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/3931aaeb2fa03bcf6b3175a3b728ed60.jpg","number_of_courses":6},{"id":"95","code":"e553551532","name":"Testing","parent":"0","slug":"testing","date_added":"1632075300","last_modified":null,"font_awesome_class":"fas fa-angle-double-left","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/category-thumbnail.png","number_of_courses":0},{"id":"97","code":"3108031293","name":"Optimize Code and Testing ","parent":"0","slug":"optimize-code-and-testing","date_added":"1633371300","last_modified":"1633371300","font_awesome_class":"fab fa-accessible-icon","thumbnail":"https://demo.mero.school/uploads/thumbnails/category_thumbnails/category-thumbnail.png","number_of_courses":0}]

class CategoryModelResponse extends Model {
  CategoryModelResponse({
    bool? status,
    String? message,
    List<CategoryData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  @override
  CategoryModelResponse fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        var cat = CategoryData.fromJson(v);
        cat.color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        _data?.add(cat);
      });
    }

    return this;
  }

  bool? _status;
  String? _message;
  List<CategoryData>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<CategoryData>? get data => _data;


  set data(List<CategoryData>? value) {
    _data = value;
  }

  @override
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

/// id : "1"
/// code : "c0123534e9"
/// name : "Class 10"
/// parent : "0"
/// slug : "class-10"
/// date_added : "1612310400"
/// last_modified : "1633371300"
/// font_awesome_class : "fas fa-chess"
/// thumbnail : "https://demo.mero.school/uploads/thumbnails/category_thumbnails/103388dd3361eec20e487bc2b03f06d5.jpg"
/// number_of_courses : 10

class CategoryData {
  CategoryData({
    String? id,
    String? code,
    String? name,
    String? parent,
    String? slug,
    String? dateAdded,
    String? lastModified,
    String? fontAwesomeClass,
    String? thumbnail,
    int? numberOfCourses,
  }) {
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

  CategoryData.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _name = json['name'];
    _parent = json['parent'];
    _slug = json['slug'];
    _dateAdded = json['date_added'];
    _lastModified = json['last_modified'];
    _fontAwesomeClass = json['font_awesome_class'];
    _thumbnail = json['thumbnail'];
    _numberOfCourses = json['number_of_courses'];
  }
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


  set id(String? value) {
    _id = value;
  }

  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    map['parent'] = _parent;
    map['slug'] = _slug;
    map['date_added'] = _dateAdded;
    map['last_modified'] = _lastModified;
    map['font_awesome_class'] = _fontAwesomeClass;
    map['thumbnail'] = _thumbnail;
    map['number_of_courses'] = _numberOfCourses;
    return map;
  }

  set code(String? value) {
    _code = value;
  }

  set name(String? value) {
    _name = value;
  }

  set parent(String? value) {
    _parent = value;
  }

  set slug(String? value) {
    _slug = value;
  }

  set dateAdded(String? value) {
    _dateAdded = value;
  }

  set lastModified(String? value) {
    _lastModified = value;
  }

  set fontAwesomeClass(String? value) {
    _fontAwesomeClass = value;
  }

  set thumbnail(String? value) {
    _thumbnail = value;
  }

  set numberOfCourses(int? value) {
    _numberOfCourses = value;
  }
}
