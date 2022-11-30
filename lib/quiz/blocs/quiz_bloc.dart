import 'dart:async';

import 'package:mero_school/networking/Response.dart';

import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/quiz/network/quiz_network_clinet.dart';
import 'package:mero_school/quiz/request/get_question_sp.dart';
import 'package:mero_school/quiz/response/ResultRp.dart';
import 'package:mero_school/quiz/response/TopicResponse.dart';
import 'package:mero_school/quiz/response/questions.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class QuizBloc {
  QuizNetworkClient quizNetworkClient = QuizNetworkClient();

  StreamController? _topicController;
  StreamController? _questionController;
  late StreamController _winnersController;

  // bool _isStreaming;
  StreamSink<Response<List<TopicResponse>>> get dataSink =>
      _topicController!.sink as StreamSink<Response<List<TopicResponse>>>;
  Stream<Response<List<TopicResponse>>> get dataStream =>
      _topicController!.stream as Stream<Response<List<TopicResponse>>>;

  StreamSink<Response<List<Questions>>> get questionSink =>
      _questionController!.sink as StreamSink<Response<List<Questions>>>;
  Stream<Response<List<Questions>>> get questionStream =>
      _questionController!.stream as Stream<Response<List<Questions>>>;

  // bool _isStreaming;
  StreamSink<Response<List<Winner>>> get winnersSink =>
      _winnersController.sink as StreamSink<Response<List<Winner>>>;
  Stream<Response<List<Winner>>> get winnersStream =>
      _winnersController.stream as Stream<Response<List<Winner>>>;

  initBloc() {
    _topicController =
        StreamController<Response<List<TopicResponse>>>.broadcast();
    _questionController =
        StreamController<Response<List<Questions>>>.broadcast();
    _winnersController = StreamController<Response<List<Winner>>>.broadcast();
    // _isStreaming = true;
  }

  fetchTopic() async {
    dataSink.add(Response.loading('fetching quiz...'));

    try {
      var i = await Preference.getString(user_id);
      var f = await Preference.getString(fcm_token);

      var userId = Common.checkNullOrNot(i);
      var fcm = Common.checkNullOrNot(f);

      List<TopicResponse> model =
          await quizNetworkClient.fetchTopics(userId, fcm, false);

      if (model.isEmpty) {
        dataSink.add(Response.error("No quiz available"));
      } else {
        dataSink.add(Response.completed(model));
      }
    } catch (e) {
      dataSink.add(Response.error("${e.toString()}"));
      print(e);
    }
  }

  fetchWinners() async {
    winnersSink.add(Response.loading('fetching results...'));

    try {
      var i = await Preference.getString(user_id);
      var f = await Preference.getString(fcm_token);

      var userId = Common.checkNullOrNot(i);
      var fcm = Common.checkNullOrNot(f);

      List<TopicResponse> model =
          await quizNetworkClient.fetchTopics(userId, fcm, true);

      List<Winner> winners = [];

      print("Yesterday's Topic: " + model.length.toString());
      model.forEach((element) async {
        ResultRp w =
            await quizNetworkClient.fetchWinnner(userId, element.id.toString());

        //set message in each item
        w.winner!.forEach((win) {
          win.topic = element.name;
          win.message = w.message;
          win.yourAnswers = w.yourAnswers;
        });

        winners.addAll(w.winner!);

        if (winners.isEmpty) {
          winnersSink
              .add(Response.error("No results have been published yet."));
        } else {
          winnersSink.add(Response.completed(winners));
        }
      });

      if (model.isEmpty) {
        winnersSink.add(Response.error("No results have been published yet."));
      } else {
        winnersSink.add(Response.loading('fetching results...'));
      }
    } catch (e) {
      winnersSink.add(Response.error("${e.toString()}"));
      print(e);
    }
  }

  fetchQuestions(TopicResponse topic) async {
    questionSink.add(Response.loading('preparing questions...'));

    try {
      var userId =
          Common.checkNullOrNot(await Preference.getString(user_id));
      var fcm =
          Common.checkNullOrNot(await Preference.getString(fcm_token));
      var firstName =
          Common.checkNullOrNot(await Preference.getString(first_name));
      var lastName =
          Common.checkNullOrNot(await Preference.getString(last_name));
      var userEmail =
          Common.checkNullOrNot(await Preference.getString(user_email));

      GetQuestionSp getQsnSp = GetQuestionSp();
      getQsnSp.fullName = "$firstName $lastName";
      getQsnSp.topicId = topic.id;
      getQsnSp.topicName = topic.name;
      getQsnSp.userId = int.parse(userId);
      getQsnSp.userName = userEmail;

      List<Questions> model = await quizNetworkClient.fetchQuestions(getQsnSp);

      if (model.isEmpty) {
        questionSink.add(Response.error("No questions available"));
      } else {
        questionSink.add(Response.completed(model));
      }
    } catch (e) {
      questionSink.add(Response.error("${e.toString()}"));
      print(e);
    }
  }

  dispose() {
    _questionController?.close();
    _topicController?.close();
  }
}
