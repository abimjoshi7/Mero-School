import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/course_details_bloc.dart';
import 'package:mero_school/business_login/blocs/reviews_bloc.dart';
import 'package:mero_school/data/models/response/certificate_status_response.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/related_plan_response.dart';
import 'package:mero_school/data/repositories/bloc/lesson_section_bloc.dart';
import 'package:mero_school/data/repositories/lesson_section_repo.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/pdf_viewer_page.dart';
import 'package:mero_school/presentation/widgets/load_view_pager.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/test/random.dart';
import 'package:mero_school/test/test_model.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/offers_button_sheet.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../data/models/response/section_data_res_model.dart';
import '../utils/preference.dart';
import 'dart:math';

class RandomNames {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  // s//     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  final nameController = StreamController<String>();

  Stream get nameStream => nameController.stream;

  void generateNewName() {
    final randomName1 = "MizuKage";
    final randomName2 = "MizuTage";
  }
}

class Est extends StatelessWidget {
  final lessonRepo = LessonSectionRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Test123123(),
    );
  }
}

class Test123123 extends StatelessWidget {
  const Test123123({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read().add(
                LessonSectionRequested(),
              );
        },
        child: Text("data"),
      ),
    );
  }
}

// class CourseDetailsPage extends StatefulWidget {
//   Map? _arguments;

//   CourseDetailsPage(this._arguments);

//   @override
//   _CourseDetailsPageState createState() => _CourseDetailsPageState(_arguments);
// }

// class _CourseDetailsPageState extends State<CourseDetailsPage>
//     with SingleTickerProviderStateMixin {
//   Map? _arguments;

//   _CourseDetailsPageState(this._arguments);

//   TabController? _tabController;
//   late CourseDetailsBloc _courseDetailsBloc;
//   late ReviewsBloc _reviewBloc;
//   MyCartModelData? _myCartModel;
//   bool? isWishlisted;
//   String text = "Enroll";
//   bool isEnroll = false;
//   Lessons? enrollLessons;
//   Lesson? enrollLessons2;
//   String? courseId;
//   late SharedPreferences _preferences;

//   Future initPreferences() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   var priceToSend = 0.0;
//   var discountPrice = 0.0;
//   var courseCreatedBy = "";

//   void gotoCartAndWait() {
//     Navigator.pushNamed(context, my_carts).then((value) {
//       _courseDetailsBloc.fetchCourseDetailsById(courseId);
//       setState(() {});
//       if (value.toString().toLowerCase() == "success") {
//         _courseDetailsBloc.fetchCourseDetailsById(courseId);
//       }
//     });
//   }

//   bool fromVideo = false;

//   @override
//   void initState() {
//     initPreferences();

//     if (_arguments!.containsKey('fromVideo')) {
//       fromVideo = true;
//     }

//     _tabController = new TabController(
//         initialIndex: fromVideo ? 6 : 0, length: 8, vsync: this);
//     _courseDetailsBloc = CourseDetailsBloc();
//     courseId = _arguments?['course_id'].toString();

//     _reviewBloc = ReviewsBloc();
//     _reviewBloc.initBloc();

//     _courseDetailsBloc.initBloc();

//     if (courseId?.isNotEmpty == true) {
//       _courseDetailsBloc.fetchCourseDetailsById(courseId);
//       _courseDetailsBloc.checkCertificate(courseId);
//       _reviewBloc.fetchRelatedPlan(courseId);
//     }

//     callDynamicLink();
//     super.initState();

//     WebEngagePlugin.trackScreen(TAG_PAGE_COURSE_DETAIL);
//   }

//   void goBackOrOpenHome() {
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
//     }
//   }

//   void callBackFromOffer(String planId) {
//     Navigator.pushNamed(context, plans_details_page,
//         arguments: <String, String?>{'plan_id': planId});
//   }

//   void showPopupForOffers(RelatedPlanResponse? relatedPlanResponse) {
//     isExtended.value = !isExtended.value;
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: false,
//         backgroundColor: Colors.transparent,
//         builder: (_) {
//           return Container(
//             height: 350,
//             decoration: new BoxDecoration(
//                 borderRadius: new BorderRadius.only(
//                     topLeft: const Radius.circular(25.0),
//                     topRight: const Radius.circular(25.0))),
//             child: OffersBottomSheets(
//               courseId: "$courseId",
//               callback: callBackFromOffer,
//               systemSettingsResponse: relatedPlanResponse,
//             ),
//           );
//         }).whenComplete(() {
//       isExtended.value = !isExtended.value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return mainView();
//   }

//   CourseDetailsByIdResponse? data;
//   final ValueNotifier<bool> isExtended = ValueNotifier<bool>(false);

