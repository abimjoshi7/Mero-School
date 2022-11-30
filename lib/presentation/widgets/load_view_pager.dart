import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html/parser.dart';
import 'package:mero_school/business_login/blocs/reviews_bloc.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/section_data_res_model.dart';
import 'package:mero_school/expandable.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/curriculum_data.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/presentation/widgets/review_alert_dialog.dart';
import 'package:mero_school/quiz/preview_video.dart';
import 'package:mero_school/test/TestClass.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../data/models/response/review_response.dart';
import 'loading/mydivider.dart';

class LoadViewPager extends StatelessWidget {
  final CourseDetailsByIdResponse _data;
  final TabController? _tabController;
  String? courseId;
  Function(String, Lessons)? callback;
  Function(String, Lesson)? callback2;
  ReviewsBloc _reviewsBloc = ReviewsBloc();
  bool isAddedIcon = true;
  bool isDetail = false;

  LoadViewPager(this.isDetail, this.courseId, this._data, this._tabController,
      {this.callback, this.callback2});

  late AppProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = AppProgressDialog(context);

    _reviewsBloc.initBloc();
    _reviewsBloc.fetchData(courseId);

    // _tabController.index = isDetail ? 4: 0;

    // _tabController!.animateTo(isDetail ? 4 : 0);

    var description = [_data.description];

    // var test = "https://video.yunik.live/video/mobile%20development/yuniks%7Csimple%7CIntroduction%20to%20Fundamentals%20of%20Thermodynamics%20and+Heat%20Transfer-MNKjc/master.m3u8";
    // var tedt = "https://video.yunik.live/video/mobile%20development/yuniks%7Csimple%7CIntroduction%20to%20Fundamentals%20of%20Thermodynamics%20and%20h-4rlKP/master.m3u8";
    //

