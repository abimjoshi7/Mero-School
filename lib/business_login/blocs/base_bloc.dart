import 'package:intl/intl.dart';
import 'package:mero_school/data/models/request/enrolled_to_free_course_request.dart';
import 'package:mero_school/data/models/request/smart_course_payment_request.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/enrolled_to_free_course_response.dart';
import 'package:mero_school/data/models/response/remove_wish_list_response.dart';
import 'package:mero_school/data/models/response/smart_course_payment_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../app_database.dart';

class BaseBloc {
  late MyNetworkClient myNetworkClient;
  var db = AppDatabase.instance;

  BaseBloc() {
    myNetworkClient = MyNetworkClient();
  }

  Future<RemoveWishListResponse> removeData(String? courseId) async {
    var t = await Preference.getString(token);

    RemoveWishListResponse response = await myNetworkClient.removeWishListItem(
        Common.checkNullOrNot(t), courseId);
    return response;
  }

  void insertDataIntoDatabase(MyCartModelData model) async {
    analytics.logEvent(name: REMOVE_FROM_CART, parameters: <String, dynamic>{
      ITEM_ID: model.cartId,
      ITEM_NAME: model.title,
      ITEM_CATEGORY: "course",
      PRICE: model.price,
      VALUE: model.price,
    });

    db.into(db.myCartModel).insert(model);

    //print("readyToInsertInToCartDb:  ${model}" );
    // await locator<AppDatabase>().insertCartData(model);
  }

  Future<EnrolledToFreeCourseResponse> enrolledToFreeCourse(
      String? courseId, CourseDetailsByIdResponse? data) async {
    var t = await Preference.getString(token);

    EnrolledToFreeCourseRequest request = EnrolledToFreeCourseRequest(
        authToken: Common.checkNullOrNot(t), courseId: courseId);

    EnrolledToFreeCourseResponse response =
        await myNetworkClient.enrolledToFreeCourse(request);

    if (response.data!.is_enrolled!) {
      if (data != null) {
        //NOTE: Changed by -Saugat

        var priceToSend = 0.0;
        var discountPrice = 0.0;
        //print(data.toString());
        // Discount
        // Course Language
        // Course Expiry Date
        // Free Enrollment
        // Total Enrollments
        if (data.price == "Free" || data.price!.isEmpty) {
          priceToSend = 0.0;
        } else if (data.discountFlag!.trim() == "1") {
          priceToSend = double.parse(data.discountedPrice!);
          discountPrice =
              double.parse(data.price!) - double.parse(data.discountedPrice!);
        } else {
          priceToSend = double.parse(data.price!);
        }
        //print( "DISCOUNT: $discountPrice PRICE: $priceToSend");

        //  //Changed by Saugat end
        // print("{{{ ${data.expDate} }}}");
        //
        //
        DateTime parsedDate =
            DateTime.parse("${response.data!.plan_exp_date!}T23:59:59.000Z");
        // final DateTime now = DateTime.now();
        final DateFormat formatter =
            DateFormat("'~t'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

        var formateed = formatter.format(parsedDate);

        WebEngagePlugin.trackEvent(TAG_ENROLL_COURSE, {
          'Category Id': int.parse(data.categoryId!),
          'Category Name': "${data.categoryName}",
          'Course Time Duration': "${data.hoursLesson}",
          'Course Created By': data.instructorName,
          'Course Id': int.parse(data.id!),
          'Free Enrollment': true,
          'Course Expiry Date': data.expDate,
          'Course Expiry': formateed,
          'Course Level': "${data.level}",
          'Course Language': data.language,
          'Price':
              priceToSend, //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
          'Discount':
              discountPrice, //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
          'Course Ratings': data.rating,
          'Course Name': data.title,
          'Total Enrollments': data.totalEnrollment,
        });
      }
    }

    return response;
  }

  // Future<FacebookUserProfile> socialUserDetail(
  //     String token) async {
  //
  //   // final result = await facebookSignIn.logIn(['email']);
  //   // final token = result.accessToken.token;
  //
  //   return await myNetworkClient.facebookProfile(token);
  // }

  Future<SmartCoursePaymentResponse> smartCoursePayment(String? course,
      String? courseId, String? totalPrice, String? validity, String type,
      {String? coupenCode}) async {
    var t = await Preference.getString(token);

    SmartCoursePaymentResponse response;

    if (type != "plan") {
      SmartCoursePaymentRequest request = SmartCoursePaymentRequest(
          authToken: Common.checkNullOrNot(t),
          courses: course,
          coursesId: courseId,
          endside: "app",
          totalPrice: totalPrice);

      if (coupenCode != null && coupenCode.isNotEmpty) {
        request.couponCode = coupenCode;
      }

      response = await myNetworkClient.smartCoursePayment(request);
    } else {
      SmartPlanPaymentRequest request = SmartPlanPaymentRequest(
          authToken: Common.checkNullOrNot(t),
          courses: course,
          coursesId: courseId,
          endside: "app",
          totalPrice: totalPrice,
          planValid: validity);

      response = await myNetworkClient.smartPlanPayment(request);
    }
    return response;
  }
}
