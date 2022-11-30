// ignore_for_file: unnecessary_getters_setters, non_constant_identifier_names

class TagMeta {
  String? _enrollement;

  String? get enrollement => _enrollement;

  set enrollement(String? enrollement) {
    _enrollement = enrollement;
  }

  String? _course_created_by;

  String? get course_created_by => _course_created_by;

  set course_created_by(String? courseCreatedBy) {
    _course_created_by = courseCreatedBy;
  }

  String? _course_id;

  String? get course_id => _course_id;

  set course_id(String? courseId) {
    _course_id = courseId;
  }

  String? _percentage_completed;

  String? get percentage_completed => _percentage_completed;

  set percentage_completed(String? percentageCompleted) {
    _percentage_completed = percentageCompleted;
  }

  String? _course_name;

  String? get course_name => _course_name;

  set course_name(String? courseName) {
    _course_name = courseName;
  }

  String? _category_id;

  String? get category_id => _category_id;

  set category_id(String? categoryId) {
    _category_id = categoryId;
  }

  String? _category_name;

  String? get category_name => _category_name;

  set category_name(String? categoryName) {
    _category_name = categoryName;
  }

  String? _course_level;

  String? get course_level => _course_level;

  set course_level(String? courseLevel) {
    _course_level = courseLevel;
  }

  String? _price;

  String? get price => _price;

  set price(String? price) {
    _price = price;
  }

  String? _discount;

  String? get discount => _discount;

  set discount(String? discount) {
    _discount = discount;
  }

  String? _course_time_duration;

  String? get course_time_duration => _course_time_duration;

  set course_time_duration(String? courseTimeDuration) {
    _course_time_duration = courseTimeDuration;
  }

  String? course_expiry_date;

  @override
  String toString() {
    return 'TagMeta{_course_id: $_course_id, _percentage_completed: $_percentage_completed, _course_name: $_course_name, _category_id: $_category_id, _category_name: $_category_name, _course_level: $_course_level, _price: $_price, _discount: $_discount, _course_time_duration: $_course_time_duration, course_expiry_date: $course_expiry_date}';
  }

  void getDefault(Map<dynamic, dynamic> arguments) {
    this.course_id = getValueFromArgument(arguments, 'course_id');
    this.course_name = getValueFromArgument(arguments, 'title');
    this.category_id = getValueFromArgument(arguments, 'category_id');
    this.category_name = getValueFromArgument(arguments, 'category_name');
    this.course_level = getValueFromArgument(arguments, 'level');
    this.price = getValueFromArgument(arguments, 'price');
    this.discount = getValueFromArgument(arguments, 'discount');
    this.course_time_duration =
        getValueFromArgument(arguments, 'video_duration');
    this.course_expiry_date =
        getValueFromArgument(arguments, 'course_expiry_date');
    this.enrollement = getValueFromArgument(arguments, 'enrollment');
  }

  dynamic getValueFromArgument(Map<dynamic, dynamic> _arguments, String key) {
    if (_arguments.containsKey(key) && _arguments[key] != null) {
      return _arguments[key];
    }
    return '';
  }
}

class PlanTags {
  int? _planId;
  int? _packageId;
  String? _planName;
  String? _packageName;
  bool? _enrolledStatus;

  int? _validity;
  int? _price;
  int? _numOfCourse;

  int? get numOfCourse => _numOfCourse;

  set numOfCourse(int? value) {
    _numOfCourse = value;
  }

  int? get planId => _planId;

  set planId(int? value) {
    _planId = value;
  }

  int? get packageId => _packageId;

  set packageId(int? value) {
    _packageId = value;
  }

  String? get planName => _planName;

  set planName(String? value) {
    _planName = value;
  }

  String? get packageName => _packageName;

  set packageName(String? value) {
    _packageName = value;
  }

  bool? get enrolledStatus => _enrolledStatus;

  set enrolledStatus(bool? value) {
    _enrolledStatus = value;
  }

  int? get price => _price;

  set price(int? value) {
    _price = value;
  }

  int? get validity => _validity;

  set validity(int? value) {
    _validity = value;
  }
}
