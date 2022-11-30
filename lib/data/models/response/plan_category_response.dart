/// status : true
/// message : "All Category"
/// planCategory : [{"id":"43","label":"Civil Engineering Courses"},{"id":"48","label":"Class 1 Plans"},{"id":"42","label":"Class 10 Courses"},{"id":"49","label":"Class 8 Plans"},{"id":"40","label":"Class 9 Plans"},{"id":"44","label":"Electronic Engineering Courses "},{"id":"37","label":"Test Class 8 "}]
/// packageCategory : [{"id":"5","label":"2Months"},{"id":"6","label":"3Months"},{"id":"7","label":"6Months"},{"id":"8","label":"12Months"},{"id":"9","label":"3Days"},{"id":"10","label":"7Days"},{"id":"11","label":"5 Days Package"},{"id":"12","label":"30Days"}]

class PlanCategoryResponse {
  PlanCategoryResponse({
      bool? status, 
      String? message, 
      List<CategoryData>? planCategory,
      List<CategoryData>? packageCategory,}){
    _status = status;
    _message = message;
    _planCategory = planCategory;
    _packageCategory = packageCategory;
}

  PlanCategoryResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['planCategory'] != null) {
      _planCategory = [];
      json['planCategory'].forEach((v) {
        _planCategory?.add(CategoryData.fromJson(v));
      });
    }
    if (json['packageCategory'] != null) {
      _packageCategory = [];
      json['packageCategory'].forEach((v) {
        _packageCategory?.add(CategoryData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<CategoryData>? _planCategory;
  List<CategoryData>? _packageCategory;

  bool? get status => _status;
  String? get message => _message;
  List<CategoryData>? get planCategory => _planCategory;
  List<CategoryData>? get packageCategory => _packageCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_planCategory != null) {
      map['planCategory'] = _planCategory?.map((v) => v.toJson()).toList();
    }
    if (_packageCategory != null) {
      map['packageCategory'] = _packageCategory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "5"
/// label : "2Months"

/// id : "43"
/// label : "Civil Engineering Courses"

class CategoryData {
  CategoryData({
      String? id, 
      String? label,}){
    _id = id;
    _label = label;
}

  CategoryData.fromJson(dynamic json) {
    _id = json['id'];
    _label = json['label'];
  }
  String? _id;
  String? _label;

  String? get id => _id;
  String? get label => _label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['label'] = _label;
    return map;
  }

}