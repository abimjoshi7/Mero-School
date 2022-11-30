import 'dart:async';

import 'package:intl/intl.dart';
import 'package:mero_school/data/models/request/courses_request.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/my_valid_course_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class TempCoursesBloc {
  late MyNetworkClient _myNetworkClient;

  initBloc() {
    _myNetworkClient = MyNetworkClient();
  }

  List<CourseDetailsByIdResponse> temp_courses = [];

  Future<void> fetchAndLog(
      String? courses, String tag, String txnId, String agent) async {
    var t = await Preference.getString(token);

    if (temp_courses.isEmpty) {
      CoursesRequest request = new CoursesRequest(
          authToken: Common.checkNullOrNot(t), courseid: courses);
      var courseResponse = await _myNetworkClient.fetchCoursesDetails(request);
      if (courseResponse.data != null) {
        courseResponse.data!.forEach((element) {
          temp_courses.add(element);
        });
      }
    }

    var sumTotal = 0.0;
    temp_courses.forEach((element) {
      sumTotal = sumTotal + double.parse(element.price.toString());
    });

    print("temp_courses: ${temp_courses.length}");

    temp_courses.forEach((element) {
      if (tag == TAG_CHECKOUT_RESTARTED) {
        logCheckoutRetry(element, sumTotal, temp_courses.length, txnId, agent);
      } else if (tag == TAG_SG_COURSE_CHECKOUT_CANCLE) {
        logCancelled(element, sumTotal, temp_courses.length, txnId, agent);
      } else if (tag == TAG_SG_COURSE_CHECKOUT_FAILURE) {
        logFailure(element, sumTotal, temp_courses.length, txnId, agent);
      } else if (tag == TAG_SG_COURSE_CHECKOUT_COMPLETE) {
        logSuccess(element, sumTotal, temp_courses.length, txnId, agent, null);
      }
    });
  }

  void logCheckoutRetry(CourseDetailsByIdResponse course, double sumTotal,
      int length, String txnId, String agent) {
    var priceToSend = 0.0;
    var discountPrice = 0.0;
    var courseCreatedBy = "";

    courseCreatedBy = course.instructorName ?? "";
    if (course.price == "Free" || course.price!.isEmpty) {
      priceToSend = 0.0;
    } else if (course.discountFlag!.trim() == "1") {
      priceToSend = double.parse(course.discountedPrice!);
      discountPrice =
          double.parse(course.price!) - double.parse(course.discountedPrice!);
    } else {
      priceToSend = double.parse(course.price!);
    }
    WebEngagePlugin.trackEvent(TAG_CHECKOUT_RESTARTED, {
      'Category Id': int.parse(course.categoryId!),
      'Category Name': "${course.categoryName}",
      'Course Id': int.parse(course.id!),
      // 'Purchase Status': course.isPurchased,
      'Course Level': "${course.level}",
      'Price':
          priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      // 'Payment Mode':'bank',
      // 'Course Rating': course.rating,
      'Total Amount': sumTotal,
      'Language': course.language,
      'Course Name': course.title,
      'No. Of Courses': length,
      'Course Created By': course.instructorName ?? "",
      'Course Duration': int.parse(course.paidExpDays!),
      'Discount': discountPrice,
    });
  }

  void logSuccess(
      CourseDetailsByIdResponse course,
      double sumTotal,
      int? length,
      String txnId,
      String agent,
      MyValidCourseResponse? myValidCourseResponse) {
    var formatted;

    if (myValidCourseResponse != null) {
      myValidCourseResponse.data!.forEach((element) {
        if (element.course_id == course.id) {
          var expTemp = element.plan_exp_date!;
          // DateTime parsedDate = DateTime.parse(exp_temp);
          // final DateFormat formatter =
          //     DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
          // exp = formatter.format(parsedDate);


          DateTime parsedDate = DateTime.parse("${expTemp}T23:59:59.000Z");
          // final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat("'~t'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

          formatted = formatter.format(parsedDate);

        }
      });
    }

    var priceToSend = 0.0;
    var discountPrice = 0.0;
    var courseCreatedBy = "";

    courseCreatedBy = course.instructorName ?? "";
    if (course.price == "Free" || course.price!.isEmpty) {
      priceToSend = 0.0;
    } else if (course.discountFlag!.trim() == "1") {
      priceToSend = double.parse(course.discountedPrice!);
      discountPrice =
          double.parse(course.price!) - double.parse(course.discountedPrice!);
    } else {
      priceToSend = double.parse(course.price!);
    }

    WebEngagePlugin.trackEvent(TAG_SG_COURSE_CHECKOUT_COMPLETE, {
      'Category Id': int.parse(course.categoryId!),
      'Category Name': "${course.categoryName}",
      'Course Id': int.parse(course.id!),
      'Course Level': "${course.level}",
      'Price':
          priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Total Amount':
          sumTotal, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Discount':
          discountPrice, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Language': course.language,
      'Course Name': course.title,
      'Course Created By': course.instructorName,
      'No. Of Courses': length,
      'Order Id': txnId,
      'Payment Mode': agent,
      'Total Enrollments': course.totalEnrollment,
    });

    // print("{{{ ${course.expDate} }}}");
    //
    //
    // DateTime parsedDate = DateTime.parse(course.expDate);

    WebEngagePlugin.trackEvent(TAG_ENROLL_COURSE, {
      'Category Id': int.parse(course.categoryId!),
      'Category Name': "${course.categoryName}",
      'Course Id': int.parse(course.id!),
      'Course Level': "${course.level}",
      'Price':
          priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Discount':
          discountPrice, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Course Language': course.language,
      'Course Time Duration': course.hoursLesson,
      'Course Name': course.title,
      'Course Created By': course.instructorName,
      'Order Id': txnId,
      'Payment Mode': agent,
      'Total Enrollments': course.totalEnrollment,
      'Course Expiry Date': course.expDate,
      'Course Expiry': formatted,
      'Free Enrollment': false,
      'Course Ratings': course.rating
    });
  }

  void logCancelled(CourseDetailsByIdResponse course, double sumTotal,
      int? length, String txnId, String agent) {
    var priceToSend = 0.0;
    var discountPrice = 0.0;
    var courseCreatedBy = "";

    courseCreatedBy = course.instructorName ?? "";
    if (course.price == "Free" || course.price!.isEmpty) {
      priceToSend = 0.0;
    } else if (course.discountFlag!.trim() == "1") {
      priceToSend = double.parse(course.discountedPrice!);
      discountPrice =
          double.parse(course.price!) - double.parse(course.discountedPrice!);
    } else {
      priceToSend = double.parse(course.price!);
    }

    WebEngagePlugin.trackEvent(TAG_SG_COURSE_CHECKOUT_CANCLE, {
      'Category Id': int.parse(course.categoryId!),
      'Category Name': "${course.categoryName}",
      'Course Id': int.parse(course.id!),
      'Course Level': "${course.level}",
      'Price':
          priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Total Amount':
          sumTotal, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Discount':
          discountPrice, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Language': course.language,
      'Course Name': course.title,
      'Course Created By': course.instructorName,
      'Course Ratings': course.rating,
      'Payment Mode': agent,
      'Total Enrollments': course.totalEnrollment,
      //'No. Of Courses':myCartList.length,
    });
  }

  void logFailure(CourseDetailsByIdResponse course, double sumTotal,
      int? length, String txnId, String agent) {
    var priceToSend = 0.0;
    var discountPrice = 0.0;
    var courseCreatedBy = "";

    courseCreatedBy = course.instructorName ?? "";
    if (course.price == "Free" || course.price!.isEmpty) {
      priceToSend = 0.0;
    } else if (course.discountFlag!.trim() == "1") {
      priceToSend = double.parse(course.discountedPrice!);
      discountPrice =
          double.parse(course.price!) - double.parse(course.discountedPrice!);
    } else {
      priceToSend = double.parse(course.price!);
    }

    WebEngagePlugin.trackEvent(TAG_SG_COURSE_CHECKOUT_FAILURE, {
      'Category Id': int.parse(course.categoryId!),
      'Category Name': "${course.categoryName}",
      'Course Id': int.parse(course.id!),
      'Course Level': "${course.level}",
      'Price':
          priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Total Amount':
          sumTotal, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Discount':
          discountPrice, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      // 'Language': course.language,
      'Course Name': course.title,
      // 'Course Created By': course.instructorName,
      //'No. Of Courses':myCartList.length,
      'Order Id': txnId,
      'Payment Mode': agent,
      'Status': 'FAILED'
      // 'Total Enrollments':course.totalEnrollment,
    });
  }
}
