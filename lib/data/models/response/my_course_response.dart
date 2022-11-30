/// status : true
/// message : "course details"
/// data : [{"id":"2","course_type":"choose_course_title","title":"Php Tutorial","original_title":"php tutorial","short_description":"Free Course","description":"<p>This is free course. </p>","outcomes":["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."],"language":"english","category_id":"1","sub_category_id":"2","section":"[]","requirements":["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."],"price":"Free","discount_flag":null,"discounted_price":"0","level":"beginner","user_id":"1","thumbnail":"https://demo.mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_2.jpg?time=","video_url":"https://www.youtube.com/watch?v=ABjCVTBnO_U","date_added":"1613606400","last_modified":null,"visibility":null,"is_top_course":"1","is_admin":"1","status":"active","course_overview_provider":"youtube","meta_keywords":"","meta_description":"","is_free_course":"1","id_from_another_server":"3","currency":"NRs","rating":0,"number_of_ratings":0,"instructor_name":"Rajendra Maharjan","total_enrollment":1,"shareable_link":"https://demo.mero.school/home/course/php-tutorial/2","completion":0,"total_number_of_lessons":41,"total_number_of_completed_lessons":0},{"id":"5","course_type":"add_new_course_title","title":"Swift ","original_title":"Swift ","short_description":"Swift","description":"<p>   A prograaming <br></p>","outcomes":["Introduction of Optional Mathematics."],"language":"english","category_id":"5","sub_category_id":"6","section":"[]","requirements":["Basic of Office Management and Account"],"price":"Free","discount_flag":null,"discounted_price":"0","level":"advanced","user_id":"1","thumbnail":"https://demo.mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_5.jpg?time=1613884377","video_url":"https://www.youtube.com/watch?v=yiTVkCy7DwA","date_added":"1613865600","last_modified":"1613884377","visibility":null,"is_top_course":"1","is_admin":"1","status":"active","course_overview_provider":"youtube","meta_keywords":"","meta_description":"","is_free_course":"1","id_from_another_server":"6","currency":"NRs","rating":0,"number_of_ratings":0,"instructor_name":"Rajendra Maharjan","total_enrollment":1,"shareable_link":"https://demo.mero.school/home/course/swift/5","completion":0,"total_number_of_lessons":9,"total_number_of_completed_lessons":0}]