//   Widget mainView() {
//     return StreamBuilder<Response<CourseDetailsByIdResponse>>(
//         stream: _courseDetailsBloc.dataStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             print("Sanpshot: Status ${snapshot.data?.status}");
//             switch (snapshot.data?.status) {
//               case Status.LOADING:
//                 AppBar appBar = AppBar(
//                   backgroundColor: Colors.white,
//                   leading: IconButton(
//                     icon: Icon(Icons.arrow_back_ios,
//                         color: HexColor.fromHex(bottomNavigationEnabledState)),
//                     onPressed: () {
//                       goBackOrOpenHome();
//                     },
//                   ),
//                   title: Text(
//                     _arguments!['title'] != null
//                         ? _arguments!['title']
//                         : "Fetching details",
//                     style: TextStyle(
//                       color: Colors.black87,
//                     ),
//                   ),
//                 );
//                 return Scaffold(
//                   appBar: appBar,
//                   body: Column(
//                     children: [
//                       Container(
//                           height: 250,
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: NetworkImage(
//                                   _arguments!.containsKey('thumbnail') == true
//                                       ? _arguments!['thumbnail'] != null
//                                           ? _arguments!['thumbnail']
//                                           : "https://mero.school/themes/assets/images/hero-illustration.png"
//                                       : "https://mero.school/themes/assets/images/hero-illustration.png",
//                                 ),
//                                 fit: BoxFit.fill,
//                                 colorFilter: ColorFilter.mode(
//                                     HexColor.fromHex(colorBlue)
//                                         .withOpacity(0.5),
//                                     BlendMode.srcOver)),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               // updateWidget(snapshot.data.data),
//                               // tabTitle()
//                             ],
//                           )),
//                       PlaceHolderLoadingVertical()
//                     ],
//                   ),
//                 );
//               case Status.COMPLETED:
//                 data = snapshot.data!.data;
//                 _courseDetailsBloc.updateWish(data!.isWishlisted);
//                 courseCreatedBy = snapshot.data!.data!.instructorName ?? "";
//                 if (snapshot.data!.data!.price == "Free" ||
//                     snapshot.data!.data!.price!.isEmpty) {
//                   priceToSend = 0.0;
//                 } else if (data!.discountFlag!.trim() == "1") {
//                   priceToSend = double.parse(data!.discountedPrice!);
//                   discountPrice = double.parse(data!.price!) -
//                       double.parse(data!.discountedPrice!);
//                 } else {
//                   priceToSend = double.parse(data!.price!);
//                 }

//                 WebEngagePlugin.trackEvent(TAG_PAGE_COURSE_DETAIL, {
//                   'Category Id': int.parse(snapshot.data!.data!.categoryId!),
//                   'Category Name': "${snapshot.data!.data!.categoryName}",
//                   'Discount': discountPrice,
//                   'Course Id': int.parse(snapshot.data!.data!.id!),
//                   'Purchase Status': snapshot.data!.data!.isPurchased,
//                   'Level': "${snapshot.data!.data!.level}",
//                   'Course Level': "${snapshot.data!.data!.level}",
//                   'Price': priceToSend,
//                   'Rating': snapshot.data!.data!.rating ?? 0.0,
//                   'Course Rating': snapshot.data!.data!.rating,
//                   'Course Name': snapshot.data!.data!.title,
//                   'Total Enrollments': snapshot.data!.data!.totalEnrollment,
//                   'Enrollment Status':
//                       (snapshot.data!.data!.action == "Enrolled" ||
//                               snapshot.data!.data!.action == "Purchased")
//                           ? true
//                           : false,
//                   'Course Time Duration': snapshot.data!.data!.hoursLesson,
//                   'Course Duration':
//                       int.parse(snapshot.data!.data!.paidExpDays!),
//                   'Course Created By': snapshot.data!.data!.instructorName ?? ""
//                 });

//                 bool hasPreview = false;

//                 if (snapshot.data?.data?.is_preview_url?.isNotEmpty == true) {
//                   hasPreview = true;
//                 }
//                 AppBar appBar = AppBar(
//                   backgroundColor: Colors.white,
//                   leading: IconButton(
//                     icon: Icon(Icons.arrow_back_ios,
//                         color: HexColor.fromHex(bottomNavigationEnabledState)),
//                     onPressed: () {
//                       goBackOrOpenHome();
//                     },
//                   ),
//                   title: Text(
//                     snapshot.data!.data!.title!,
//                     style: TextStyle(color: Colors.black87),
//                   ),
//                   actions: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => Random()));
//                       },
//                       icon: Icon(Icons.safety_check),
//                     ),
//                   ],
//                 );
//                 return Scaffold(
//                   appBar: appBar,
//                   body: Column(
//                     children: [
//                       // ! Course Detail Header
//                       Container(
//                           height: 250,
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: NetworkImage(
//                                     snapshot.data!.data!.thumbnail!),
//                                 fit: BoxFit.fill,
//                                 colorFilter: ColorFilter.mode(
//                                     HexColor.fromHex(colorBlue)
//                                         .withOpacity(0.5),
//                                     BlendMode.srcOver)),
//                           ),
//                           child: snapshot.hasData
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Visibility(
//                                       visible:
//                                           _preferences.getString(hidePayment) ==
//                                                   "true"
//                                               ? false
//                                               : true,
//                                       child: updateWidget(snapshot.data!.data),
//                                     ),
//                                     tabTitle(hasPreview)
//                                   ],
//                                 )
//                               : Column(
//                                   children: [tabTitle(hasPreview)],
//                                 )),
//                       viewPagerApi(hasPreview),
//                     ],
//                   ),

//                   // * related plans starts
//                   floatingActionButton:
//                       StreamBuilder<Response<RelatedPlanResponse>>(
//                     stream: _reviewBloc.relatedPlanStream,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         if (snapshot.data?.status == Status.COMPLETED &&
//                             snapshot.data!.data!.data!.length > 0) {
//                           return Container(
//                             height: 42,
//                             child: FloatingActionButton.extended(
//                               extendedPadding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 8),
//                               onPressed: () {
//                                 showPopupForOffers(snapshot.data?.data);
//                               },
//                               label: ValueListenableBuilder<bool>(
//                                 valueListenable: isExtended,
//                                 builder: (BuildContext context, bool value,
//                                     Widget? child) {
//                                   return AnimatedSwitcher(
//                                     duration: Duration(milliseconds: 100),
//                                     transitionBuilder: (Widget child,
//                                             Animation<double> animation) =>
//                                         FadeTransition(
//                                       opacity: animation,
//                                       child: SizeTransition(
//                                         child: child,
//                                         sizeFactor: animation,
//                                         axis: Axis.horizontal,
//                                       ),
//                                     ),
//                                     child: value
//                                         ? Icon(Icons.close, size: 12)
//                                         : Row(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     right: 4.0),
//                                                 child: Icon(
//                                                   Icons.card_giftcard_outlined,
//                                                   size: 12,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 "Related Plans",
//                                                 style: TextStyle(fontSize: 12),
//                                               ),
//                                             ],
//                                           ),
//                                   );
//                                 },
//                               ),
//                               backgroundColor: Colors.blueAccent,
//                             ),
//                           );
//                         }
//                       }
//                       return SizedBox();
//                     },
//                   ),
//                 );
//               case Status.ERROR:
//                 break;
//             }
//           }
//           return Container();
//         });
//   }

//   // * Tab Headers
//   Widget tabTitle(bool hasPreview) {
//     return Container(
//       color: Colors.white,
//       child: TabBar(
//         unselectedLabelColor: HexColor.fromHex(colorBlue),
//         isScrollable: true,
//         indicator: BoxDecoration(
//             color: HexColor.fromHex(colorBlue), shape: BoxShape.rectangle),
//         tabs: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text(
//               "Curriculum",
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Preview", style: TextStyle(fontSize: 16)),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Reviews", style: TextStyle(fontSize: 16)),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Includes", style: TextStyle(fontSize: 16)),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Outcomes", style: TextStyle(fontSize: 16)),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Requirements", style: TextStyle(fontSize: 16)),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Details", style: TextStyle(fontSize: 16)),
//           ),

