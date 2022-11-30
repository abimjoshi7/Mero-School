import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/data/models/response/bank_submit_response.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/account/account_page.dart';
import 'package:mero_school/presentation/pages/bank_transfer/bank_detail_response.dart';
import 'package:mero_school/presentation/pages/bank_transfer/bank_details_bloc.dart';
import 'package:mero_school/presentation/widgets/custom_image_dialog_local.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/utils/app_message_dialog.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/TagMeta.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class BankTransferPage extends StatefulWidget {
  BankTransferPage({Key? key}) : super(key: key);

  @override
  _BankTransferPageState createState() {
    return _BankTransferPageState();
  }
}

class _BankTransferPageState extends State<BankTransferPage> {
  late BankDetailBloc bankDetailBloc;

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  Map? _arguments;
  late AppProgressDialog _progressDialog;
  late AppMessageDialog appMessageDialog;

  PlanTags tags = PlanTags();

  @override
  void initState() {
    bankDetailBloc = BankDetailBloc();
    _progressDialog = new AppProgressDialog(context);
    appMessageDialog =
        new AppMessageDialog(context, callback: callBack, action: "Okay");

    super.initState();
  }

  void logCanclePlan() {
    WebEngagePlugin.trackEvent(TAG_BANK_PAYMENT_PLAN_CANCELLED, {
      'Plan Name': tags.planName,
      'Plan Id': tags.planId,
      'Package Id': tags.packageId,
      'Enrolled Status': tags.enrolledStatus,
      'Package Name': tags
          .packageName //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
    });
  }

  void logCancleCart() {
    var myCartList = _arguments!['carts'];

    myCartList.forEach((element) {
      var priceToSend = 0.0;
      var discountPrice = 0.0;
      var courseCreatedBy = "";

      var tagString = element.tagsmeta.toString();
      print(element.tagsmeta);
      var course = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

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

      WebEngagePlugin.trackEvent(TAG_BANK_DEPOSIT_FOR_COURSE_CANCELLED, {
        'Category Id': int.parse(course.categoryId!),
        'Category Name': "${course.categoryName}",
        'Course Id': int.parse(course.id!),
        'Course Level': "${course.level}",
        'Price':
            priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
        'Language': course.language,
        'Course Name': course.title,
        'No. Of Courses': myCartList.length,
      });
    });
  }

  void callBack(String uid) {
    appMessageDialog.hide();

    print("$uid");
    if (uid == "success") {
      print("redirect:: ");
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    print("IsSuccess: $isSuccess");

    if (!isSuccess) {
      print("IsSuccess: ${_arguments!['subscription_id']}");

      if (_arguments!['subscription_id'].toString().isNotEmpty) {
        print("IsSuccess:IS NOT EMPTY");
        logCanclePlan();
      } else {
        print("IsSuccess:IS NOT EMPTY");
        logCancleCart();
      }
    }

    super.dispose();
  }

  bool isSuccess = false;

  Future<String?> getToken() async {
    var t = await Preference.getString(token);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (_arguments!['subscription_id'].toString().isNotEmpty) {
      tags.planName = _arguments!['plan_name'];
      tags.planId = int.parse(_arguments!['plan_id']);
      tags.packageName = _arguments!['package_name'];
      tags.packageId = _arguments!['package_id'];
      tags.enrolledStatus = _arguments!['enrolled_status'];
    }

    return FutureBuilder<String?>(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot == null) {
            return AccountPage();
          } else {
            bankDetailBloc.initBloc();
            return mainView();
          }
        });

