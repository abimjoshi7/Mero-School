import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mero_school/business_login/blocs/course_details_bloc.dart';

import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/curriculum_data_res_model.dart'
    as curr;
import 'package:mero_school/data/models/response/section_data_res_model.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/course_details/course_details_page.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class CurriculumData extends StatefulWidget {
  CurriculumData({Key? key, required this.courseDetailsByIdResponse})
      : super(key: key);
  final CourseDetailsByIdResponse courseDetailsByIdResponse;

  @override
  State<CurriculumData> createState() => _CurriculumDataState();
}

class _CurriculumDataState extends State<CurriculumData> {
  bool isLoading = true;
  final _networkHelper = MyNetworkClient();
  List<Section> subSection = [];
  List<Section> mainSection = [];
  List<Section> sectionList = [];
  bool allLessonNotEmpty = false;

  Future<SectionDataResModel> buildSectionChild(String cid, String sid,
      [String? pid]) async {
    final res = await _networkHelper.getSection(cid, sid, pid ?? "0");
    return res;
  }

  Future<void> go(CourseDetailsByIdResponse courseDetailsByIdResponse,
      List<Section> sectionList, int index) async {
    print("Course Id: " + courseDetailsByIdResponse.id!);
    print("Section Id: " + sectionList[index].sectionId);
    if (sectionList[index].lessons.isEmpty) {
      while (sectionList.every((element) {
        if (element.lessons.isEmpty) {
          return true;
        } else {
          return false;
        }
      })) {
        print("okay");
        break;
      }
      final res = await _networkHelper.getSection(courseDetailsByIdResponse.id!,
          sectionList[index].sectionId, sectionList[index].parentId);
      if (res.data.isNotEmpty) {
        setState(() {
          subSection = res.data;
        });
      }
    } else {
      final res = await _networkHelper.getSection(
          courseDetailsByIdResponse.id!, sectionList[index].sectionId);
      if (res.data.isNotEmpty) {
        setState(() {
          subSection = res.data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<curr.CurriculumDataResModel>(
      future: _networkHelper.fetchInitialCurriculumData(
        int.parse(widget.courseDetailsByIdResponse.id!),
      ),
      builder: (context, snapshot) => snapshot.hasData
          ? ListView.builder(
              itemCount: snapshot.data?.data.sections.length,
              itemBuilder: (context, index) => snapshot.data == null
                  ? Center(
                      child: Text("Cannot fetch data"),
                    )
                  : Card(
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.data.sections[index].title,
                              style: TextStyle(fontSize: 14),
                            ),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Text(
                                    snapshot.data!.data.sections[index]
                                            .totalLesson
                                            .toString() +
                                        " lessons",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    // thickness: 3,
                                  ),
                                  Text(
                                    snapshot.data!.data.sections[index]
                                        .totalDuration,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onExpansionChanged: (value) async {
                          print("Course Id: " +
                              widget.courseDetailsByIdResponse.id!);
                          print("Section Id: " +
                              snapshot.data!.data.sections[index].id);

                          isLoading = true;
                          try {
                            final res = await _networkHelper.getSection(
                                widget.courseDetailsByIdResponse.id!,
                                snapshot.data!.data.sections[index].id);
                            setState(() {
                              mainSection = res.data;
                            });

                            print("MainSection: " + mainSection.toString());
                            if (res.data.isNotEmpty && mainSection.isNotEmpty) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        children: isLoading == true
                            ? []
                            : mainSection.isEmpty
                                ? []
                                : List.generate(
                                    mainSection.length,
                                    (index) => SectionTileSecondary(
                                      section: mainSection[index],
                                      courseDetailsByIdResponse:
                                          widget.courseDetailsByIdResponse,
                                      sectionList: mainSection,
                                      sectionIndex: index,
                                    ),
                                  ),
                      ),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class SectionTileSecondary extends StatefulWidget {
  const SectionTileSecondary(
      {Key? key,
      required this.section,
      required this.courseDetailsByIdResponse,
      required this.sectionList,
      required this.sectionIndex})
      : super(key: key);
  final CourseDetailsByIdResponse courseDetailsByIdResponse;
  final Section section;
  final List<Section> sectionList;
  final int sectionIndex;

  @override
  State<SectionTileSecondary> createState() => _SectionTileSecondaryState();
}

class _SectionTileSecondaryState extends State<SectionTileSecondary> {
  List<Section> sectionList123 = [];
  @override
  Widget build(BuildContext context) {
    if (widget.section.lessons.isNotEmpty)
      return _buildFinalExpansion(
          widget.section, widget.courseDetailsByIdResponse);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RecursiveExpansionTile(
          section: widget.section,
          courseDetailsByIdResponse: widget.courseDetailsByIdResponse,
          sectionList: widget.sectionList),
    );
  }

  Widget _buildFinalExpansion(
      Section section, CourseDetailsByIdResponse courseDetailsByIdResponse) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: TextStyle(fontSize: 14),
        ),
        children: List.generate(
          section.lessons.length,
          (index) => LessonTitleWidget(
            name: section.lessons[index].title,
            data: courseDetailsByIdResponse,
            lesson: section.lessons[index],
          ),
        ),
      ),
    );
  }
}

class RecursiveExpansionTile extends StatefulWidget {
  final Section section;
  final CourseDetailsByIdResponse courseDetailsByIdResponse;
  final List<Section> sectionList;

  const RecursiveExpansionTile(
      {Key? key,
      required this.section,
      required this.courseDetailsByIdResponse,
      required this.sectionList})
      : super(key: key);

  @override
  State<RecursiveExpansionTile> createState() => _RecursiveExpansionTileState();
}

class _RecursiveExpansionTileState extends State<RecursiveExpansionTile> {
  List<Section> sectionListSecondary = [];
  List<Section> irregularSection = [];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.section.title,
        style: TextStyle(fontSize: 14),
      ),
      onExpansionChanged: (value) async {
        print("Course Id: " + widget.courseDetailsByIdResponse.id!);
        print("Section Id: " + widget.section.sectionId);
        print("Parent Id: " + widget.section.parentId);
        print("second one");
        if (widget.sectionList.every((element) {
              if (element.lessons.isEmpty) return true;
              return false;
            }) ==
            true) {
          print("All lessons are empty");
          final res = await MyNetworkClient().getSection(
              widget.courseDetailsByIdResponse.id!,
              widget.section.sectionId,
              widget.section.parentId);
          setState(() {
            sectionListSecondary = res.data;
          });
        } else {
          final res = await MyNetworkClient().getSection(
              widget.courseDetailsByIdResponse.id!,
              widget.section.sectionId,
              widget.section.parentId);
          setState(() {
            irregularSection = res.data;
          });
          print("Irregular");
        }
        print(sectionListSecondary);
        print(irregularSection);
      },
      children: sectionListSecondary.isEmpty
          ? List.generate(
              irregularSection.length,
              (index) => SectionTileSecondary(
                  section: irregularSection[index],
                  courseDetailsByIdResponse: widget.courseDetailsByIdResponse,
                  sectionList: irregularSection,
                  sectionIndex: index),
            )
          : List.generate(
              sectionListSecondary.length,
              (index) => SectionTileSecondary(
                  section: sectionListSecondary[index],
                  courseDetailsByIdResponse: widget.courseDetailsByIdResponse,
                  sectionList: sectionListSecondary,
                  sectionIndex: index),
            ),
    );
  }
}

class LessonTitleWidget extends StatelessWidget {
  LessonTitleWidget({
    Key? key,
    required this.name,
    required this.data,
    required this.lesson,
    this.callback,
  }) : super(key: key);

  final String? name;
  final CourseDetailsByIdResponse data;
  final Lesson lesson;
  final Function(String, Lesson)? callback;
  final CourseDetailsBloc _courseDetailsBloc = CourseDetailsBloc();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          handleClickAction(lesson, data, context);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: Colors.blue,
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      lesson.isLessonFree != "0"
                          ? Text(
                              "Free",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 13),
                            )
                          : Icon(Icons.lock, size: 15),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${lesson.duration}",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleClickAction(
      Lesson lesson, CourseDetailsByIdResponse data, BuildContext? context) {
    bool isPlay = false;
    if (lesson.isLessonFree == "1") {
      isPlay = true;
    } else {
      switch (data.action!.toLowerCase()) {
        case STR_BUY_NOW:
          print(123123123);
          Fluttertoast.showToast(
              msg: "Click on Buy Now to purchase/view the course",
              backgroundColor: Colors.grey);

          // Common.isUserLogin().then(
          //   (value) async {
          //     if (value) {
          //       if (data != null) {
          //         print("RATINGDATA ${data.rating}");
          //         WebEngagePlugin.trackEvent(TAG_CART_ADDED, {
          //           'Category Id': int.parse(data.categoryId!),
          //           'Category Name': "${data.categoryName}",
          //           'Course Time Duration': "${data.hoursLesson}",
          //           'Course Duration': int.parse(data.paidExpDays!),
          //           'Course Created By': "Mero School",
          //           'Course Id': int.parse(data.id!),
          //           'Course Level': "${data.level}",
          //           'Language': data.language,
          //           'Price': 0.1,
          //           //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
          //           'Discount': 0.1,
          //           //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
          //           'Course Rating': data.rating,
          //           'Course Name': data.title,
          //           'Total Enrollments': data.totalEnrollment,
          //         });
          //       }

          //       // _courseDetailsBloc.insertDataIntoDatabase(_myCartModel!);
          //       // Navigator.pushNamed(context, my_carts);
          //       // gotoCartAndWait(context!);
          //     } else {
          //       // print("#1123 User not loggedin");
          //       // Navigator.pushNamed(context, login_page,
          //       //     arguments: <String, bool>{'isPreviousPage': true}).then((value) =>
          //       //
          //       //     Common.isUserLogin().then((lggedin){
          //       //
          //       //       print("1123 loggedin $lggedin");
          //       //       if(lggedin){
          //       //         _courseDetailsBloc
          //       //             .insertDataIntoDatabase(_myCartModel);
          //       //         // Navigator.pushNamed(context, my_carts);
          //       //         gotoCartAndWait();
          //       //
          //       //       }else{
          //       //         print("1123 couldnot login agina");
          //       //       }
          //       //
          //       //     })
          //       //
          //       // );

          //     }
          //   },
          // );
          callback!(STR_BUY_NOW, lesson);
          print(321321312);
          break;
        case STR_ENROLL:
          print(321);
          Fluttertoast.showToast(
              msg: "Click on enroll to view the course",
              backgroundColor: Colors.grey);
          callback!(STR_ENROLL, lesson);
          break;
        default:
          isPlay = true;
      }
    }
    // * Login Check
    Common.isUserLogin().then((value) {
      if (value) {
        if (isPlay) {
          var maps = <String, String?>{
            'action': data.action,
            'video_url': lesson.videoUrl,
            'encoded_token': data.encodedToken,
            'lessons_title': lesson.title,
            'title': data.title,
            'course_id': lesson.courseId,
            'price': data.price,
            'shareableLink': data.shareableLink,
            'thumbnail': data.thumbnail,
            'enrollment': data.totalEnrollment.toString(),
            'shortDescription': data.shortDescription,
            'level': data.level,
            'appleProductId': data.appleProductId,
            'category_id':
                data.categoryId == null ? 0 as String? : data.categoryId,
            'category_name': data.categoryName,
            'video_duration': data.hoursLesson,
            // 'section_title': lessons.sectionTitle,
            'section_title': lesson.title,
            'course_expiry_date': data.expDate,
            'les_duration': lesson.duration,
            'tags': json.encode(data.toJson()),
          };
          // print("maps: $maps");
          Navigator.of(context!).pushNamed(video_player, arguments: maps);
        }
      } else {
        Navigator.pushNamed(context!, login_page,
            arguments: <String, bool>{'isPreviousPage': true});
      }
    });
  }

  void gotoCartAndWait(BuildContext context) {
    Navigator.pushNamed(context, my_carts).then((value) {
      // print("in course Detail Page: $value");
      // _courseDetailsBloc.fetchCourseDetailsById(courseId);
      _courseDetailsBloc.fetchCourseDetailsById(data.id);
      // setState(() {});

      if (value.toString().toLowerCase() == "success") {
        _courseDetailsBloc.fetchCourseDetailsById(data.id);
      }
    });
  }
}