//           // Padding(
//           //   padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//           //   child: Text("Discussions", style: TextStyle(fontSize: 16)),
//           // ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//             child: Text("Similar Courses", style: TextStyle(fontSize: 16)),
//           )
//         ],
//         controller: _tabController,
//         indicatorSize: TabBarIndicatorSize.tab,
//       ),
//     );
//   }

//   // * Tab Contents
//   Widget viewPagerApi(bool hasPreview) {
//     return StreamBuilder<Response<CourseDetailsByIdResponse>>(
//         stream: _courseDetailsBloc.dataStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             switch (snapshot.data!.status) {
//               case Status.LOADING:
//                 return Loading(loadingMessage: snapshot.data!.message);
//               case Status.COMPLETED:
//                 CourseDetailsByIdResponse model = snapshot.data!.data!;

//                 var priceToSend = double.parse(model.price!);

//                 if (model.discountFlag!.trim() == "1") {
//                   priceToSend = double.parse(model.discountedPrice!);
//                   discountPrice = double.parse(model.price!) -
//                       double.parse(model.discountedPrice!);
//                 }

//                 _myCartModel = MyCartModelData(
//                     cartId: model.id.toString(),
//                     title: model.title.toString(),
//                     shortDescription: model.shortDescription.toString(),
//                     level: model.level.toString(),
//                     price: priceToSend.toString(),
//                     appleProductId: "${model.appleProductId}",
//                     tagsmeta: json.encode(model.toJson()));

