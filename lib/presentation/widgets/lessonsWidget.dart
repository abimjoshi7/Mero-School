import 'package:flutter/material.dart';
import 'package:mero_school/business_login/blocs/CurrentPlayingNotifier.dart';
import 'package:mero_school/business_login/blocs/lessons_bloc.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:provider/provider.dart';

import 'package:mero_school/presentation/constants/app_values';

// ignore: must_be_immutable
class LessonsWidget extends StatefulWidget {
  final Lessons? lesson;
  final Function(bool, double)? callback;
  final Function(int, int)? percentUpdate;
  int? level;

  String? title;

  LessonsWidget(
      {this.lesson, this.callback, this.level, this.title, this.percentUpdate});

  @override
  _LessonsWidgetState createState() => _LessonsWidgetState();
}

class _LessonsWidgetState extends State<LessonsWidget> {
  late LessonsBloc _lessonsBloc;

  @override
  void initState() {
    _lessonsBloc = LessonsBloc();
    _lessonsBloc.initBloc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isFree = "";

    if (widget.lesson!.isLessonFree == "1") {
      isFree = "Free ";
    }
    print("" + widget.lesson!.isChecked.toString());

    return Consumer<CurrentPlayingNotifier>(
      builder: (_, currentPlaying, __) {
        var icon = Icons.play_arrow;
        var color;
        if (currentPlaying.url == widget.lesson!.videoUrl) {
          icon = Icons.play_circle_outline_outlined;
          color = Colors.grey.shade200;
        }

        return Container(
          color: color,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: intend * widget.level!,
                  ),
                  Expanded(
                    flex: 0,
                    child: Icon(
                      icon,
                      size: 24,
                      color: HexColor.fromHex(colorBlue),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      widget.title!,
                      softWrap: true,
                      style: TextStyle(
                        color: HexColor.fromHex(darkNavyBlue),
                      ),
                    ),
                  ),
                  Checkbox(
                      value: widget.lesson!.isChecked,
                      activeColor: HexColor.fromHex(colorBlue),
                      onChanged: (bool? value) {
                        print(widget.lesson!.id);
                        _lessonsBloc
                            .saveCourseProgress(
                                widget.lesson!.id, value! ? "1" : "0")
                            .then((response) {
                          var total = response.numberOfLessons;
                          var complete = response.numberOfCompletedLessons;

                          // double result = (complete.toDouble()/total.toDouble()) * 100;

                          widget.percentUpdate!(total!, complete!);

                          setState(() {
                            if (value) {
                              //{"course_id":"13","number_of_lessons":562,"number_of_completed_lessons":2,"course_progress":0}
                              var total = response.numberOfLessons!;
                              var complete = response.numberOfCompletedLessons!;

                              double result =
                                  (complete.toDouble() / total.toDouble()) *
                                      100;

                              widget.callback!(true, result);

                              ToastHelper.showShort("Marked as Complete");

                              //

                            } else {
                              var total = response.numberOfLessons!;
                              var complete = response.numberOfCompletedLessons!;

                              double result =
                                  (complete.toDouble() / total.toDouble()) *
                                      100;
                              widget.callback!(false, result);
                              ToastHelper.showShort("Marked as Incomplete");
                            }
                            widget.lesson!.isChecked = value;
                          });
                        });
                      }),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: intend * widget.level! + 36),
                  child: Row(
                    children: [
                      Text(
                        isFree,
                        style: TextStyle(
                            fontSize: 13, color: HexColor.fromHex(colorFree)),
                        softWrap: true,
                      ),
                      Text(
                        "" + widget.lesson!.duration!,
                        style: TextStyle(
                            fontSize: 13,
                            color:
                                HexColor.fromHex(bottomNavigationIdealState)),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // CurrentPlayingNotifier currentPlayingNotifier = Provider.of<CurrentPlayingNotifier>(context, listen: false);

    // String url = currentPlayingNotifier.url;
  }
}

String getLessionTitle(String title, String lessonTitle) {
  String result = "";

  var intermediate = title;

  intermediate = lessonTitle;

  return result;
}
