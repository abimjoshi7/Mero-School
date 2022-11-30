/// course_id : "14"
/// number_of_lessons : 115
/// number_of_completed_lessons : 1
/// course_progress : 1

class SaveCourseProgressResponse {
  String? _courseId;
  int? _numberOfLessons;
  int? _numberOfCompletedLessons;
  int? _courseProgress;

  String? get courseId => _courseId;
  int? get numberOfLessons => _numberOfLessons;
  int? get numberOfCompletedLessons => _numberOfCompletedLessons;
  int? get courseProgress => _courseProgress;

  SaveCourseProgressResponse(
      {String? courseId,
      int? numberOfLessons,
      int? numberOfCompletedLessons,
      int? courseProgress}) {
    _courseId = courseId;
    _numberOfLessons = numberOfLessons;
    _numberOfCompletedLessons = numberOfCompletedLessons;
    _courseProgress = courseProgress;
  }

  SaveCourseProgressResponse.fromJson(dynamic json) {
    _courseId = json["course_id"];
    _numberOfLessons = json["number_of_lessons"];
    _numberOfCompletedLessons = json["number_of_completed_lessons"];
    _courseProgress = json["course_progress"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["course_id"] = _courseId;
    map["number_of_lessons"] = _numberOfLessons;
    map["number_of_completed_lessons"] = _numberOfCompletedLessons;
    map["course_progress"] = _courseProgress;
    return map;
  }
}
