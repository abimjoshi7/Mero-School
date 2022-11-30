import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/data/models/response/bank_submit_response.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/bank_transfer/bank_detail_response.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/TagMeta.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class BankDetailBloc extends BaseBloc {
  StreamController? _dataController;
  StreamController? _dataControllerFile;
  StreamController? _dataControllerDate;

  StreamController? _dataControllerSubmit;

  late StreamController _dataDropDownController;

  late bool _isStreaming;

  StreamSink<Response<PickedFile>> get fileSink =>
      _dataControllerFile!.sink as StreamSink<Response<PickedFile>>;
  Stream<Response<PickedFile>> get fileStream =>
      _dataControllerFile!.stream as Stream<Response<PickedFile>>;

  StreamSink<Response<BankDetailResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<BankDetailResponse>>;
  Stream<Response<BankDetailResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<BankDetailResponse>>;

  StreamSink<Response<String>> get dateSink =>
      _dataControllerDate!.sink as StreamSink<Response<String>>;
  Stream<Response<String>> get dateStream =>
      _dataControllerDate!.stream as Stream<Response<String>>;

  StreamSink<Response<BankSubmitResponse>> get submitSink =>
      _dataControllerSubmit!.sink as StreamSink<Response<BankSubmitResponse>>;
  Stream<Response<BankSubmitResponse>> get submitStream =>
      _dataControllerSubmit!.stream as Stream<Response<BankSubmitResponse>>;

  StreamSink<Response<DataListBean>> get dropDownSink =>
      _dataDropDownController.sink as StreamSink<Response<DataListBean>>;
  Stream<Response<DataListBean>> get dropDownStream =>
      _dataDropDownController.stream as Stream<Response<DataListBean>>;

  initBloc() {
    _dataController = StreamController<Response<BankDetailResponse>>();
    _dataControllerFile = StreamController<Response<PickedFile>>();
    _dataControllerDate = StreamController<Response<String>>();
    _dataControllerSubmit =
        StreamController<Response<BankSubmitResponse>>.broadcast();
    _dataDropDownController = StreamController<Response<DataListBean>>();

    myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Getting a Data!'));

    var t = await Preference.getString(token);
    try {
      BankDetailResponse response =
          await myNetworkClient.fetchBankAccountList(Common.checkNullOrNot(t));

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  submitDeposited(
      String name,
      String contact,
      String account,
      String branch,
      String amount,
      String date,
      String path,
      String courseId,
      String courseAmount,
      String subscriptionId,
      List<MyCartModelData>? carts,
      PlanTags tags) async {
    print(
        "print data: $name, $contact, $account, $branch, $amount, $date, $path, $path, $courseId, $courseAmount, $subscriptionId, $carts, $tags");

    submitSink.add(Response.loading("submitting your data.."));

    try {
      var t = await Preference.getString(token);

      var tokens = Common.checkNullOrNot(t);
      var maps = Map<String, String>();
      maps["depositer_name"] = name;
      maps["bank_branch"] = branch;
      maps["deposited_date"] = date;
      maps["deposited_amount"] = amount;
      maps["course_id"] = courseId;
      maps["course_amount"] = courseAmount;
      maps["subscription_id"] = subscriptionId;
      maps["mobile_number"] = contact;
      maps["deposited_account_id"] = account;
      maps["auth_token"] = tokens;
      maps["system"] = "app";

      var dType = "Plan";
      if (courseId.isNotEmpty && courseId != "null") {
        dType = "Course";
      }

      maps["deposited_type"] = dType;

      log("print data: " + json.encode(maps).toString());

      BankSubmitResponse response =
          await myNetworkClient.bankSubmitResponse(path, tokens, maps);

      if (dType == "Course") {
        carts!.forEach((element) {
          var priceToSend = 0.0;
          var discountPrice = 0.0;
          var courseCreatedBy = "";

          var tagString = element.tagsmeta.toString();
          print(element.tagsmeta);
          var course =
              CourseDetailsByIdResponse.fromJson(json.decode(tagString));

          courseCreatedBy = course.instructorName ?? "";
          if (course.price == "Free" || course.price!.isEmpty) {
            priceToSend = 0.0;
          } else if (course.discountFlag!.trim() == "1") {
            priceToSend = double.parse(course.discountedPrice!);
            discountPrice = double.parse(course.price!) -
                double.parse(course.discountedPrice!);
          } else {
            priceToSend = double.parse(course.price!);
          }

          WebEngagePlugin.trackEvent(TAG_COMPLETE_BANK_DEPOSIT_FOR_COURSE, {
            'Category Id': int.parse(course.categoryId!), //
            'Category Name': "${course.categoryName}", //
            'Course Id': int.parse(course.id!), //
            'Course Level': "${course.level}", //
            'Price':
                priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
            'Payment Mode': 'bank',
            'Amount': int.parse(amount), //
            'Course Name': course.title, //
            'Total Courses': carts.length, //
            'Deposit Date': date, //
            'Enrolled Status': course.isFreeUsed
          });
        });
      } else {
        WebEngagePlugin.trackEvent(TAG_COMPLETE_BANK_DEPOSIT_FOR_PLAN, {
          'Plan Name': tags.planName,
          'Plan Id': tags.planId,
          'Package Id': tags.packageId,
          'Enrolled Status': tags.enrolledStatus,
          'Package Name': tags.packageName,
          'Amount': int.parse(amount), //
          'Payment Mode': 'bank',
          'Deposit Date': date, //
        });
      }

      //read cart

      ///

      submitSink.add(Response.completed(response));
    } catch (e) {
      submitSink.add(Response.error(e.toString()));

      print(e);
    }
  }

  fetchImage() async {
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    try {
      fileSink.add(Response.completed(pickedFile));
    } catch (e) {
      fileSink.add(Response.error(e.toString()));
    }
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
    _dataControllerFile?.close();
    _dataControllerDate?.close();
    _dataControllerSubmit?.close();
  }

  Future<void> fetchDate(BuildContext context) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light()
            ..copyWith(
                colorScheme: ColorScheme.light().copyWith(
              primary: Colors.red,
            )),
          child: child!,
        );
      },
    );

    if (picked != null) {
      try {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        print("$formattedDate");
        dateSink.add(Response.completed(formattedDate));
      } catch (e) {
        fileSink.add(Response.error(e.toString()));
      }
    }
  }

  void updateSelected(DataListBean? newValue) {
    dropDownSink.add(Response.completed(newValue));
  }
}
