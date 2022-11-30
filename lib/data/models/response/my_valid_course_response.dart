/// status : true
/// message : "course details"
/// data : [{"id":"2","course_type":"choose_course_title","title":"Php Tutorial","original_title":"php tutorial","short_description":"Free Course","description":"<p>This is free course. </p>","outcomes":["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."],"language":"english","category_id":"1","sub_category_id":"2","section":"[]","requirements":["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."],"price":"Free","discount_flag":null,"discounted_price":"0","level":"beginner","user_id":"1","thumbnail":"https://demo.mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_2.jpg?time=","video_url":"https://www.youtube.com/watch?v=ABjCVTBnO_U","date_added":"1613606400","last_modified":null,"visibility":null,"is_top_course":"1","is_admin":"1","status":"active","course_overview_provider":"youtube","meta_keywords":"","meta_description":"","is_free_course":"1","id_from_another_server":"3","currency":"NRs","rating":0,"number_of_ratings":0,"instructor_name":"Rajendra Maharjan","total_enrollment":1,"shareable_link":"https://demo.mero.school/home/course/php-tutorial/2","completion":0,"total_number_of_lessons":41,"total_number_of_completed_lessons":0},{"id":"5","course_type":"add_new_course_title","title":"Swift ","original_title":"Swift ","short_description":"Swift","description":"<p>   A prograaming <br></p>","outcomes":["Introduction of Optional Mathematics."],"language":"english","category_id":"5","sub_category_id":"6","section":"[]","requirements":["Basic of Office Management and Account"],"price":"Free","discount_flag":null,"discounted_price":"0","level":"advanced","user_id":"1","thumbnail":"https://demo.mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_5.jpg?time=1613884377","video_url":"https://www.youtube.com/watch?v=yiTVkCy7DwA","date_added":"1613865600","last_modified":"1613884377","visibility":null,"is_top_course":"1","is_admin":"1","status":"active","course_overview_provider":"youtube","meta_keywords":"","meta_description":"","is_free_course":"1","id_from_another_server":"6","currency":"NRs","rating":0,"number_of_ratings":0,"instructor_name":"Rajendra Maharjan","total_enrollment":1,"shareable_link":"https://demo.mero.school/home/course/swift/5","completion":0,"total_number_of_lessons":9,"total_number_of_completed_lessons":0}]

class MyValidCourseResponse {
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  MyValidCourseResponse({bool? status, String? message, List<Data>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  MyValidCourseResponse.fromJson(dynamic json) {
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
      map["data"] = _data!.map((v) => v).toList();
    }
    return map;
  }
}

class Data {
  String? _course_id;
  String? _plan_exp_date;

  String? _id;
  String? _user_id;

  String? get course_id => _course_id;

  set course_id(String? value) {
    _course_id = value;
  }

  String? get plan_exp_date => _plan_exp_date;

  set plan_exp_date(String? value) {
    _plan_exp_date = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  Data.fromJson(dynamic json) {
    _course_id = json["course_id"];
    _plan_exp_date = json["plan_exp_date"];
    _user_id = json["user_id"];
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = _user_id;
    map["id"] = _id;
    map["course_id"] = _course_id;
    map["plan_exp_date"] = _plan_exp_date;
    return map;
  }

  String? get user_id => _user_id;

  set user_id(String? value) {
    _user_id = value;
  }
}
