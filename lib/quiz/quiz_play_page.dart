import 'package:flutter/material.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/quiz/blocs/play_bloc.dart';
import 'package:mero_school/quiz/response/TopicResponse.dart';
import 'package:mero_school/quiz/response/questions.dart';
import 'package:mero_school/quiz/widget/AdImageDialog.dart';
import 'package:mero_school/quiz/widget/AdVideoDialog.dart';
import 'package:mero_school/quiz/widget/confirmation_alert_dialog.dart';
import 'package:mero_school/quiz/widget/quiz_widget.dart';
import 'package:mero_school/quiz/widget/timmer_widget.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';

class QuizPlayPlay extends StatefulWidget {
  QuizPlayPlay({Key? key}) : super(key: key);

  @override
  _QuizPlayPlayState createState() {
    return _QuizPlayPlayState();
  }
}

class _QuizPlayPlayState extends State<QuizPlayPlay> {
  late PlayBloc playBloc;

  Map? _arguments;
  List<Questions>? questions;
  TopicResponse? topic;

  final ValueNotifier<bool> _playNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    playBloc = PlayBloc();
    super.initState();
    playBloc.initBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var isPlaying = true;

  void _callback(String questionNumber, String option) {
    print("== $questionNumber $option");

    playBloc.updateAnswer(questionNumber, option);
  }

  @override
  void didChangeDependencies() {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    questions = _arguments!["questions"];
    topic = _arguments!["topic"];

    if (topic!.adImage != null) {
      var provider = Image.network(topic!.adImage!);
      precacheImage(provider.image, context).then((value) => {
            // print("success:")
          });
    }

    super.didChangeDependencies();
  }

  void showVideoDialog(String? url) {
    _playNotifier.value = false;

    var dialog = AdVideoPlayer(
        icon: url,
        onTimerDone: () {
          _playNotifier.value = true;
          playBloc.nextAfterAd();
        });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
      barrierDismissible: false,
    );
  }

  void showImageAdDialog(String? url, int? duration) {
    // setState(() {
    //   isPlaying = false;
    // });

    // playBloc.pause();

    _playNotifier.value = false;

    var dialog = AdImageDialog(url, duration, () {
      // setState(() {
      //   isPlaying = true;
      // });

      // playBloc.play();

      _playNotifier.value = true;
      playBloc.nextAfterAd();
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
        barrierDismissible: false);
  }

  void onBackPressed() {
    print("isPlaying $isPlaying");

    if (isPlaying) {
      //
      ConfirmationDialog confirmationDialog = ConfirmationDialog(
          "Are you sure ?", "You won't be able to continue this quiz.", "Exit",
          () {
        playBloc.submit(topic!);

        //auto submit result
        Navigator.of(context).pop();
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return confirmationDialog;
        },
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isPlaying != true,
      child: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close_outlined,
                        color: HexColor.fromHex(bottomNavigationEnabledState)),
                    onPressed: () => onBackPressed(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text("${topic!.name}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: HexColor.fromHex(colorBlue),
                                fontSize: 22)),
                        Text("${topic!.publishDate}",
                            style: TextStyle(
                                color: HexColor.fromHex(darkNavyBlue))),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _playNotifier,
                    builder: (context, value, child) {
                      isPlaying = value;
                      return TimmerWidget(
                        time: topic!.quizDuration,
                        isPlaying: value,
                        onTimerDone: () {
                          // print("timmer---done");

                          // setState(() {
                          //   isPlaying = false;
                          // });

                          // playBloc.pause();

                          _playNotifier.value = false;

                          playBloc.submit(topic!);
                        },
                      );
                    },
                  ),
                ],
              ),
              StreamBuilder<Response<int>>(
                  stream: playBloc.dataStream,
                  initialData: Response.completed(0),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var index = snapshot.data!.data!;

                      if (index >= 0) {
                        if (index < questions!.length) {
                          return QuizQuestionModel(
                            question: questions![index],
                            callback: _callback,
                          );
                        } else {
                          return QuizEmpty(
                            message: "",
                            loading: false,
                          );
                        }
                      } else {
                        if (index == -3) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (topic!.adVideo != null &&
                                topic!.adVideo!.isNotEmpty) {
                              // showVideoDialog("https://static.videezy.com/system/resources/previews/000/050/056/original/High-Tech-Tunnel.mp4");
                              showVideoDialog(topic!.adVideo);
                            } else {
                              showImageAdDialog(
                                  topic!.adImage, topic!.adDuration);
                            }
                          });
                        }

                        return QuizEmpty(
                            message: snapshot.data!.message,
                            loading: (index == -1) ? true : false);
                      }
                    } else {
                      return Container();
                    }
                  }),
              StreamBuilder<Response<int>>(
                  stream: playBloc.dataStream,
                  initialData: Response.completed(0),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.data! >= 0) {
                        var index = snapshot.data!.data! + 1;
                        var total = questions!.length;

                        return QuizProgress(
                          index: index,
                          total: total,
                          next: () {
                            var qsnNumber =
                                questions![index - 1].questionNumber;

                            print("qsnNumber $qsnNumber");

                            if (playBloc.contains(qsnNumber)) {
                              playBloc.next(topic!);
                            } else {
                              //

                              ToastHelper.showShort("Please select an option.");
                            }
                          },
                          submit: () {
                            var qsnNumber =
                                questions![index - 1].questionNumber;

                            print("qsnNumber $qsnNumber");

                            if (playBloc.contains(qsnNumber)) {
                              // setState(() {
                              //   isPlaying = false;
                              // });

                              // playBloc.pause();

                              _playNotifier.value = false;

                              playBloc.next(topic!);
                              playBloc.submit(topic!);
                            } else {
                              //

                              ToastHelper.showShort("Please select an option.");
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      )),
    );

    // return StreamBuilder<bool>(
    //   initialData: true,
    //   stream: playBloc.playingStream,
    //   builder: (context, snapshot) {
    //
    //
    //     if(snapshot.hasData){
    //
    //       print("Data: isPlaying: ${snapshot.data}");
    //
    //       isPlaying = snapshot.data;
    //
    //
    //
    //
    //     }else{
    //
    //       return Scaffold(
    //         body: PlaceHolderLoadingVertical() ,
    //
    //       );
    //
    //     }
    //
    //
    //   }
    // );
  }
}
