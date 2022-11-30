import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/quiz/blocs/quiz_bloc.dart';
import 'package:mero_school/quiz/response/ResultRp.dart';
import 'package:mero_school/quiz/response/TopicResponse.dart';
import 'package:mero_school/quiz/widget/congrats_alert_dialog.dart';
import 'package:mero_school/quiz/widget/winners_widget.dart';
import 'package:mero_school/utils/animation_image.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class QuizResultPage extends StatefulWidget {
  QuizResultPage({Key? key}) : super(key: key);

  @override
  _QuizResultPageState createState() {
    return _QuizResultPageState();
  }
}

class _QuizResultPageState extends State<QuizResultPage> {
  late QuizBloc _quizBloc;

  @override
  void initState() {
    _quizBloc = QuizBloc();
    _quizBloc.initBloc();

    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_QUIZ_RESULT);
  }

  @override
  void dispose() {
    _quizBloc.dispose();
    super.dispose();
  }

  AppProgressDialog? _appProgressDialog;

  TopicResponse? selectedResponse;

  Future<String?> getToken() async {
    return await Preference.getString(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          var userId = Common.checkNullOrNot(snapshot.data);

          _appProgressDialog = AppProgressDialog(context);

          _quizBloc.fetchWinners();

          // _quizBloc.questionStream.listen((event) {
          //   if(event!=null && event.status!=null ){
          //
          //     print("status: "+ event.status.toString());
          //
          //
          //
          //     if(event.status == Status.LOADING){
          //
          //       if(!_appProgressDialog.isShowing()){
          //         _appProgressDialog.show();
          //       }
          //
          //
          //
          //     }else if(event.status == Status.COMPLETED && event.data != null && event.data.length >0){
          //
          //
          //       print("open page === === === ");
          //
          //       if(_appProgressDialog.isShowing()){
          //         _appProgressDialog.hide();
          //       }
          //
          //
          //
          //       Navigator.pop(context);
          //
          //       //
          //       // Navigator.pushReplacementNamed(context, quiz_play_page, arguments: <String, dynamic>{
          //       //   "questions": event.data,
          //       //   "topic": selectedResponse
          //       // });
          //
          //       Navigator.pushNamed(context, quiz_play_page,arguments: <String, dynamic>{
          //         "questions": event.data,
          //         "topic": selectedResponse
          //       });
          //       //
          //
          //     }
          //     else{
          //
          //
          //
          //     }
          //
          //   }
          // });

          var total = MediaQuery.of(context).size.width;
          var _sixty = total - 0.4 * total;

          return Scaffold(
              appBar: AppBar(
                title: Image.asset(
                  logo_no_text,
                  height: 38,
                  width: 38,
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.close_outlined,
                      color: HexColor.fromHex(bottomNavigationEnabledState)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "MERO SCHOOL QUIZ",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: HexColor.fromHex(colorDarkRed)),
                      ),
                    ),
                  ),

                  // MediaQuery.of(context).size.width
                  AnimationImage(
                    path: quiz_bg_two,
                    width: _sixty,
                  ),
                  // Image.asset(quiz_bg_two, width: _sixty),

                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "YESTERDAY'S WINNERS",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: HexColor.fromHex(colorBlue)),
                      ),
                    ),
                  ),

                  StreamBuilder<Response<List<Winner>>>(
                      stream: _quizBloc.winnersStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.LOADING:
                              return PlaceHolderLoadingVertical();

                              break;

                            case Status.COMPLETED:
                              if (snapshot.data!.data!.length == 0) {
                                return Column(
                                  children: [
                                    Icon(Icons.hourglass_empty),
                                    Error(
                                      errorMessage: "No more quiz for today",
                                      isDisplayButton: false,
                                    ),
                                  ],
                                );
                              } else {
                                snapshot.data!.data?.forEach((element) {
                                  if (element.userId.toString() == userId) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      CongratsDialog confirmationDialog =
                                          CongratsDialog(
                                              "Congratulations !!",
                                              (element.message != null &&
                                                      element
                                                          .message!.isNotEmpty)
                                                  ? "${element.message}"
                                                  : "You have won the prize.");

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return confirmationDialog;
                                        },
                                      );
                                    });
                                  }
                                });

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder: (context, index) {
                                        return WinnersWidget(
                                          response: snapshot.data!.data![index],
                                          stringCallback: (topic) {
                                            // selectedResponse = topic;
                                            // _quizBloc.fetchQuestions(topic);
                                          },
                                        );
                                      }),
                                );
                              }

                              break;

                            case Status.ERROR:
                              return Column(
                                children: [
                                  Icon(
                                    Fontisto.dropbox,
                                    size: 50,
                                    color: Colors.black12,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "${snapshot.data!.message}",
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              );
                              break;
                          }
                        } else {
                          return Container();
                        }

                        return Container();
                      }),
                ],
              ));
        });
  }
}
