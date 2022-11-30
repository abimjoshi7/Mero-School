/// answer : "a"
/// fcm_token : "e21ZF4T9RJCYpRCATJUwpR:APA91bErjFr7RQJ4-2B_T9_na104ZzIHwpWqzwckCrdClpJHxWEfutgEM-sxYkeHSBJi7HWUHbpHrIWRJsEyeu_N-Qw90GzFdSShzST-pMaUqUqoRMcA8alYjyGt7mvKXYdp4FwQUIWl"
/// full_name : "Nirajs Tamangs"
/// question_number : "1"
/// topic_id : 2
/// topic_name : "Demo"
/// user_id : 46
/// user_name : "niraz.syangden@gmail.com"

class PostResultSP {
  String? _answer;
  String? _fcmToken;
  String? _fullName;
  String? _questionNumber;
  int? _topicId;
  String? _topicName;
  int? _userId;
  String? _userName;

  String? get answer => _answer;
  String? get fcmToken => _fcmToken;
  String? get fullName => _fullName;
  String? get questionNumber => _questionNumber;
  int? get topicId => _topicId;
  String? get topicName => _topicName;
  int? get userId => _userId;
  String? get userName => _userName;

  set answer(String? value) {
    _answer = value;
  }

  PostResultSP(
      {String? answer,
      String? fcmToken,
      String? fullName,
      String? questionNumber,
      int? topicId,
      String? topicName,
      int? userId,
      String? userName}) {
    _answer = answer;
    _fcmToken = fcmToken;
    _fullName = fullName;
    _questionNumber = questionNumber;
    _topicId = topicId;
    _topicName = topicName;
    _userId = userId;
    _userName = userName;
  }

  PostResultSP.fromJson(dynamic json) {
    _answer = json['answer'];
    _fcmToken = json['fcm_token'];
    _fullName = json['full_name'];
    _questionNumber = json['question_number'];
    _topicId = json['topic_id'];
    _topicName = json['topic_name'];
    _userId = json['user_id'];
    _userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (_answer != null && _answer!.isNotEmpty) {
      map['answer'] = _answer;
    }

    if (questionNumber != null && questionNumber!.isNotEmpty) {
      map['question_number'] = _questionNumber;
    }

    map['fcm_token'] = _fcmToken;
    map['full_name'] = _fullName;
    map['topic_id'] = _topicId;
    map['topic_name'] = _topicName;
    map['user_id'] = _userId;
    map['user_name'] = _userName;
    return map;
  }

  set fcmToken(String? value) {
    _fcmToken = value;
  }

  set fullName(String? value) {
    _fullName = value;
  }

  set questionNumber(String? value) {
    _questionNumber = value;
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
