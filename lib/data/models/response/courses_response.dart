import 'course_details_by_id_response.dart';

/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjA3IiwiZmlyc3RfbmFtZSI6Ik1yLiIsImxhc3RfbmFtZSI6Ik5vYm9keSIsImVtYWlsIjoibi5pLnJhai5zeWFuZ2RlbkBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.YTXN-sPkyHnUUaiUOysrBsEs0bGzZJM_vGrt56r_F3Q"

class CoursesResponse {
  bool? _status;
  String? _message;
  List<CourseDetailsByIdResponse>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<CourseDetailsByIdResponse>? get data => _data;

  CoursesResponse(
      {bool? status, String? message, List<CourseDetailsByIdResponse>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  CoursesResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(CourseDetailsByIdResponse.fromJson(v));
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