    return Expanded(
      child: TabBarView(
        children: [
          loadCurriculumData(),

          VideoPreview(
              url: "${(_data.is_preview_url)}", token: "${_data.encodedToken}"),
          // VideoPreview(url: test,  token: "${_data.encodedToken}"),
          reviewDesign(),

          myDesign(
              "What is included",
              _data.includes!,
              Icon(
                Icons.api_rounded,
                color: Colors.grey,
              ),
              context),

          myDesign(
              "What you will learn",
              _data.outcomes!,
              Icon(
                Icons.assignment_turned_in_outlined,
                color: Colors.grey,
              ),
              context),

          myDesign(
              "Course Requirements",
              _data.requirements!,
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.grey,
              ),
              context),
          SingleChildScrollView(
            child: myDesign(
                "Description",
                description,
                Icon(
                  Icons.waves_sharp,
                  color: Colors.grey,
                ),
                context),
          ),

          //  myDesign(
          //     "Discussion",
          //     description,
          //     Icon(
          //       Icons.message,
          //       color: Colors.grey,
          //     ),
          //     context),

          // FutureBuilder(
          //   future: getPaymentMethodPref(),
          //   builder: (context,snap) {

          //     return InkWell(
          //       onTap: () =>  Navigator.pushNamed( context, web_page,
          //     arguments: <String, String>{'paymentUrl': "https://mero.school"}),
          //       child: myDesign(
          //           "Payment Methods",
          //           snap.hasData?[snap.data.toString()]:['Nill'],
          //           Icon(
          //             Icons.payment,
          //             color: Colors.grey,
          //           ),
          //           context),
          //     );
          //   }
          // ),

          ListView(
            children: _data.similarCourses!.map((e) {
              return loadSingleItemCard(e, context);
            }).toList(),
          )
        ],
        controller: _tabController,
      ),
    );
  }

  Widget myDesign(
      String title, List<String?> myList, Icon icon, BuildContext context) {
    return Wrap(
      children: [
        Card(
          margin: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .apply(color: Colors.black54),
                    ),
                    icon
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                MyDivider(),
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  primary: false,
                  itemCount: myList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _parseHtmlString(myList[index]),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                letterSpacing: 0.4, color: Colors.black54),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          MyDivider(),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget reviewDesign() {
    return StreamBuilder<Response<ReviewResponse>>(
        stream: _reviewsBloc.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data!.message);
              case Status.COMPLETED:
                debugPrint("Status.COMPLETED");

                if (snapshot.data!.data!.data != null) {
                  snapshot.data!.data!.data!.forEach((element) {
                    if (element.isMyReview!) {
                      isAddedIcon = false;
                    }
                  });
                }

                if (Preference.getString(token) == null) {
                  isAddedIcon = false;
                }

                var child = Column();

                print("status " + snapshot.data!.data!.status.toString());

                if (snapshot.data!.data!.status.toString() == "false") {
                  child = Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Error(
                          errorMessage: "Record not found",
                          isDisplayButton: false,
                          onRetryPressed: () =>
                              _reviewsBloc.fetchData(courseId)),
                    )
                  ]);
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "User Reviews ( ${_data.numberOfRatings} )",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(color: Colors.black54),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    var dialog = ReviewAlertDialog(
                                      callBack: (firstName, lastName, rating,
                                          review) {
                                        print("==>Rating $rating");

                                        progressDialog.show();

                                        //_data
                                        //Category Id
                                        // Catgory Name
                                        // Category Id
                                        // Course Name
                                        // Course Id
                                        // Rating
                                        // Review

                                        WebEngagePlugin.trackEvent(
                                            TAG_SUBMITTED_REVIEW, {
                                          'Category Id':
                                              int.parse(_data.categoryId!),
                                          'Category Name': _data.categoryName,
                                          'Course Id': int.parse(_data.id!),
                                          'Course Duration': _data.paidExpDays,
                                          'Course Time Duration':
                                              _data.hoursLesson,
                                          'Course Name': _data.title,
                                          'Rating': rating,
                                          'Course Rating': rating,
                                          'Review':
                                              review.toString().isNotEmpty,
                                          'Total Enrollments':
                                              _data.totalEnrollment,
                                        });

                                        _reviewsBloc
                                            .addedReview(
                                                courseId,
                                                firstName.toString(),
                                                lastName.toString(),
                                                rating,
                                                review.toString())
                                            .then((response) {
                                          progressDialog.hide();

                                          ToastHelper.showLong(
                                              response.message!);
                                          _reviewsBloc.fetchData(courseId);
                                        });
                                        //
                                      },
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return dialog;
                                      },
                                    );
                                  },
                                  child: Visibility(
                                    visible: isAddedIcon,
                                    child: Icon(AntDesign.plus,
                                        color: HexColor.fromHex(
                                            bottomNavigationIdealState)),
                                  ))
                            ],
                          ),
                        ),
                        MyDivider(),
                        child,
                        ListView.builder(
                            itemCount: snapshot.data!.data!.data!.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return singleItemDialog(
                                  context, snapshot.data!.data!.data![index]);
                            }),
                      ],
                    ),
                  ),
                );

                // singleItemDialog(context);

                break;
              case Status.ERROR:
                debugPrint("Status.ERROR");
                return Error(
                    errorMessage: "Record not found",
                    isDisplayButton: false,
                    onRetryPressed: () => _reviewsBloc.fetchData(courseId));
                break;
            }
          }
          return Container();
        });
  }

  Widget loadCurriculumData() {
    // return ExpansionTileDemo(_data.sections, callback, _data);

    return CurriculumData(
      courseDetailsByIdResponse: _data,
    );
  }

  Widget addSubTitle(List<Lessons> lessons, CourseDetailsByIdResponse data) {
    // groupingFunction(lessons);
    return ListView.builder(
        itemCount: lessons.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              bool isPlay = false;
              if (lessons[index].isLessonFree == "1") {
                isPlay = true;
              } else {
                switch (data.action!.toLowerCase()) {
                  case STR_BUY_NOW:
                    callback!(STR_BUY_NOW, lessons[index]);
                    break;
                  case STR_ENROLL:
                    callback!(STR_ENROLL, lessons[index]);
                    break;
                  default:
                    isPlay = true;
                  // }

                }
              }

              Common.isUserLogin().then((value) {
                if (value) {
                  if (isPlay) {
                    Navigator.of(context)
                        .pushNamed(video_player, arguments: <String, String?>{
                      'action': data.action,
                      'video_url': lessons[index].videoUrl,
                      'encoded_token': data.encodedToken,
                      'lessons_title': lessons[index].title,
                      'title': data.title,
                      'course_id': lessons[index].courseId,
                      'price': data.price,
                      'shareableLink': data.shareableLink,
                      'thumbnail': data.thumbnail,
                      'enrollment': data.totalEnrollment.toString(),
                      'shortDescription': data.shortDescription,
                      'level': data.level,
                      'appleProductId': data.appleProductId
                    });
                  }
                } else {
                  Navigator.pushNamed(context, login_page,
                      arguments: <String, bool>{'isPreviousPage': true});
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 4.0, 0, 0),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: HexColor.fromHex(colorBlue),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              lessons[index].title!,
                              style: TextStyle(
                                  color: HexColor.fromHex(
                                      bottomNavigationEnabledState)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 16),
                        child: Row(
                          children: [
                            Text(
                              (lessons[index].isLessonFree == "1")
                                  ? "Free"
                                  : empty,
                              style: TextStyle(color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(lessons[index].duration!,
                                  style: TextStyle(
                                      color: HexColor.fromHex(
                                          bottomNavigationIdealState))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void groupingFunction(List<Lessons> lessons) {
    TestClass(lessons).mapperFunction(lessons);
  }

  Widget singleItemDialog(BuildContext context, Data model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipOval(
                child: FadeInImage.assetNetwork(
              placeholder: ic_account,
              image: model.profilePic != null
                  ? model.profilePic!
                  : user_placeholder,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, trace) {
                return Image.asset(
                  ic_account,
                  width: 40,
                  height: 40,
                );
              },
            )),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                        visible: model.isMyReview! ? true : false,
                        child: Text(
                          model.status!,
                          style: TextStyle(color: HexColor.fromHex(colorBlue)),
                        ),
                      ),
                    ),

                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: double.parse(model.rating!),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (double value) {},
                    ),

                    // SmoothStarRating(
                    //     isReadOnly: true,
                    //     size: 16,
                    //     rating: double.parse(model.rating.toString()),
                    //     color: HexColor.fromHex(colorGolden),
                    //     borderColor:
                    //     HexColor.fromHex(bottomNavigationIdealState)),
                    //

                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      model.name!,
                      style: TextStyle(
                          color:
                              HexColor.fromHex(bottomNavigationEnabledState)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      model.review!,
                      maxLines: 5,
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          model.dateAdded!,
                          style: TextStyle(
                              color:
                                  HexColor.fromHex(bottomNavigationIdealState)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _parseHtmlString(String? htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    print("incldeds;::" + parsedString);
    return parsedString;
  }

// /*
//    var list = (jsonDecode(str) as List).map((item) => Phone.fromJson(item));
//     print(list.length);
//     var phoneGroup = groupBy(list, (obj) => (obj as Phone).phoneModel);
//     Map finalMap = Map();
//     for (var phone in phoneGroup.keys) {
//       var map = Map();
//       var originCountryGroup =
//           groupBy(phoneGroup[phone], (obj) => (obj as Phone).originCountry);
//       for (var originCountry in originCountryGroup.keys) {
//         var spaceGroup = groupBy(
//             originCountryGroup[originCountry], (obj) => (obj as Phone).space);
//         map[originCountry] = spaceGroup;
//       }
//       map = { phone : map };
//       finalMap = {...finalMap, ...map};
//     }
//     print(jsonEncode(finalMap));
//   });
//  */
//
// //
//     var myGroup = groupBy(parts, (obj) => (obj as String));
//     Map finalMap = Map();
//     var part ;
//     // print("this is test $myGroup");
//     for (var myItem in myGroup.keys) {
//       var map = Map();
//       part= groupBy(myGroup[myItem], (obj) => (obj as String));
//       // map = {myItem:part};
//       // var spaceGroup = groupBy([myItem], (obj) => (obj as Lessons).title);
//       // map[part] = spaceGroup;
//       // print("testsadkd $part");
//       finalMap ={...finalMap, ...part};
//     // var myTitle = groupBy(myGroup[myItem],(obj) => (obj as Lessons).title);
//   }
//
//
//     print("my final map ${jsonEncode(finalMap)}");
}

Future<String> getPaymentMethodPref() async {
  return await Preference.getString(payment_method) ?? 'nill';
}

Widget loadSingleItemCard(CourseSection model, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, course_details, arguments: <String, String?>{
        'course_id': model.id,
        'title': model.title,
        'price': model.price,
        'thumbnail': model.thumbnail,
      });
    },
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0.0),
                    topLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(5.0)),
                child: Container(
                  child: FadeInImage.assetNetwork(
                      image: model.thumbnail!,
                      placeholder: logo_placeholder,
                      height: 100,
                      width: 100,
                      imageErrorBuilder: (_, __, ___) {
                        return ImageError();
                      },
                      fit: BoxFit.fitHeight),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title!.toUpperCase(),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              HexColor.fromHex(bottomNavigationEnabledState)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "RS. " + model.price.toString(),
                      style: TextStyle(
                          color: HexColor.fromHex(bottomNavigationIdealState)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Visibility(
                      visible: model.averageRating == 0 ? false : true,
                      child: Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: double.parse(model.averageRating!),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {},
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(model.averageRating.toString()),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "( ${model.noRating.toString()} )",
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState)),
                          ),
                          // SizedBox(
                          //   width: 40,
                          // ),
                          // Text(
                          //   model.price,
                          //   style: TextStyle(
                          //       color: HexColor.fromHex(colorAccent),
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
