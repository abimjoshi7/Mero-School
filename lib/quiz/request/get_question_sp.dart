/// full_name : "Niraj Tamang"
/// topic_id : 2
/// topic_name : "asdfffffffffffffffffffffffffffffffsdsd"
/// user_id : 207
/// user_name : "rajesh@podamibenepal.com"

class GetQuestionSp {
  String? _fullName;
  int? _topicId;
  String? _topicName;
  int? _userId;
  String? _userName;

  String? get fullName => _fullName;
  int? get topicId => _topicId;
  String? get topicName => _topicName;
  int? get userId => _userId;
  String? get userName => _userName;

  set fullName(String? value) {
    _fullName = value;
  }

  GetQuestionSp(
      {String? fullName,
      int? topicId,
      String? topicName,
      int? userId,
      String? userName}) {
    _fullName = fullName;
    _topicId = topicId;
    _topicName = topicName;
    _userId = userId;
    _userName = userName;
  }

  GetQuestionSp.fromJson(dynamic json) {
    _fullName = json['full_name'];
    _topicId = json['topic_id'];
    _topicName = json['topic_name'];
    _userId = json['user_id'];
    _userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['full_name'] = _fullName;
    map['topic_id'] = _topicId;
    map['topic_name'] = _topicName;
    map['user_id'] = _userId;
    map['user_name'] = _userName;
    return map;
  }

  set topicId(int? value) {
    _topicId = value;
  }

  set topicName(String? value) {
    _topicName = value;
  }

  set userId(int? value) {
    _userId = value;
  }

  set userName(String? value) {
    _userName = value;
  }
}