//                 if (isEnroll) {
//                   isEnroll = false;
//                   if (enrollLessons != null) {
//                     late var myLesson;
//                     String? sectionTitle = "";
//                     model.sections!.forEach((section) {
//                       section.lessons!.forEach((lesson) {
//                         if (enrollLessons!.id == lesson.id) {
//                           sectionTitle = section.title;
//                           myLesson = lesson;
//                         }
//                       });
//                     });
//                     Common.isUserLogin().then((value) {
//                       if (value) {
//                         var maps = <String, String?>{
//                           'action': STR_ENROLLED,
//                           'video_url': myLesson.videoUrl,
//                           'encoded_token': model.encodedToken,
//                           'lessons_title': myLesson.title,
//                           'title': model.title,
//                           'course_id': myLesson.courseId,
//                           'price': model.price,
//                           'shareableLink': model.shareableLink,
//                           'thumbnail': model.thumbnail,
//                           'enrollment': model.totalEnrollment.toString(),
//                           'shortDescription': model.shortDescription,
//                           'level': model.level,
//                           'appleProductId': model.appleProductId,
//                           'category_id': model.categoryId == null
//                               ? 0 as String?
//                               : model.categoryId,
//                           'category_name': model.categoryName,
//                           'video_duration': model.hoursLesson,
//                           'section_title': sectionTitle,
//                           'tags': json.encode(model.toJson())
//                         };

//                         // print('===arguments sendn: ${json.encode(model.toJson())}');

//                         Navigator.of(context)
//                             .pushNamed(video_player, arguments: maps)
//                             .then((value) {
//                           // print("retrunback: in course details $value");

//                           if (value.toString().toLowerCase() == "success") {
//                             _courseDetailsBloc.fetchCourseDetailsById(courseId);
//                           }
//                         });
//                       } else {
//                         Navigator.pushNamed(context, login_page,
//                             arguments: <String, bool>{'isPreviousPage': true});
//                       }
//                     });
//                   }
//                 }

//                 return LoadViewPager(
//                   fromVideo,
//                   courseId,
//                   model,
//                   _tabController,
//                   callback: (value, lesson) {
//                     switch (value) {
//                       case STR_BUY_NOW:
//                         {
//                           // print("#1123 RATINGHERE ${data.rating}");

//                           if (_myCartModel != null) {
//                             if (Platform.isIOS) {
//                               _naviagetToInAppPay(_myCartModel!.cartId,
//                                   _myCartModel!.appleProductId);
//                             } else {
//                               Common.isUserLogin().then((value) {
//                                 if (value) {
//                                   if (data != null) {
//                                     print("RATINGDATA ${data!.rating}");
//                                     WebEngagePlugin.trackEvent(TAG_CART_ADDED, {
//                                       'Category Id':
//                                           int.parse(data!.categoryId!),
//                                       'Category Name': "${data!.categoryName}",
//                                       'Course Time Duration':
//                                           "${data!.hoursLesson}",
//                                       'Course Duration':
//                                           int.parse(data!.paidExpDays!),
//                                       'Course Created By': courseCreatedBy,
//                                       'Course Id': int.parse(data!.id!),
//                                       'Course Level': "${data!.level}",
//                                       'Language': data!.language,
//                                       'Price': priceToSend,
//                                       //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                                       'Discount': discountPrice,
//                                       //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                                       'Course Rating': data!.rating,
//                                       'Course Name': data!.title,
//                                       'Total Enrollments':
//                                           data!.totalEnrollment,
//                                     });
//                                   }

//                                   _courseDetailsBloc
//                                       .insertDataIntoDatabase(_myCartModel!);
//                                   // Navigator.pushNamed(context, my_carts);
//                                   gotoCartAndWait();
//                                 } else {
//                                   // print("#1123 User not loggedin");
//                                   // Navigator.pushNamed(context, login_page,
//                                   //     arguments: <String, bool>{'isPreviousPage': true}).then((value) =>
//                                   //
//                                   //     Common.isUserLogin().then((lggedin){
//                                   //
//                                   //       print("1123 loggedin $lggedin");
//                                   //       if(lggedin){
//                                   //         _courseDetailsBloc
//                                   //             .insertDataIntoDatabase(_myCartModel);
//                                   //         // Navigator.pushNamed(context, my_carts);
//                                   //         gotoCartAndWait();
//                                   //
//                                   //       }else{
//                                   //         print("1123 couldnot login agina");
//                                   //       }
//                                   //
//                                   //     })
//                                   //
//                                   // );

//                                 }
//                               });
//                             }
//                           }
//                           break;
//                         }
//                       case STR_ENROLL:
//                         {
//                           Common.isUserLogin().then((value) {
//                             if (value) {
//                               _courseDetailsBloc
//                                   .enrolledToFreeCourse(courseId, data)
//                                   .then((response) {
//                                 ToastHelper.showShort(response.message!);

//                                 if (response.data!.is_enrolled!) {
//                                   setState(() {
//                                     text = "Enrolled";
//                                   });
//                                   _courseDetailsBloc
//                                       .fetchCourseDetailsById(courseId);
//                                   isEnroll = true;
//                                   enrollLessons = lesson;
//                                 }
//                               });
//                             } else {
//                               // Navigator.pushNamed(context, login_page,
//                               //     arguments: <String, bool>{'isPreviousPage': true});
//                             }
//                           });

//                           break;
//                         }
//                     }
//                   },
//                   callback2: (value, lesson) {
//                     switch (value) {
//                       case STR_BUY_NOW:
//                         {
//                           // print("#1123 RATINGHERE ${data.rating}");

