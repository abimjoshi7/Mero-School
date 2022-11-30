/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjA3IiwiZmlyc3RfbmFtZSI6Iktlc2hhdiIsImxhc3RfbmFtZSI6IkJodXNhbCIsImVtYWlsIjoia2VzaGF2QHBvZGFtaWJlbmVwYWwuY29tIiwicm9sZSI6InVzZXIiLCJ2YWxpZGl0eSI6MX0.VELN_fsK7OxK-RIQNpNkBLO92rJUrOUKbFfvxPKn1nE"
/// course_id : "15"

class EnrolledToFreeCourseRequest {
  String? _authToken;
  String? _courseId;

  String? get authToken => _authToken;
  String? get courseId => _courseId;

  EnrolledToFreeCourseRequest({String? authToken, String? courseId}) {
    _authToken = authToken;
    _courseId = courseId;
  }

  EnrolledToFreeCourseRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _courseId = json["course_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["course_id"] = _courseId;
    return map;
  }
}
