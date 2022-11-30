import 'dart:async';
import 'dart:convert';

import 'package:mero_school/quiz/network/QuizApiProvider.dart';
import 'package:mero_school/quiz/request/get_question_sp.dart';
import 'package:mero_school/quiz/request/post_result_s_p.dart';
import 'package:mero_school/quiz/response/ResultRp.dart';
import 'package:mero_school/quiz/response/TopicResponse.dart';
import 'package:mero_school/quiz/response/questions.dart';

class QuizNetworkClient {
  QuizApiProvider _provider = QuizApiProvider();

  List<TopicResponse> modelTopicFromJson(List<dynamic> str) =>
      List<TopicResponse>.from(str.map((x) => TopicResponse.fromJson(x)));

  Future<List<TopicResponse>> fetchTopics(
      String userId, String fcm, bool isYesterday) async {
    print("===isYesterday: $isYesterday");

    String add = "";

    if (isYesterday == true) {
      add = "&yesterday=$isYesterday";
    }

    List<dynamic> response = await (_provider.getWithParams(
            "topics", "user_id=" + userId + "&fcm_token=$fcm$add"));
    List<TopicResponse> topics = [];
    // print("response" + "${response.length} : ${response.toString()}");

    topics = modelTopicFromJson(response);

    List<TopicResponse> changed = [];

    if (isYesterday) {
      changed = topics;
    } else {
      topics.forEach((element) {
        if (element.played != true) {
          changed.add(element);
        }
      });
    }

    return changed;
  }

  // List<WinnersResponse> modelWinnersFromJson(List<dynamic> str) => List<WinnersResponse>.from(str.map((x) => WinnersResponse.fromJson(x)));

  Future<ResultRp> fetchWinnner(String userId, String topicId) async {
    print("==fetchingWInners $topicId $userId");

    final response = await _provider.getWithParams(
        "results", "user_id=" + userId + "&topic_id=$topicId");
    return ResultRp.fromJson(response);
  }

  List<Questions> modelQuestionsFromJson(List<dynamic> str) =>
      List<Questions>.from(str.map((x) => Questions.fromJson(x)));

  Future<List<Questions>> fetchQuestions(GetQuestionSp getQuestionSp) async {
    var json = jsonEncode(getQuestionSp.toJson());
    List<dynamic> response = await (_provider.post("get_question/", json));
    var topics = [];
    topics = modelQuestionsFromJson(response);

    return topics as FutureOr<List<Questions>>;
  }

  Future<dynamic> postResult(List<PostResultSP> postResultSp) async {
    var json = jsonEncode(postResultSp);
    print("--ready to send: $json");
    final response = await _provider.postStatusCode("post_result/", json);
    return response;
  }

//

}