//                           if (_myCartModel != null) {
//                             if (Platform.isIOS) {
//                               _naviagetToInAppPay(_myCartModel!.cartId,
//                                   _myCartModel!.appleProductId);
//                             } else {
//                               Common.isUserLogin().then((value) {
//                                 if (value) {
//                                   if (data != null) {
//                                     print("RATINGDATA ${data!.rating}");
//                                     WebEngagePlugin.trackEvent(TAG_CART_ADDED, {
//                                       'Category Id':
//                                           int.parse(data!.categoryId!),
//                                       'Category Name': "${data!.categoryName}",
//                                       'Course Time Duration':
//                                           "${data!.hoursLesson}",
//                                       'Course Duration':
//                                           int.parse(data!.paidExpDays!),
//                                       'Course Created By': courseCreatedBy,
//                                       'Course Id': int.parse(data!.id!),
//                                       'Course Level': "${data!.level}",
//                                       'Language': data!.language,
//                                       'Price': priceToSend,
//                                       //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                                       'Discount': discountPrice,
//                                       //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                                       'Course Rating': data!.rating,
//                                       'Course Name': data!.title,
//                                       'Total Enrollments':
//                                           data!.totalEnrollment,
//                                     });
//                                   }

//                                   _courseDetailsBloc
//                                       .insertDataIntoDatabase(_myCartModel!);
//                                   // Navigator.pushNamed(context, my_carts);
//                                   gotoCartAndWait();
//                                 } else {
//                                   // print("#1123 User not loggedin");
//                                   // Navigator.pushNamed(context, login_page,
//                                   //     arguments: <String, bool>{'isPreviousPage': true}).then((value) =>
//                                   //
//                                   //     Common.isUserLogin().then((lggedin){
//                                   //
//                                   //       print("1123 loggedin $lggedin");
//                                   //       if(lggedin){
//                                   //         _courseDetailsBloc
//                                   //             .insertDataIntoDatabase(_myCartModel);
//                                   //         // Navigator.pushNamed(context, my_carts);
//                                   //         gotoCartAndWait();
//                                   //
//                                   //       }else{
//                                   //         print("1123 couldnot login agina");
//                                   //       }
//                                   //
//                                   //     })
//                                   //
//                                   // );

//                                 }
//                               });
//                             }
//                           }
//                           break;
//                         }
//                       case STR_ENROLL:
//                         {
//                           Common.isUserLogin().then((value) {
//                             if (value) {
//                               _courseDetailsBloc
//                                   .enrolledToFreeCourse(courseId, data)
//                                   .then((response) {
//                                 ToastHelper.showShort(response.message!);

//                                 if (response.data!.is_enrolled!) {
//                                   setState(() {
//                                     text = "Enrolled";
//                                   });
//                                   _courseDetailsBloc
//                                       .fetchCourseDetailsById(courseId);
//                                   isEnroll = true;
//                                   enrollLessons2 = lesson;
//                                 }
//                               });
//                             } else {
//                               // Navigator.pushNamed(context, login_page,
//                               //     arguments: <String, bool>{'isPreviousPage': true});
//                             }
//                           });

//                           break;
//                         }
//                     }
//                   },
//                 );
//               // return Container() ;
//               case Status.ERROR:
//                 // return Error(
//                 //   errorMessage: snapshot.data!.message,
//                 //   onRetryPressed: () =>
//                 //       _courseDetailsBloc.fetchCourseDetailsById(courseId),
//                 // );
//                 break;
//             }
//           }
//           return Container();
//         });
//   }

//   @override
//   void dispose() {
//     _courseDetailsBloc.dispose();
//     _tabController?.dispose();
//     super.dispose();
//   }

//   Widget updateWidget(CourseDetailsByIdResponse? response) {
//     if (response == null) {
//       return SizedBox();
//     }

//     if (isWishlisted == null) {
//       isWishlisted = response.isWishlisted;
//     }
//     late ElevatedButton button;
//     Text? expiredText;
//     late var courseFreeDays;

//     switch (response.action!.toLowerCase()) {
//       case STR_BUY_NOW:
//         {
//           button = ElevatedButton(
//             onPressed: () {
//               // print(_splashBloc.s);
//               // print("BUYNOW ${data.rating.toString()}");

