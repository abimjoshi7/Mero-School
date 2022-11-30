/// topic_name : "test"
/// topic_description : "asdf"
/// question_number : "1"
/// question : "jgjkhbjkl"
/// answers : [{"label":"a","answer":",nkljjklj"},{"label":"b","answer":""},{"label":"c","answer":""},{"label":"d","answer":""}]
/// correct_answer : "a"

class Questions {
  String? _topicName;
  String? _topicDescription;
  String? _questionNumber;
  String? _question;
  List<Answers>? _answers;
  String? _correctAnswer;

  String? get topicName => _topicName;
  String? get topicDescription => _topicDescription;
  String? get questionNumber => _questionNumber;
  String? get question => _question;
  List<Answers>? get answers => _answers;
  String? get correctAnswer => _correctAnswer;

  set topicName(String? value) {
    _topicName = value;
  }

  Questions(
      {String? topicName,
      String? topicDescription,
      String? questionNumber,
      String? question,
      List<Answers>? answers,
      String? correctAnswer}) {
    _topicName = topicName;
    _topicDescription = topicDescription;
    _questionNumber = questionNumber;
    _question = question;
    _answers = answers;
    _correctAnswer = correctAnswer;
  }

  Questions.fromJson(dynamic json) {
    _topicName = json['topic_name'];
    _topicDescription = json['topic_description'];
    _questionNumber = json['question_number'];
    _question = json['question'];
    if (json['answers'] != null) {
      _answers = [];
      json['answers'].forEach((v) {
        _answers!.add(Answers.fromJson(v));
      });
    }
    _correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['topic_name'] = _topicName;
    map['topic_description'] = _topicDescription;
    map['question_number'] = _questionNumber;
    map['question'] = _question;
    if (_answers != null) {
      map['answers'] = _answers!.map((v) => v.toJson()).toList();
    }
    map['correct_answer'] = _correctAnswer;
    return map;
  }

  set topicDescription(String? value) {
    _topicDescription = value;
  }

  set questionNumber(String? value) {
    _questionNumber = value;
  }

  set question(String? value) {
    _question = value;
  }

  set answers(List<Answers>? value) {
    _answers = value;
  }

  set correctAnswer(String? value) {
    _correctAnswer = value;
  }
}

/// label : "a"
/// answer : ",nkljjklj"

class Answers {
  String? _label;
  String? _answer;

  String? get label => _label;
  String? get answer => _answer;

  Answers({String? label, String? answer}) {
    _label = label;
    _answer = answer;
  }

  Answers.fromJson(dynamic json) {
    _label = json['label'];
    _answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['label'] = _label;
    map['answer'] = _answer;
    return map;
  }
}
