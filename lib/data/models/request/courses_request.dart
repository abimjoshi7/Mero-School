/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjA3IiwiZmlyc3RfbmFtZSI6Ik1yLiIsImxhc3RfbmFtZSI6Ik5vYm9keSIsImVtYWlsIjoibi5pLnJhai5zeWFuZ2RlbkBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.YTXN-sPkyHnUUaiUOysrBsEs0bGzZJM_vGrt56r_F3Q"

class CoursesRequest {
  String? _authToken;
  String? _courseId;

  String? get courseId => _courseId;

  set courseId(String? value) {
    _courseId = value;
  }

  String? get authToken => _authToken;

  CoursesRequest({String? authToken, String? courseid}) {
    _authToken = authToken;
    _courseId = courseid;
  }

  CoursesRequest.fromJson(dynamic json) {
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
