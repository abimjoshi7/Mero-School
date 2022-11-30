import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/TempCoursesBloc.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/my_valid_course_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/TagMeta.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class SmartPaymentPage extends StatefulWidget {
  @override
  _SmartPaymentPageState createState() => _SmartPaymentPageState();
}

class _SmartPaymentPageState extends State<SmartPaymentPage> {
  bool isLoading = true;
  final _key = UniqueKey();
  Map? _arguments;

  String? subscriptionId = "";

  late TempCoursesBloc _bloc;

  String agent = "Smart Gateway";
  String txnId = "";
  String status = "";

  bool? retry = false;

  @override
  void initState() {
    _bloc = new TempCoursesBloc();
    _bloc.initBloc();
    super.initState();
  }

  @override
  void dispose() {
    if (status.isEmpty) {
      //call cancle
      //cancle
      if (subscriptionId!.isEmpty) {
        //course

        if (course_id!.isEmpty) {
          logCancleCart();
        } else {
          // course_id
          _bloc.fetchAndLog(
              course_id, TAG_SG_COURSE_CHECKOUT_CANCLE, txnId, agent);
        }
      } else {
        //plan
        logCanclePlan();
      }
    } else {
      print("SuBSCRIPTION_ID $subscriptionId");

      if (subscriptionId.toString().isNotEmpty) {
        if (status.toLowerCase() == "failed") {
          //plan sg failed
          logPlanFailed();
        } else {
          //plan sg success
          logPlanComplete();
        }
      } else {
        print(status.toLowerCase() + "{} STATUS {}");
        if (status.toLowerCase() == "failed") {
          //course sg failed
          print("logFailureCart ${course_id.toString()}");

          if (course_id.toString().isEmpty || course_id.toString() == "null") {
            print("logFailureCart");

            logFalureCart();
          } else {
            print("fetchAandLogelse $course_id");

            _bloc.fetchAndLog(
                course_id, TAG_SG_COURSE_CHECKOUT_FAILURE, txnId, agent);
          }
        } else {
          //course sg sucess

          if (course_id.toString().isEmpty || course_id.toString() == "null") {
            logSuccessCart();
          } else {
            _bloc.fetchAndLog(
                course_id, TAG_SG_COURSE_CHECKOUT_COMPLETE, txnId, agent);
          }
        }
      }
    }

    super.dispose();
  }

  PlanTags tags = PlanTags();

  void logPlanRetry() {
    WebEngagePlugin.trackEvent(TAG_SG_PLAN_CHECKOUT_RESTARTED, {
      'Plan Id': tags.planId,
      'Plan Name': tags.planName,
      'Package Name': tags.packageName,
      'Package Id': tags.packageId,
      'Validity': tags.validity,
      'Price': tags.price,
      'Enrolled Status': tags.enrolledStatus
    });
  }

  void logPlanComplete() {
    WebEngagePlugin.trackEvent(TAG_SG_PLAN_PAYMENT_SUCCESS, {
      'Plan Name': tags.planName,
      'Plan Id': tags.planId,
      'Package Id': tags.packageId,
      'Enrolled Status': true, // added this as st8ic tags.enrolledStatus,
      'Package Name': tags
          .packageName, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Price': tags.price,
      'Payment Mode': agent,
      'Order Id': txnId,
      'Validity': tags.validity
      //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
    });

    WebEngagePlugin.trackEvent(TAG_PLAN_ENROLLED, {
      'Plan Name': tags.planName,
      'Plan Id': tags.planId,
      'Package Id': tags.packageId,
      'Enrolled Status': true, // tags.enrolledStatus,
      'Package Name': tags
          .packageName, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Price': tags.price,
      'Payment Mode': agent,
      'Order Id': txnId,
      'Validity': tags.validity,
      //'Plan Enrolled': true,
      'Total Courses': tags.numOfCourse,
      //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
    });
  }

  void logPlanFailed() {
    print(tags.validity);
    WebEngagePlugin.trackEvent(TAG_SG_PLAN_PAYMENT_FAILURE, {
      'Plan Name': tags.planName,
      'Plan Id': tags.planId,
      'Package Id': tags.packageId,
      'Enrolled Status': tags.enrolledStatus,
      'Package Name': tags
          .packageName, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Validity': tags
          .validity, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Price': tags.price,
      'Payment Mode': agent,
      'Order Id': txnId,
      'No of Courses': tags.numOfCourse,
      'Status': status
      //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
    });
  }