    //
    // var myWidget;
    // if ((Preference.getString(token) == null)) {
    //   myWidget = AccountPage();
    // } else {
    //   bankDetailBloc.initBloc();
    //   myWidget = mainView();
    // }
    // return myWidget;
  }

  DataListBean? _selectedValue;

  String? selectedDate = "";
  String selectedImagePath = "";
  String depositedName = "";
  String? contactNumber = "";
  String? bankBranchName = "";
  String? depositedAmount = "";

  Widget mainView() {
    bankDetailBloc.submitStream.listen((event) {
      print("EVENT!@#:" + event.status.toString());
      if (event.status == Status.LOADING) {
        _progressDialog.show();
      } else if (event.status == Status.COMPLETED) {
        _progressDialog.hide();
        showDialogFunction(context, event.data!.message);
      } else if (event.status == Status.ERROR) {
        _progressDialog.hide();
        appMessageDialog.show(
            event.data?.message ??
                "Your request has been submitted successfully. Our team will soon verify your payment and enroll you on your requested course/plan. Please check the status of your payment in Account ",
            "",
            "Okay");
      }
      //  else {
      //   _progressDialog.hide();
      //   Fluttertoast.showToast(msg: msg);
      // }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bank Deposit",
          style: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Response<BankDetailResponse>>(
              stream: bankDetailBloc.dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return Loading(
                        loadingMessage: snapshot.data!.message,
                      );

                    case Status.COMPLETED:
                      if (snapshot.data != null &&
                          snapshot.data!.data != null &&
                          snapshot.data!.data!.data != null) {
                        if (snapshot.data!.data!.data!.length > 0) {
                          _selectedValue = snapshot.data!.data!.data![0];
                        }
                      }

                      return Form(
                        key: _form,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //title
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  "${snapshot.data!.data!.msg1}",
                                  style: TextStyle(
                                      color: HexColor.fromHex(
                                          bottomNavigationEnabledState)),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0.0),
                                  child: HtmlWidget(
                                      "${snapshot.data?.data?.msg2.toString()}")),

                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  "${snapshot.data!.data!.msg3}",
                                  style: TextStyle(
                                      color: HexColor.fromHex(
                                          bottomNavigationEnabledState)),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(
                                height: 32.0,
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Depositor Name",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return ("This field can't be empty");
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    depositedName = value!.trim(); //trim here
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person_outline_rounded,
                                      color: HexColor.fromHex(
                                          bottomNavigationIdealState),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor.fromHex(inActive)),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 16.0,
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Contact Number",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),

                              //form

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("This field can't be empty");
                                    } else if (value.length != 10) {
                                      return ("Mobile Number must be of 10 digit");
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    contactNumber = value!;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: HexColor.fromHex(
                                          bottomNavigationIdealState),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor.fromHex(inActive)),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 16.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Deposited Account",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),

                              SizedBox(
                                height: 8.0,
                              ),

                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    // color: Colors.white,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: StreamBuilder<
                                              Response<DataListBean>>(
                                            stream:
                                                bankDetailBloc.dropDownStream,
                                            builder: (context, snapshots) {
                                              if (snapshots.hasData) {
                                                _selectedValue =
                                                    snapshots.data!.data;
                                                return dropDownWithValue(
                                                    snapshots.data!.data,
                                                    snapshot.data!.data!);
                                              } else {
                                                return dropDownWithValue(
                                                    _selectedValue,
                                                    snapshot.data!.data!);
                                              }
                                            },
                                          ),
                                          // child: dropDownWithValue(_selectedValue, snapshot.data.data),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 16.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Bank Branch Name",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("This field can't be empty");
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    bankBranchName = value!;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.house_sharp,
                                      color: HexColor.fromHex(
                                          bottomNavigationIdealState),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor.fromHex(inActive)),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 16.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Deposited Amount",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("This field can't be empty");
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    depositedAmount = value!;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.wysiwyg_outlined,
                                      color: HexColor.fromHex(
                                          bottomNavigationIdealState),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor.fromHex(inActive)),
                                    ),
                                  ),
                                ),
                              ),

                              //date picker
                              SizedBox(
                                height: 16.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Deposited Date",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),

                              StreamBuilder<Response<String>>(
                                  stream: bankDetailBloc.dateStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      selectedDate = snapshot.data!.data;

                                      return InkWell(
                                        onTap: () {
                                          print("--tap");

                                          bankDetailBloc.fetchDate(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8.0,
                                                    bottom: 4.0),
                                                child: Icon(
                                                  Icons.calendar_today,
                                                  color: HexColor.fromHex(
                                                      bottomNavigationIdealState),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    "${snapshot.data!.data}"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return InkWell(
                                      onTap: () {
                                        print("--tap");
                                        bankDetailBloc.fetchDate(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 8.0,
                                                  bottom: 4.0),
                                              child: Icon(
                                                Icons.calendar_today,
                                                color: HexColor.fromHex(
                                                    bottomNavigationIdealState),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Select a date"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),

                              //  StreamBuilder<Response<PickedFile>>(
                              //                                 stream: bankDetailBloc.fileStream,
                              //                                 builder: (context, snapshot){
                              //                                   if(snapshot.hasData){

                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0),
                                child: Divider(
                                  color: HexColor.fromHex(active),
                                  thickness: 0.3,
                                ),
                              ),

                              //attachment file

                              SizedBox(
                                height: 16.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Attach Voucher Image",
                                  style: TextStyle(
                                      color: HexColor.fromHex(colorBlue)),
                                ),
                              ),

                              StreamBuilder<Response<PickedFile>>(
                                stream: bankDetailBloc.fileStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.data != null) {
                                    selectedImagePath =
                                        snapshot.data!.data!.path;

                                    return InkWell(
                                      onTap: () {
                                        bankDetailBloc.fetchImage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 8.0,
                                                  bottom: 4.0),
                                              child: Icon(
                                                Icons.attachment,
                                                color: HexColor.fromHex(
                                                    bottomNavigationIdealState),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "..." +
                                                    snapshot.data!.data!.path
                                                        .substring(
                                                            snapshot
                                                                    .data!
                                                                    .data!
                                                                    .path
                                                                    .length -
                                                                20,
                                                            snapshot.data!.data!
                                                                .path.length),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                var dialog =
                                                    CustomImageDialogLocal(
                                                        snapshot
                                                            .data!.data!.path);

                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return dialog;
                                                  },
                                                );

                                                print("==preview: " +
                                                    snapshot.data!.data!.path);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8.0,
                                                    bottom: 4.0),
                                                child: Icon(
                                                  Icons.remove_red_eye,
                                                  color: HexColor.fromHex(
                                                      bottomNavigationIdealState),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      bankDetailBloc.fetchImage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 8.0,
                                                bottom: 4.0),
                                            child: Icon(
                                              Icons.attachment,
                                              color: HexColor.fromHex(
                                                  bottomNavigationIdealState),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Select image"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0),
                                child: Divider(
                                  color: HexColor.fromHex(active),
                                  thickness: 0.3,
                                ),
                              ),

                              SizedBox(
                                height: 16.0,
                              ),

                              // submitButtonDisplay(true)

                              StreamBuilder<Response<BankSubmitResponse>>(
                                  stream: bankDetailBloc.submitStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return submitButtonDisplay(
                                              false, "SUBMITTING...");
                                        case Status.COMPLETED:
                                          return submitButtonDisplay(
                                              false, "SUBMITTED");
                                        case Status.ERROR:
                                          return submitButtonDisplay(
                                              true, "SUBMIT");
                                        case Status.SUCCESS:
                                          return submitButtonDisplay(
                                              false, "SUBMITTED");
                                        case Status.LOGOUT:
                                          break;
                                      }

                                      return submitButtonDisplay(
                                          true, "SUBMIT");
                                    }

                                    return submitButtonDisplay(true, "SUBMIT");
                                  })
                            ],
                          ),
                        ),
                      );
                    case Status.ERROR:
                      return Error(
                        errorMessage: snapshot.data!.message,
                        onRetryPressed: () => bankDetailBloc.fetchData(),
                      );

                    default:
                      return Container();
                  }
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget dropDownWithValue(
      DataListBean? data, BankDetailResponse bankDetailResponse) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButton(
          value: _selectedValue,
          onChanged: (DataListBean? newValue) {
            bankDetailBloc.updateSelected(newValue);
            // _selectedValue = newValue;
          },
          items: bankDetailResponse.data!
              .map<DropdownMenuItem<DataListBean>>((DataListBean value) {
            return DropdownMenuItem<DataListBean>(
                value: value,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(value.accountName!),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            child: Text(
                              "${value.accountNumber}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: HexColor.fromHex(colorAccent)),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          Text("${value.bankName}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: HexColor.fromHex(colorBlue)))
                        ],
                      ),
                    ],
                  ),
                ));
          }).toList(),
        ),
      ),
    );
  }

  Widget submitButtonDisplay(bool isEnable, String title) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          child: Text(title),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  HexColor.fromHex(isEnable ? active : inActive))),
          onPressed: () {
            if (selectedDate!.isEmpty) {
              bankDetailBloc.fetchDate(context);
              return;
            } else if (selectedImagePath.isEmpty) {
              bankDetailBloc.fetchImage();
              return;
            }

            if (isEnable == true) {
              print("isValidate " + _form.currentState!.validate().toString());

              if (_form.currentState!.validate()) {
                _form.currentState!.save();

                // logData(_arguments['course_id']);

                List<MyCartModelData>? carts = [];
                // List<MyCartModelData>? carts = [_arguments!['carts']];

                bankDetailBloc.submitDeposited(
                    depositedName,
                    contactNumber!,
                    _selectedValue!.id!,
                    bankBranchName!,
                    depositedAmount!,
                    selectedDate!,
                    selectedImagePath,
                    _arguments?['course_id'],
                    _arguments!['course_amount'] ?? "",
                    _arguments!['subscription_id'],
                    carts ?? [],
                    tags);
              }
            }
          }),
    );
  }

  void logData(String courseId) async {
    var t = await Preference.getString(token);

    var myNetworkClient = MyNetworkClient();
    CourseDetailsByIdResponse response = await myNetworkClient
        .fetchCourseDetailsById(Common.checkNullOrNot(t), courseId);
    print(response.toString());
  }

  void deleteAllCartData() async {
    var db = AppDatabase.instance;
    db.delete(db.myCartModel).go();

    // await locator<AppDatabase>().deleteAllCartData();
  }

  showDialogFunction(BuildContext context, String? msg) {
    isSuccess = true;
    appMessageDialog.show(msg.toString(), "success", "Okay");
    deleteAllCartData();
  }
}
