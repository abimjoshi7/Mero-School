import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/business_login/blocs/course_details_bloc.dart';
import 'package:mero_school/business_login/blocs/my_course_bloc.dart';
import 'package:mero_school/business_login/user_state_view_model.dart';
import 'package:mero_school/data/models/response/my_course_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/account/account_page.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_grid.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_progress_dialog.dart';
import '../pdf_viewer_page.dart';

class MyCoursePage extends StatefulWidget {
  @override
  _MyCoursePageState createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  late MyCourseBloc _myCourseBloc;
  late CourseDetailsBloc _courseDetailsBloc;

  @override
  void initState() {
    _myCourseBloc = MyCourseBloc();
    super.initState();
    _courseDetailsBloc = CourseDetailsBloc();
    _courseDetailsBloc.initBloc();
  }

  @override
  Widget build(BuildContext context) {
    var home = Consumer<UserStateViewModel>(
      builder: (_, auth, __) {
        if (auth.loginToken == null) {
          return Container();
        }

        if (auth.loginToken != null &&
            auth.loginToken!.length > 0) {
          print("token: " + auth.loginToken!);
          _myCourseBloc.initBloc();
          return mainView();
        } else {
          return AccountPage();
        }
      },
    );
    return home;
  }

  Widget mainView() {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "My Courses",
                  style: TextStyle(
                      color: HexColor.fromHex(colorDarkRed),
                      fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, expired_course_page);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: Row(
                    children: [
                      Text(
                        "Expired Courses",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: HexColor.fromHex(colorBlue)),
                      ),
                      Icon(
                        AntDesign.doubleright,
                        size: 12,
                        color: HexColor.fromHex(colorBlue),
                      )
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<Response<MyCourseResponse>>(
            stream: _myCourseBloc.dataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log(snapshot.data?.data?.toJson().toString() ?? "");
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return PlaceHolderLoadingGrid();
                    break;
                  case Status.COMPLETED:
                    var myList = snapshot.data!.data!.data!;

                    return Flexible(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          padding: EdgeInsets.all(8),
                          children: List.generate(myList.length, (index) {
                            return loadCardItem(myList[index]);
                          })),
                    );
                    // return Container(
                    //   child: Image.asset(
                    //       logo, height: 50, fit: BoxFit.contain),
                    // );

                    // return mainView(displayJoke: snapshot.data.data);
                    break;
                  case Status.ERROR:
                    // ToastHelper.showLong(snapshot.data.message);
                    // return Container(
                    //   child: Image.asset(logo, height: 50, fit: BoxFit.contain),
                    // );

                    return Error(
                      errorMessage: snapshot.data!.message ==
                              "Record not found!"
                          ? "Currently you are not enrolled to any courses. Enroll to courses from Course Section."
                          : snapshot.data!.message,
                      onRetryPressed: () => _myCourseBloc.fetchData(),
                      isDisplayButton: false,
                    );
                    break;
                }
              }
              return Container();
            })
      ],
    );
  }

  @override
  void dispose() {
    _myCourseBloc.dispose();
    super.dispose();
  }

  Widget loadCardItem(Data model) {
    var completion = 0.0;
    if (model.completion != null) {
      completion = model.completion! / 100.toDouble();
    }
    // return Text('hello');
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(video_player, arguments: <String, String?>{
            'action': STR_PURCHASED,
            'video_url': model.videoUrl,
            'encoded_token': empty,
            'lessons_title': model.title,
            'title': model.title,
            'course_id': model.id,
            'price': model.price,
            'shareableLink': model.shareableLink,
            'thumbnail': model.thumbnail,
            'enrollment': model.totalEnrollment.toString(),
            'shortDescription': model.shortDescription,
            'level': model.level,
            'appleProductId': model.appleProductId,
            "course": "${model.id}",
            "course_expiry_date": "${model.expDate}",
            "course_title": "${model.title}"
          });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0)),
                  child: Container(
                    child: Image.network(model.thumbnail!,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.title == null ? empty : model.title!.toUpperCase(),
                  style: TextStyle(
                      color: HexColor.fromHex(bottomNavigationEnabledState)),
                  textAlign: TextAlign.center,
                ),
              ),
              // SizedBox(height: 5),

              Column(
                children: [
                  Text(
                    "Exp: ${model.expDate}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16, 0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black12,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          HexColor.fromHex(bottomNavigationEnabledState)),
                      value: completion,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${model.completion}% Completed",
                      style: TextStyle(
                          color: HexColor.fromHex(darkNavyBlue), fontSize: 12),
                    ),
                  ),
                  Visibility(
                    visible: model.certificateStatus != null &&
                        model.certificateStatus! &&
                        model.id != null,
                    child: InkWell(
                      onTap: () => viewCertificate(model.id!),
                      child: Container(
                        height: 40,
                        width: 160,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(FontAwesome5.file_pdf),
                              SizedBox(
                                width: 4,
                              ),
                              Text("View Certificate")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              )

              // SizedBox(height: 5),

              // SizedBox(height: 5),
              // SmoothStarRating(
              //     rating: model.rating.toDouble(),
              //     isReadOnly: true,
              //     size: 12,
              //     color: HexColor.fromHex(colorGolden),
              //     borderColor: HexColor.fromHex(bottomNavigationIdealState)),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void viewCertificate(String courseId) async {
    AppProgressDialog _progressDialog = new AppProgressDialog(context);
    await _progressDialog.show();

    print(courseId);
    _courseDetailsBloc.fetchCourseDetailsById(courseId);
    _courseDetailsBloc.generateCertificate(courseId, context).then((value) {
      _progressDialog.hide();
      _courseDetailsBloc.dataStream.first.then((responseById) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => PdfViewerPage(
                    path: value,
                    name: responseById.data?.title ?? "cert-$courseId",
                    arguments: {
                      'Category Id':
                          int.parse(responseById.data?.categoryId ?? "0"),
                      'Category Name': "${responseById.data?.categoryName}",
                      'Course Duration': "${responseById.data?.hoursLesson}",
                      'Course Id': int.parse(responseById.data?.id ?? "0"),
                      'Course Level': "${responseById.data?.level}",
                      'Language': responseById.data?.language ?? "",
                      'Course Name': responseById.data?.title,
                      'Rating': responseById.data?.rating ?? "",
                      'Certificate Generated Date': "",
                    },
                  )))));
    });
  }
}
