/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjMxIiwiZmlyc3RfbmFtZSI6Ik5pcmFqIiwibGFzdF9uYW1lIjoiVGFtYW5nIiwiZW1haWwiOiJjIGMiLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.7wQyzR6j0vtiCVM6qEcI0OuTTWrwstE82-9D7vNXx2Q"
/// course_id : "27"
/// first_name : "Niraj"
/// isMyReview : false
/// last_name : "Tamang"
/// rating : 5.0
/// review : "This is great course learning"

class ReviewAddedRequest {
  String? _authToken;
  String? _courseId;
  String? _firstName;
  bool? _isMyReview;
  String? _lastName;
  double? _rating;
  String? _review;

  String? get authToken => _authToken;
  String? get courseId => _courseId;
  String? get firstName => _firstName;
  bool? get isMyReview => _isMyReview;
  String? get lastName => _lastName;
  double? get rating => _rating;
  String? get review => _review;

  ReviewAddedRequest(
      {String? authToken,
      String? courseId,
      String? firstName,
      bool? isMyReview,
      String? lastName,
      double? rating,
      String? review}) {
    _authToken = authToken;
    _courseId = courseId;
    _firstName = firstName;
    _isMyReview = isMyReview;
    _lastName = lastName;
    _rating = rating;
    _review = review;
  }

  ReviewAddedRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _courseId = json["course_id"];
    _firstName = json["first_name"];
    _isMyReview = json["isMyReview"];
    _lastName = json["last_name"];
    _rating = json["rating"];
    _review = json["review"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["course_id"] = _courseId;
    map["first_name"] = _firstName;
    map["isMyReview"] = _isMyReview;
    map["last_name"] = _lastName;
    map["rating"] = _rating;
    map["review"] = _review;
    return map;
  }
}