//               Common.isUserLogin().then((value) {
//                 if (value) {
//                   if (_myCartModel != null) {
//                     if (Platform.isIOS) {
//                       _naviagetToInAppPay(
//                           _myCartModel!.cartId, _myCartModel!.appleProductId);
//                     } else {
//                       _courseDetailsBloc.insertDataIntoDatabase(_myCartModel!);
//                       if (data != null) {
//                         WebEngagePlugin.trackEvent(TAG_CART_ADDED, {
//                           'Category Id': int.parse(data!.categoryId!),
//                           'Category Name': "${data!.categoryName}",
//                           'Course Time Duration': "${data!.hoursLesson}",
//                           'Course Created By': courseCreatedBy,
//                           'Course Id': int.parse(data!.id!),
//                           'Course Level': "${data!.level}",
//                           'Language': data!.language,
//                           'Price': priceToSend,
//                           //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                           'Discount': discountPrice,
//                           //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                           //'Course Ratings': data.rating,
//                           'Course Name': data!.title,
//                           'Total Enrollments': data!.totalEnrollment,
//                           'Course Rating': data!.rating,
//                           'Course Duration': int.parse(data!.paidExpDays!),
//                         });
//                       }
//                       // Navigator.pushNamed(context, my_carts);
//                       gotoCartAndWait();
//                     }
//                   }
//                 } else {
//                   // print("#1123 login redirect");
//                   Navigator.pushNamed(context, login_page,
//                       arguments: <String, bool>{'isPreviousPage': true});
//                 }
//               });
//             },
//             child: Text(
//               "Buy Now",
//               style: TextStyle(color: Colors.white),
//             ),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                 (Set<MaterialState> states) {
//                   if (states.contains(MaterialState.pressed))
//                     return HexColor.fromHex(colorAccent);
//                   return HexColor.fromHex(
//                       colorAccent); // Use the component's default.
//                 },
//               ),
//             ),
//           );
//           if (int.parse(response.paidExpDays!) > 0) {
//             expiredText = Text(
//               "Purchase for ${response.paidExpDays} days",
//               style:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             );
//             courseFreeDays = true;
//           } else {
//             courseFreeDays = false;
//           }

//           break;
//         }
//       case STR_ENROLL:
//         {
//           button = ElevatedButton(
//             onPressed: () {
//               Common.isUserLogin().then((value) {
//                 if (value) {
//                   _courseDetailsBloc
//                       .enrolledToFreeCourse(courseId, data)
//                       .then((value) {
//                     ToastHelper.showShort(value.message!);
//                     setState(() {
//                       text = "Enrolled";
//                     });
//                   });
//                 } else {
//                   Navigator.pushNamed(context, login_page,
//                       arguments: <String, bool>{'isPreviousPage': true});
//                 }
//               });
//             },
//             child: Text(text, style: TextStyle(color: Colors.white)),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                 (Set<MaterialState> states) {
//                   var color;
//                   if (text == "Enrolled") {
//                     color = secondColor;
//                   } else {
//                     color = colorAccent;
//                   }
//                   if (states.contains(MaterialState.pressed))
//                     return HexColor.fromHex(color);
//                   return HexColor.fromHex(
//                       color); // Use the component's default.
//                 },
//               ),
//             ),
//           );
//           if (int.parse(response.freeExpDays!) > 0) {
//             expiredText = Text(
//               "Enroll free for ${response.freeExpDays} days",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//             courseFreeDays = true;
//           } else {
//             courseFreeDays = false;
//           }
//           break;
//         }
//       case STR_PURCHASED:
//         {
//           button = ElevatedButton(
//             onPressed: null,
//             child: Text("Purchased", style: TextStyle(color: Colors.white)),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                 (Set<MaterialState> states) {
//                   if (states.contains(MaterialState.pressed))
//                     return HexColor.fromHex(colorAccent);
//                   return HexColor.fromHex(
//                       colorAccent); // Use the component's default.
//                 },
//               ),
//             ),
//           );

//           courseFreeDays = true;
//           expiredText = Text(
//             response.expDate!,
//             style: TextStyle(color: Colors.white),
//           );
//           break;
//         }
//       case STR_ENROLLED:
//         {
//           button = ElevatedButton(
//             onPressed: null,
//             child: Text("Enrolled", style: TextStyle(color: Colors.white)),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                 (Set<MaterialState> states) {
//                   if (states.contains(MaterialState.pressed))
//                     return HexColor.fromHex(secondColor);
//                   return HexColor.fromHex(
//                       secondColor); // Use the component's default.
//                 },
//               ),
//             ),
//           );
//           courseFreeDays = true;

