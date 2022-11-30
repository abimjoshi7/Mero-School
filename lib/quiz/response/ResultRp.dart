/// winner : [{"user_id":207,"full_name":"Niraj Tamang","correct_answer_count":0},{"user_id":46,"full_name":"Nirajs Tamangs","correct_answer_count":0},{"user_id":53,"full_name":"HELLO DEV","correct_answer_count":0}]
/// your_answers : [{"question_number":"1","question":"asdfasdf","answer":"sd","correct_option":"a","your_answer":"da","your_option":"c"}]
/// message : "asdf"

class ResultRp {
  List<Winner>? _winner;
  List<Your_answers>? _yourAnswers;
  String? _message;

  List<Winner>? get winner => _winner;
  List<Your_answers>? get yourAnswers => _yourAnswers;
  String? get message => _message;

  ResultRp(
      {List<Winner>? winner,
      List<Your_answers>? yourAnswers,
      String? message}) {
    _winner = winner;
    _yourAnswers = yourAnswers;
    _message = message;
  }

  ResultRp.fromJson(dynamic json) {
    if (json['winner'] != null) {
      _winner = [];
      json['winner'].forEach((v) {
        _winner!.add(Winner.fromJson(v));
      });
    }
    if (json['your_answers'] != null) {
      _yourAnswers = [];
      json['your_answers'].forEach((v) {
        _yourAnswers!.add(Your_answers.fromJson(v));
      });
    }
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_winner != null) {
      map['winner'] = _winner!.map((v) => v.toJson()).toList();
    }
    if (_yourAnswers != null) {
      map['your_answers'] = _yourAnswers!.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }
}

/// question_number : "1"
/// question : "asdfasdf"
/// answer : "sd"
/// correct_option : "a"
/// your_answer : "da"
/// your_option : "c"

class Your_answers {
  String? _questionNumber;
  String? _question;
  String? _answer;
  String? _correctOption;
  String? _yourAnswer;
  String? _yourOption;

  String? get questionNumber => _questionNumber;
  String? get question => _question;
  String? get answer => _answer;
  String? get correctOption => _correctOption;
  String? get yourAnswer => _yourAnswer;
  String? get yourOption => _yourOption;

  Your_answers(
      {String? questionNumber,
      String? question,
      String? answer,
      String? correctOption,
      String? yourAnswer,
      String? yourOption}) {
    _questionNumber = questionNumber;
    _question = question;
    _answer = answer;
    _correctOption = correctOption;
    _yourAnswer = yourAnswer;
    _yourOption = yourOption;
  }

  Your_answers.fromJson(dynamic json) {
    _questionNumber = json['question_number'];
    _question = json['question'];
    _answer = json['answer'];
    _correctOption = json['correct_option'];
    _yourAnswer = json['your_answer'];
    _yourOption = json['your_option'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['question_number'] = _questionNumber;
    map['question'] = _question;
    map['answer'] = _answer;
    map['correct_option'] = _correctOption;
    map['your_answer'] = _yourAnswer;
    map['your_option'] = _yourOption;
    return map;
  }
}

/// user_id : 207
/// full_name : "Niraj Tamang"
/// correct_answer_count : 0

class Winner {
  int? _userId;
  String? _fullName;
  int? _correctAnswerCount;

  String? _message;
  String? _topic;
  List<Your_answers>? _yourAnswers;

  List<Your_answers>? get yourAnswers => _yourAnswers;

  set yourAnswers(List<Your_answers>? value) {
    _yourAnswers = value;
  }

  String? get message => _message;

  set message(String? value) {
    _message = value;
  }

  set topic(String? value) {
    _topic = value;
  }

  String? get topic => _topic;

  int? get userId => _userId;
  String? get fullName => _fullName;
  int? get correctAnswerCount => _correctAnswerCount;

  Winner({int? userId, String? fullName, int? correctAnswerCount}) {
    _userId = userId;
    _fullName = fullName;
    _correctAnswerCount = correctAnswerCount;
  }

  Winner.fromJson(dynamic json) {
    _userId = json['user_id'];
    _fullName = json['full_name'];
    _correctAnswerCount = json['correct_answer_count'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['full_name'] = _fullName;
    map['correct_answer_count'] = _correctAnswerCount;
    return map;
  }
}
