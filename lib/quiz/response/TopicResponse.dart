class TopicResponse {
  String? name;
  String? category;
  String? publishDate;
  String? description;
  String? adVideo;
  String? adImage;
  bool? played;
  bool? publishResult;
  int? id;
  int? showAdAfterXQuestion;
  String? prize;
  int? quizDuration;
  int? totalQuestions;
  int? adDuration;

  TopicResponse(
      {this.name,
      this.category,
      this.publishDate,
      this.description,
      this.adVideo,
      this.adImage,
      this.played,
      this.publishResult,
      this.id,
      this.showAdAfterXQuestion,
      this.prize,
      this.quizDuration,
      this.totalQuestions,
      this.adDuration});

  TopicResponse.fromJson(dynamic json) {
    this.name = json['name'];
    this.category = json['category'];
    this.publishDate = json['publish_date'];
    this.description = json['description'];
    this.adVideo = json['ad_video'];
    this.adImage = json['ad_image'];
    this.played = json['played'];
    this.publishResult = json['publish_result'];
    this.id = json['id'];
    this.showAdAfterXQuestion = json['show_ad_after_x_question'];
    this.prize = json['prize'];
    this.quizDuration = json['quiz_duration'];
    this.totalQuestions = json['total_questions'];
    this.adDuration = json['ad_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;
    data['publish_date'] = this.publishDate;
    data['description'] = this.description;
    data['ad_video'] = this.adVideo;
    data['ad_image'] = this.adImage;
    data['played'] = this.played;
    data['publish_result'] = this.publishResult;
    data['id'] = this.id;
    data['show_ad_after_x_question'] = this.showAdAfterXQuestion;
    data['prize'] = this.prize;
    data['quiz_duration'] = this.quizDuration;
    data['total_questions'] = this.totalQuestions;
    data['ad_duration'] = this.adDuration;
    return data;
  }
}