  void logCanclePlan() {
    print(tags.validity);
    WebEngagePlugin.trackEvent(TAG_SG_PLAN_CHECKOUT_CANCELLED, {
      'Plan Name': tags.planName,
      'Plan Id': tags.planId,
      'Package Id': tags.packageId,
      'Enrolled Status': tags.enrolledStatus,
      'Package Name': tags
          .packageName, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Validity': tags
          .validity, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
      'Price': tags.price,
      'Payment Mode': 'SmartGateway',
      'Reason': 'User Cancelled'
      //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
    });
  }

  void logFalureCart() {
    var myCartList = _arguments!['carts'];

    var sumTotal = 0.0;
    myCartList.forEach((element) {
      sumTotal = sumTotal + double.parse(element.price);
    });

    myCartList.forEach((element) {
      var tagString = element.tagsmeta.toString();
      print(element.tagsmeta);
      var course = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

      _bloc.logFailure(course, sumTotal, myCartList.length, txnId, agent);
    });
  }

  void logCancleCart() {
    var myCartList = _arguments!['carts'];

    var sumTotal = 0.0;
    myCartList.forEach((element) {
      sumTotal = sumTotal + double.parse(element.price);
    });

    myCartList.forEach((element) {
      var tagString = element.tagsmeta.toString();
      print(element.tagsmeta);
      var course = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

      _bloc.logCancelled(course, sumTotal, myCartList.length, txnId, agent);
    });
  }

  Future<void> logSuccessCart() async {
    var networkClinet = MyNetworkClient();
    var t = await Preference.getString(token);

    MyValidCourseResponse validCourseResponse =
        await networkClinet.fetchValidCourse(Common.checkNullOrNot(t));

    print("LOGSUCCESSKART");
    var myCartList = _arguments!['carts'];

    var sumTotal = 0.0;
    myCartList.forEach((element) {
      sumTotal = sumTotal + double.parse(element.price.toString());
    });

    myCartList.forEach((element) async {
      var tagString = element.tagsmeta.toString();
      var course = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

      _bloc.logSuccess(course, sumTotal, myCartList.length, txnId, agent,
          validCourseResponse);
    });
  }

  String? course_id;

  late var _webViewController;
  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    subscriptionId = _arguments!['subscription_id'];

    if (_arguments != null && _arguments!.containsKey('course_id')) {
      course_id = _arguments!['course_id'];
      _bloc.fetchAndLog(course_id, TAG_CHECKOUT_RESTARTED, txnId, agent);
    }

    if (subscriptionId.toString().isNotEmpty &&
        subscriptionId.toString() != "null") {
      tags.planName = _arguments!['plan_name'];
      tags.planId = int.parse(_arguments!['plan_id']);
      tags.packageName = _arguments!['package_name'];
      tags.packageId = _arguments!['package_id'];
      tags.enrolledStatus = _arguments!['enrolled_status'];
      tags.price = _arguments!['price'];
      tags.validity = _arguments!['validity'];
      tags.numOfCourse = _arguments!['no_of_course'];

      if (_arguments!.containsKey('retry')) {
        retry = _arguments!['retry'];

        if (retry!) {
          logPlanRetry();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
              key: _key,
              initialOptions: InAppWebViewGroupOptions(
                  android:
                      AndroidInAppWebViewOptions(useHybridComposition: true)),
              // initialUrlRequest: ,
              initialUrlRequest:
                  URLRequest(url: Uri.parse(_arguments!['paymentUrl'])),
              // initialUrlRequest: URLRequest(url: Uri.parse("https://demo.mero.school/home/transaction_failed_mobile_respond/FAILED/c00923e3625e")),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                //SmartFunction.withAgent('KHALTI')
                _webViewController.addJavaScriptHandler(
                    handlerName: "withAgent",
                    callback: (args) {
                      print("args: $args");

                      List<String> stringList =
                          (args as List<dynamic>).cast<String>();

                      status = stringList[0];
                      txnId = stringList[1];
                      agent = stringList[2];

                      print("args: $status, $txnId, $agent");

                      // return args.reduce((curr, next) => curr + next);
                    });

                _webViewController.addJavaScriptHandler(
                    handlerName: "onBack",
                    callback: (args) {
                      Navigator.of(context).pop(status);
                      // return args.reduce((curr, next) => curr + next);
                    });
              },
              onLoadStop: (controller, uri) {
                var url = uri.toString();

                debugPrint("My Url $url");
                if (isLoading) {
                  setState(() {
                    isLoading = false;
                  });
                }

                if (url.contains("mobile_respond")) {
                  if (url.contains("mobile_respond/Success")) {
                    deleteAllCartData();
                    // Navigator.pushNamed(context, my_transaction_history);
                  }
                }
              }),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }

  void deleteAllCartData() async {
    var db = AppDatabase.instance;
    db.delete(db.myCartModel).go();

    // await locator<AppDatabase>().deleteAllCartData();
  }
}
