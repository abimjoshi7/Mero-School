import 'dart:async';
import 'dart:collection';

import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/quiz/network/quiz_network_clinet.dart';
import 'package:mero_school/quiz/request/post_result_s_p.dart';
import 'package:mero_school/quiz/response/TopicResponse.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class PlayBloc extends BaseBloc {
  QuizNetworkClient quizNetworkClient = QuizNetworkClient();

  late StreamController _playController;

  StreamSink<Response<int>> get dataSink =>
      _playController.sink as StreamSink<Response<int>>;
  Stream<Response<int>> get dataStream =>
      _playController.stream as Stream<Response<int>>;

  late StreamController _playingController;

  StreamSink<bool> get playingSink =>
      _playingController.sink as StreamSink<bool>;
  Stream<bool> get playingStream => _playingController.stream as Stream<bool>;

  int index = 0;

  initBloc() {
    _playController = StreamController<Response<int>>.broadcast();
    _playingController = StreamController<bool>.broadcast();
  }

  HashMap userAnswers = new HashMap<String, String>();

  updateAnswer(String questionNumber, String option) {
    userAnswers[questionNumber] = option;
  }

  bool contains(String? questions) {
    print("==inmap=== ${userAnswers.toString()}");
    return userAnswers.containsKey(questions);
  }

  int? saved;

  next(TopicResponse topic) {
    var next = ++index;

    if (topic.adImage != null &&
        topic.adImage!.isNotEmpty &&
        topic.showAdAfterXQuestion == next) {
      saved = next;
      dataSink
          .add(Response.completedDataMessage(-3, "Please wait for some time."));
    } else if (topic.adVideo != null &&
        topic.adVideo!.isNotEmpty &&
        topic.showAdAfterXQuestion == next) {
      saved = next;
      dataSink
          .add(Response.completedDataMessage(-3, "Please wait for some time."));
    } else {
      dataSink.add(Response.completedDataMessage(next, ""));
    }
  }

  nextAfterAd() {
    dataSink.add(Response.completedDataMessage(saved, ""));
  }

  play() {
    playingSink.add(true);
  }

  pause() {
    playingSink.add(false);
  }

  submit(TopicResponse topic) async {
    dataSink
        .add(Response.completedDataMessage(-1, "submitting your response.."));

    print("todo submit answer ");
    List<PostResultSP> postResultList = [];
    print("${userAnswers.toString()}");

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

    bool isAtempt = topic.totalQuestions == userAnswers.length;

    userAnswers.forEach((key, value) {
      PostResultSP postResultSP = PostResultSP();
      postResultSP.answer = value;
      postResultSP.fcmToken = fcm;
      postResultSP.questionNumber = key;
      postResultSP.topicId = topic.id;
      postResultSP.topicName = topic.name;
      postResultSP.userName = userEmail;
      postResultSP.userId = int.parse(userId);
      postResultSP.fullName = "$firstName $lastName";
      postResultList.add(postResultSP);
    });

    if (postResultList.isEmpty) {
      PostResultSP postResultSP = PostResultSP();
      postResultSP.fcmToken = fcm;
      postResultSP.topicId = topic.id;
      postResultSP.topicName = topic.name;
      postResultSP.userName = user_email;
      postResultSP.userId = int.parse(userId);
      postResultSP.fullName = "$firstName $lastName";

      postResultList.add(postResultSP);
    }

    // questionSink.add(Response.loading('preparing questions...'));

    try {
      final model = await quizNetworkClient.postResult(postResultList);
      print("==== --- $model");

      if (isAtempt) {
        dataSink.add(Response.completedDataMessage(-2,
            "Thank your for your participation. Your answers have been submitted successfully!"));
      } else {
        dataSink.add(Response.completedDataMessage(-2,
            "Unfortunately your allocated time for the quiz expired. You can no longer play quiz today!"));
      }
    } catch (e) {
      dataSink.add(Response.completedDataMessage(-2, "${e.toString()}"));
      print(e);
    }

    // userAnswers
  }
}