//           expiredText = Text(
//             response.expDate!,
//             style: TextStyle(
//                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//           );
//           break;
//         }
//       case STR_EXPIRED:
//         {
//           button = ElevatedButton(
//             onPressed: null,
//             child: Text("Expired", style: TextStyle(color: Colors.white)),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                 (Set<MaterialState> states) {
//                   if (states.contains(MaterialState.pressed))
//                     return HexColor.fromHex(colorAccent);
//                   return HexColor.fromHex(
//                       colorAccent); // Use the component's default.
//                 },
//               ),
//             ),
//           );
//           courseFreeDays = false;
//           break;
//         }
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         StreamBuilder<Object>(
//             stream: _courseDetailsBloc.certStream,
//             builder: (context, snapshot) {
//               print("THIISSPARTA ${snapshot.data.runtimeType}");
//               if (snapshot.hasData && snapshot.data is Response<dynamic>) {
//                 Response<dynamic> datafetched =
//                     snapshot.data as Response<dynamic>;
//                 CertificateStatusResponse certificateStatusResponse;
//                 // try {
//                 //   certificateStatusResponse =
//                 //       datafetched.data as CertificateStatusResponse;
//                 //   log(certificateStatusResponse.certificateStatus.toString());
//                 // } catch (e) {
//                 //   throw e;
//                 // }
//                 return Visibility(
//                   // visible: certificateStatusResponse.certificateStatus ?? false,
//                   child: InkWell(
//                     onTap: () {
//                       AppProgressDialog _progressDialog =
//                           new AppProgressDialog(context);
//                       _progressDialog.show();
//                       _courseDetailsBloc
//                           .generateCertificate(courseId, context)
//                           .then((value) {
//                         _progressDialog.hide();
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: ((context) => PdfViewerPage(
//                                       path: value,
//                                       name: _arguments!['title'] ??
//                                           "cert-$courseId",
//                                       arguments: {
//                                         'Category Id':
//                                             int.parse(data!.categoryId!),
//                                         'Category Name':
//                                             "${data!.categoryName}",
//                                         'Course Duration':
//                                             "${data!.hoursLesson}",
//                                         'Course Id': int.parse(data!.id!),
//                                         'Course Level': "${data!.level}",
//                                         'Language': data!.language,
//                                         'Course Name': data!.title,
//                                         'Rating': data!.rating,
//                                         'Certificate Generated Date': "",
//                                       },
//                                     ))));
//                         log("FILE RECEIVED" + value.toString());
//                       });
//                     },
//                     child: Container(
//                       // height: 40,
//                       // width: 160,
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(0.3),
//                               blurRadius: 8,
//                               spreadRadius: 1)
//                         ],
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white,
//                       ),
//                       // child: Center(
//                       //   child: Row(
//                       //     mainAxisAlignment: MainAxisAlignment.center,
//                       //     crossAxisAlignment: CrossAxisAlignment.center,
//                       //     children: [
//                       //       Icon(FontAwesome5.file_pdf),
//                       //       SizedBox(
//                       //         width: 4,
//                       //       ),
//                       //       Text("View Certificate")
//                       //     ],
//                       //   ),
//                       // ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container();
//               }
//             }),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Icon(
//                     FontAwesome.graduation_cap,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   Text(response.totalEnrollment.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ))
//                 ],
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
//                     child: Row(
//                       children: [
//                         // RatingBar.builder( itemSize: 20,
//                         //   initialRating: response.rating.toDouble(),
//                         //   itemBuilder: (context, _) => Icon(
//                         //     Icons.star,
//                         //     color: Colors.amber,
//                         //   ),
//                         //   ignoreGestures: true, onRatingUpdate: (double value) {
//                         //
//                         // },
//                         //
//                         // ),
//                         // SmoothStarRating(
//                         //     isReadOnly: true,
//                         //     size: 20,
//                         //     rating: response.rating.toDouble(),
//                         //     color: HexColor.fromHex(colorGolden),
//                         //     borderColor:
//                         //         HexColor.fromHex(bottomNavigationIdealState)),
//                         Text(" ( ${response.numberOfRatings} )",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ))
//                       ],
//                     ),
//                   ),
//                   Text(
//                     response.level!.toUpperCase(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Visibility(
//                         visible: (response.discountFlag == "1") ? true : false,
//                         child: Text(
//                           "${response.price}",
//                           style: TextStyle(
//                             decoration: TextDecoration.lineThrough,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Visibility(
//                           visible:
//                               (response.discountFlag == "1") ? true : false,
//                           child: SizedBox(
//                             width: 6,
//                           )),
//                       Text(
//                         (response.price == "Free")
//                             ? "Free"
//                             : (response.discountFlag == "1")
//                                 ? "${response.currency}. ${response.discountedPrice}"
//                                 : "${response.currency}. ${response.price}",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Visibility(
//                       visible: courseFreeDays,
//                       child: (expiredText == null) ? Container() : expiredText)
//                 ],
//               ),
//               // * Share, Heart and BuyNow Button
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       createShareableLink(response.shareableLink!,
//                           response.description, response.thumbnail!);

//                       analytics.logEvent(
//                           name: SHARE,
//                           parameters: <String, String?>{
//                             ITEM_ID: response.id,
//                             CONTENT_TYPE: response.categoryId
//                           });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
//                       child: Icon(
//                         Icons.share,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
//                       child: InkWell(
//                           onTap: () {
//                             //call api
//                             Common.isUserLogin().then((value) {
//                               analytics.logEvent(
//                                   name: ADD_TO_WISHLIST,
//                                   parameters: <String, String?>{
//                                     ITEM_ID: response.id,
//                                     ITEM_NAME: response.title,
//                                   });

//                               if (value) {
//                                 _courseDetailsBloc
//                                     .removeData(courseId)
//                                     .then((value) {
//                                   // setState(() {
//                                   //
//                                   // });

//                                   if (isWishlisted!) {
//                                     isWishlisted = false;
//                                     //Category Name
//                                     // Category Id
//                                     // Course Name
//                                     // Course Level
//                                     // Course Time Duration
//                                     // Price
//                                     // Course Duration
//                                     // Course Created By
//                                     // Course Ratings
//                                     // Total Enrollments
//                                     // Language

//                                     if (data != null) {
//                                       WebEngagePlugin.trackEvent(
//                                           TAG_WISHLIST_REMOVED, {
//                                         'Category Id':
//                                             int.parse(data!.categoryId!),
//                                         'Category Name':
//                                             "${data!.categoryName}",
//                                         'Course Time Duration':
//                                             "${data!.hoursLesson}",
//                                         'Course Created By': courseCreatedBy,
//                                         'Course Id': int.parse(data!.id!),
//                                         'Course Level': "${data!.level}",
//                                         'Language': data!.language,
//                                         'Discount': discountPrice,
//                                         'Course Duration':
//                                             int.parse(data!.paidExpDays!),
//                                         'Price': priceToSend,
//                                         // data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                                         'Course Ratings': data!.rating,
//                                         'Course Name': data!.title,
//                                         'Total Enrollments':
//                                             data!.totalEnrollment,
//                                       });
//                                     }

//                                     _courseDetailsBloc.updateWish(isWishlisted);
//                                   } else {
//                                     isWishlisted = true;
//                                     if (data != null) {
//                                       WebEngagePlugin.trackEvent(
//                                           TAG_WISHLIST_ADDED, {
//                                         'Category Id':
//                                             int.parse(data!.categoryId!),
//                                         'Category Name':
//                                             "${data!.categoryName}",
//                                         'Course Time Duration':
//                                             "${data!.hoursLesson}",
//                                         'Course Duration':
//                                             int.parse(data!.paidExpDays!),
//                                         'Course Created By': courseCreatedBy,
//                                         'Course Id': int.parse(data!.id!),
//                                         'Course Level': "${data!.level}",
//                                         'Language': data!.language,
//                                         'Price': priceToSend,
//                                         //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
//                                         'Course Ratings': data!.rating,
//                                         'Discount': discountPrice,
//                                         'Course Name': data!.title,
//                                         'Total Enrollments':
//                                             data!.totalEnrollment,
//                                       });
//                                     }

//                                     _courseDetailsBloc.updateWish(isWishlisted);
//                                   }

//                                   ToastHelper.showShort(value.message!);
//                                 });
//                               } else {
//                                 Navigator.pushNamed(context, login_page,
//                                     arguments: <String, bool>{
//                                       'isPreviousPage': true
//                                     });
//                               }
//                             });
//                           },
//                           // * Heart button
//                           child: StreamBuilder<bool>(
//                               stream: _courseDetailsBloc.wishStream,
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return Icon(
//                                     snapshot.data!
//                                         ? AntDesign.heart
//                                         : AntDesign.hearto,
//                                     color: isWishlisted!
//                                         ? Colors.white
//                                         : Colors.white,
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               }))),
//                   button

//                   // color: HexColor.fromHex(colorAccent),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void callDynamicLink() async {
//     FirebaseDynamicLinks.instance.onLink.listen((event) {
//       _handleDynamicLink(event.link);
//     });
//   }

//   _handleDynamicLink(Uri deepLink) async {
//     print("deeplink: $deepLink $courseId");
//     if (deepLink == null) {
//       _courseDetailsBloc.fetchCourseDetailsById(courseId);
//       return;
//     }
//     if (deepLink.toString().contains("course")) {
//       var parts = deepLink.toString().split("/");
//       courseId = parts.last;
//       _courseDetailsBloc.fetchCourseDetailsById(courseId);
//     }
//   }

//   void createShareableLink(
//       String shareableLink, String? description, String thumbnail) async {
//     WebEngagePlugin.trackEvent(TAG_COURSE_LINK_SHARE, {
//       'Course Id': int.parse(data!.id!),
//       'Course Name': data!.title,
//     });

//     var converted = Common.parseHtmlString(description);

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://share.mero.school',
//       link: Uri.parse(shareableLink),
//       androidParameters: AndroidParameters(packageName: 'school.mero.lms'),
//       iosParameters: IOSParameters(bundleId: 'school.mero.ios'),
//       socialMetaTagParameters: SocialMetaTagParameters(
//           title: 'Check the latest course in Mero School',
//           description: converted,
//           imageUrl: Uri.parse(thumbnail)),
//     );

//     final ShortDynamicLink shortDynamicLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//     final Uri shortUrl = shortDynamicLink.shortUrl;
//     await Share.share("Check the latest course " + shortUrl.toString());
//   }

//   _naviagetToInAppPay(String? courseId, String? productId) async {
//     final result = await Navigator.pushNamed(context, in_app_product_list,
//         arguments: <String, dynamic>{
//           "productId": productId,
//           "courseId": courseId
//         });

//     if (result == true) {
//       _courseDetailsBloc.fetchCourseDetailsById(courseId);
//     }
//   }

//   // bool get wantKeepAlive => true;
// }