class MyCourseResponse {
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  MyCourseResponse({bool? status, String? message, List<Data>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  MyCourseResponse.fromJson(dynamic json) {
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

/// id : "2"
/// course_type : "choose_course_title"
/// title : "Php Tutorial"
/// original_title : "php tutorial"
/// short_description : "Free Course"
/// description : "<p>This is free course. </p>"
/// outcomes : ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."]
/// language : "english"
/// category_id : "1"
/// sub_category_id : "2"
/// section : "[]"
/// requirements : ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."]
/// price : "Free"
/// discount_flag : null
/// discounted_price : "0"
/// level : "beginner"
/// user_id : "1"
/// thumbnail : "https://demo.mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_2.jpg?time="
/// video_url : "https://www.youtube.com/watch?v=ABjCVTBnO_U"
/// date_added : "1613606400"
/// last_modified : null
/// visibility : null
/// is_top_course : "1"
/// is_admin : "1"
/// status : "active"
/// course_overview_provider : "youtube"
/// meta_keywords : ""
/// meta_description : ""
/// is_free_course : "1"
/// id_from_another_server : "3"
/// currency : "NRs"
/// rating : 0
/// number_of_ratings : 0
/// instructor_name : "Rajendra Maharjan"
/// total_enrollment : 1
/// shareable_link : "https://demo.mero.school/home/course/php-tutorial/2"
/// completion : 0
/// total_number_of_lessons : 41
/// total_number_of_completed_lessons : 0

class Data {
  String? _id;
  String? _courseType;
  String? _title;
  String? _originalTitle;
  String? _shortDescription;
  String? _description;
  List<String>? _outcomes;
  String? _language;
  String? _categoryId;
  String? _subCategoryId;
  String? _section;
  List<String>? _requirements;
  String? _price;
  dynamic _discountFlag;
  String? _discountedPrice;
  String? _level;
  String? _userId;
  String? _thumbnail;
  String? _videoUrl;
  String? _dateAdded;
  dynamic _lastModified;
  dynamic _visibility;
  String? _isTopCourse;
  String? _isAdmin;
  String? _status;
  String? _courseOverviewProvider;
  String? _metaKeywords;
  String? _metaDescription;
  String? _isFreeCourse;
  String? _idFromAnotherServer;
  String? _currency;
  dynamic _rating;
  int? _numberOfRatings;
  String? _instructorName;
  int? _totalEnrollment;
  String? _shareableLink;
  int? _completion;
  String? _expDate;
  int? _totalNumberOfLessons;
  int? _totalNumberOfCompletedLessons;
  String? _appleProductId;
  bool? _certificateStatus;

  String? get id => _id;
  String? get courseType => _courseType;
  String? get title => _title;
  String? get originalTitle => _originalTitle;
  String? get shortDescription => _shortDescription;
  String? get description => _description;
  List<String>? get outcomes => _outcomes;
  String? get language => _language;
  String? get categoryId => _categoryId;
  String? get subCategoryId => _subCategoryId;
  String? get section => _section;
  List<String>? get requirements => _requirements;
  String? get price => _price;
  dynamic get discountFlag => _discountFlag;
  String? get discountedPrice => _discountedPrice;
  String? get level => _level;
  String? get userId => _userId;
  String? get thumbnail => _thumbnail;
  String? get videoUrl => _videoUrl;
  String? get dateAdded => _dateAdded;
  dynamic get lastModified => _lastModified;
  dynamic get visibility => _visibility;
  String? get isTopCourse => _isTopCourse;
  String? get isAdmin => _isAdmin;
  String? get status => _status;
  String? get courseOverviewProvider => _courseOverviewProvider;
  String? get metaKeywords => _metaKeywords;
  String? get metaDescription => _metaDescription;
  String? get isFreeCourse => _isFreeCourse;
  String? get idFromAnotherServer => _idFromAnotherServer;
  String? get currency => _currency;
  bool? get certificateStatus => _certificateStatus;

  dynamic get rating => _rating;
  int? get numberOfRatings => _numberOfRatings;
  String? get instructorName => _instructorName;
  int? get totalEnrollment => _totalEnrollment;
  String? get shareableLink => _shareableLink;
  int? get completion => _completion;
  String? get expDate => _expDate;
  String? get appleProductId => _appleProductId;
  int? get totalNumberOfLessons => _totalNumberOfLessons;
  int? get totalNumberOfCompletedLessons => _totalNumberOfCompletedLessons;

  Data(
      {String? id,
      String? courseType,
      String? title,
      String? originalTitle,
      String? shortDescription,
      String? description,
      List<String>? outcomes,
      String? language,
      String? categoryId,
      String? subCategoryId,
      String? section,
      List<String>? requirements,
      String? price,
      dynamic discountFlag,
      String? discountedPrice,
      String? level,
      String? userId,
      String? thumbnail,
      String? videoUrl,
      String? dateAdded,
      dynamic lastModified,
      dynamic visibility,
      String? isTopCourse,
      String? isAdmin,
      String? status,
      String? courseOverviewProvider,
      String? metaKeywords,
      String? metaDescription,
      String? isFreeCourse,
      String? idFromAnotherServer,
      String? currency,
      dynamic rating,
      int? numberOfRatings,
      String? instructorName,
      int? totalEnrollment,
      String? shareableLink,
      int? completion,
      String? expDate,
      int? totalNumberOfLessons,
      int? totalNumberOfCompletedLessons,
      String? appleProductId,
      bool? certificateStatus}) {
    _id = id;
    _courseType = courseType;
    _title = title;
    _originalTitle = originalTitle;
    _shortDescription = shortDescription;
    _description = description;
    _outcomes = outcomes;
    _language = language;
    _categoryId = categoryId;
    _subCategoryId = subCategoryId;
    _section = section;
    _requirements = requirements;
    _price = price;
    _discountFlag = discountFlag;
    _discountedPrice = discountedPrice;
    _level = level;
    _userId = userId;
    _thumbnail = thumbnail;
    _videoUrl = videoUrl;
    _dateAdded = dateAdded;
    _lastModified = lastModified;
    _visibility = visibility;
    _certificateStatus = certificateStatus;
    _isTopCourse = isTopCourse;
    _isAdmin = isAdmin;
    _status = status;
    _courseOverviewProvider = courseOverviewProvider;
    _metaKeywords = metaKeywords;
    _metaDescription = metaDescription;
    _isFreeCourse = isFreeCourse;
    _idFromAnotherServer = idFromAnotherServer;
    _currency = currency;
    _rating = rating;
    _numberOfRatings = numberOfRatings;
    _instructorName = instructorName;
    _totalEnrollment = totalEnrollment;
    _shareableLink = shareableLink;
    _completion = completion;
    _expDate = expDate;
    _totalNumberOfLessons = totalNumberOfLessons;
    _totalNumberOfCompletedLessons = totalNumberOfCompletedLessons;
    _appleProductId = appleProductId;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _courseType = json["course_type"];
    _title = json["title"];
    _originalTitle = json["original_title"];
    _shortDescription = json["short_description"];
    _description = json["description"];
    _outcomes = json["outcomes"] != null ? json["outcomes"].cast<String>() : [];
    _language = json["language"];
    _categoryId = json["category_id"];
    _subCategoryId = json["sub_category_id"];
    _section = json["section"];
    _requirements =
        json["requirements"] != null ? json["requirements"].cast<String>() : [];
    _price = json["price"];
    _discountFlag = json["discount_flag"];
    _discountedPrice = json["discounted_price"];
    _level = json["level"];
    _userId = json["user_id"];
    _thumbnail = json["thumbnail"];
    _videoUrl = json["video_url"];
    _dateAdded = json["date_added"];
    _lastModified = json["last_modified"];
    _visibility = json["visibility"];
    _isTopCourse = json["is_top_course"];
    _isAdmin = json["is_admin"];
    _status = json["status"];
    _courseOverviewProvider = json["course_overview_provider"];
    _metaKeywords = json["meta_keywords"];
    _metaDescription = json["meta_description"];
    _isFreeCourse = json["is_free_course"];
    _idFromAnotherServer = json["id_from_another_server"];
    _currency = json["currency"];
    _rating = json["rating"];
    _numberOfRatings = json["number_of_ratings"];
    _instructorName = json["instructor_name"];
    _totalEnrollment = json["total_enrollment"];
    _shareableLink = json["shareable_link"];
    _expDate = json["exp_date"];
    _completion = json["completion"];
    _totalNumberOfLessons = json["total_number_of_lessons"];
    _totalNumberOfCompletedLessons = json["total_number_of_completed_lessons"];
    _appleProductId = json["appleProductId"];
    _certificateStatus = json["certificateStatus"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["course_type"] = _courseType;
    map["title"] = _title;
    map["original_title"] = _originalTitle;
    map["short_description"] = _shortDescription;
    map["description"] = _description;
    map["outcomes"] = _outcomes;
    map["language"] = _language;
    map["category_id"] = _categoryId;
    map["sub_category_id"] = _subCategoryId;
    map["section"] = _section;
    map["requirements"] = _requirements;
    map["price"] = _price;
    map["discount_flag"] = _discountFlag;
    map["discounted_price"] = _discountedPrice;
    map["level"] = _level;
    map["user_id"] = _userId;
    map["thumbnail"] = _thumbnail;
    map["video_url"] = _videoUrl;
    map["date_added"] = _dateAdded;
    map["last_modified"] = _lastModified;
    map["visibility"] = _visibility;
    map["is_top_course"] = _isTopCourse;
    map["is_admin"] = _isAdmin;
    map["status"] = _status;
    map["course_overview_provider"] = _courseOverviewProvider;
    map["meta_keywords"] = _metaKeywords;
    map["meta_description"] = _metaDescription;
    map["is_free_course"] = _isFreeCourse;
    map["id_from_another_server"] = _idFromAnotherServer;
    map["currency"] = _currency;
    map["rating"] = _rating;
    map["number_of_ratings"] = _numberOfRatings;
    map["instructor_name"] = _instructorName;
    map["total_enrollment"] = _totalEnrollment;
    map["shareable_link"] = _shareableLink;
    map["exp_date"] = _expDate;
    map["completion"] = _completion;
    map["total_number_of_lessons"] = _totalNumberOfLessons;
    map["total_number_of_completed_lessons"] = _totalNumberOfCompletedLessons;
    map["appleProductId"] = _appleProductId;
    return map;
  }
}
