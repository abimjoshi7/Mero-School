import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mero_school/business_login/blocs/plans_subscription_bloc.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/loading/mydivider.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/utils/payment_button_sheet.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class PlansSubscriptionPage extends StatefulWidget {
  @override
  _PlansSubscriptionPageState createState() => _PlansSubscriptionPageState();
}

class _PlansSubscriptionPageState extends State<PlansSubscriptionPage>
    with SingleTickerProviderStateMixin {
  late PlansSubscriptionBloc _plansSubscriptionBloc;
  Map? _arguments;
  late AppProgressDialog _progressDialog;
  TabController? _tabController;
  Subscription? _selectedValue;
  late SharedPreferences _preferences;

  int _count = 0;

  Future initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? courseID;

  @override
  void initState() {
    initPreferences();
    _tabController = new TabController(length: 2, vsync: this);

    _plansSubscriptionBloc = PlansSubscriptionBloc();
    _plansSubscriptionBloc.initBloc();
    _progressDialog = new AppProgressDialog(context);

    super.initState();
  }

  var isPlanDetailLog = false;

  void update() {}

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  String? plan_id;
  String? thumbnail;

  AppPlanData? appPlanData;

  Subscription? choosed;

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (_arguments != null && _arguments!.containsKey('model')) {
      appPlanData = _arguments!['model'];
      _plansSubscriptionBloc.updateDetails(appPlanData!.id);
    } else if (_arguments != null && _arguments!.containsKey("plan_id")) {
      plan_id = _arguments!["plan_id"];
      _plansSubscriptionBloc.updateDetails(plan_id);
    } else if (_arguments != null && _arguments!.containsKey("id")) {
      plan_id = _arguments!["id"];
      _plansSubscriptionBloc.updateDetails(plan_id);
    } else if (_arguments != null && _arguments!.containsKey("course_id")) {
      plan_id = _arguments!["course_id"];
      _plansSubscriptionBloc.updateDetails(plan_id);
    }

    return StreamBuilder<Response<AppPlanData>>(
      stream: _plansSubscriptionBloc.detailStream,
      initialData: (appPlanData != null)
          ? Response.completed(appPlanData)
          : Response.loading("Loading..."),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              AppBar appBar = AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: HexColor.fromHex(bottomNavigationEnabledState)),
                  onPressed: () {
                    goBackOrOpenHome();
                  },
                ),
                title: Text(
                  _arguments!['title'] != null
                      ? _arguments!['title']
                      : "Fetching details",
                  style: TextStyle(color: Colors.black87),
                ),
              );
              return Scaffold(
                appBar: appBar,
                body: Column(
                  children: [
                    Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                _arguments!.containsKey('thumbnail') == true
                                    ? _arguments!['thumbnail'] != null
                                        ? _arguments!['thumbnail']
                                        : "https://mero.school/themes/assets/images/hero-illustration.png"
                                    : "https://mero.school/themes/assets/images/hero-illustration.png",
                              ),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  HexColor.fromHex(colorBlue).withOpacity(0.5),
                                  BlendMode.srcOver)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // updateWidget(snapshot.data.data),
                            // tabTitle()
                          ],
                        )),
                    PlaceHolderLoadingVertical()
                  ],
                ),
              );

            case Status.COMPLETED:
              {
                AppPlanData data = snapshot.data!.data!;

                plan_id = data.id;

                List<String?> prices = [];
                List<String?> expiries = [];
                courseID = snapshot.data?.data?.coursePlan
                    ?.map((e) => e.id)
                    .toList()
                    .join(",");

                if (data.subscription!.length > 0) {
                  _selectedValue = data.subscription![0];
                  choosed = data.subscription![0];
                }

                data.subscription!.forEach((element) {
                  prices.add(element.price);
                  expiries.add(element.validity);

                  if (element.isPurchase!) {
                    _selectedValue = element;
                    choosed = element;
                  }
                });

                if (_selectedValue != null) {
                  _plansSubscriptionBloc.select(_selectedValue);
                }

                if (!isPlanDetailLog) {
                  isPlanDetailLog = true;

                  print("${data.toJson().toString()}");
                  WebEngagePlugin.trackEvent(TAG_PLAN_DETAIL, {
                    'Plan Id': int.parse(data.id!),
                    'Plan Name': data.plans,
                    'Number of Courses': data.coursePlan!.length,
                    'Plan Duration': data.courseDuration,
                    'Total Enrollments': 0,
                    'Enrollment Status': _selectedValue?.isPurchase ??
                        data.subscription?[0].isPurchase,
                    'Price': (null != prices) ? prices : "",
                    'Number of Subscriptions': data.subscription!.length,
                    'Plan Expiry Days': expiries,
                  });
                }

                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color:
                              HexColor.fromHex(bottomNavigationEnabledState)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      data.plans!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .apply(color: Colors.black87),
                    ),
                  ),
                  body: Column(
                    children: [
                      Stack(children: [
                        Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data.thumbnail ==
                                                null ||
                                            data.thumbnail == empty
                                        ? "https://mero.school/uploads/system/logo-dark.png"
                                        : data.thumbnail!),
                                    fit: BoxFit.fill,
                                    colorFilter: ColorFilter.mode(
                                        HexColor.fromHex(colorBlue)
                                            .withOpacity(0.5),
                                        BlendMode.srcOver))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [updateTopWidget(data), tabTitle()],
                            )),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 24,
                              height: 24,
                              child: InkWell(
                                child:
                                    Icon(Icons.fullscreen, color: Colors.white),
                                onTap: () {
                                  print(snapshot.data?.data?.coursePlan
                                      ?.map((e) => e.id)
                                      .toList()
                                      .join(","));
                                  // var dialog = CustomImageDialog(data
                                  //                 .thumbnail ==
                                  //             null ||
                                  //         data.thumbnail == empty
                                  //     ? "https://mero.school/uploads/system/logo-dark.png"
                                  //     : data.thumbnail);
                                  //
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) {
                                  //     return dialog;
                                  //   },
                                  // );
                                },
                              ),
                            ),
                          ),
                        ),
                      ]),
                      viewPagerApi(data),
                    ],
                  ),
                );
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
              title: Text(
                "Error Loading",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .apply(color: Colors.black87),
              ),
            ),
            body: Column());
      },
    );
  }

  Widget tabTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: HexColor.fromHex("#EEEEEE"),
      child: TabBar(
        unselectedLabelColor: HexColor.fromHex(colorBlue),
        isScrollable: true,
        indicator: BoxDecoration(
            color: HexColor.fromHex(colorBlue), shape: BoxShape.rectangle),
        tabs: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Courses",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Details", style: TextStyle(fontSize: 18)),
          )
        ],
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  Widget viewPagerApi(AppPlanData data) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [updateCourseWidget(data), updateCourseDetailsWidget(data)],
      ),
    );
  }

  Widget updateTopWidget(AppPlanData model) {
    if (model.subscription!.isNotEmpty) {
      // if (_selectedValue == null) {
      //   _selectedValue = model.subscription[0];
      //   _plansSubscriptionBloc.select(_selectedValue);
      // }

      var course;
      var courseId;

      var subscriptionId = _selectedValue!.subId;
      var subscriptionPlan = _selectedValue!.package;

      double price = 0.0;
      if (model.coursePlan!.isNotEmpty) {
        course =
            [for (var element in model.coursePlan!) element.title].join(",");
        courseId =
            [for (var element in model.coursePlan!) element.id].join(",");
        model.coursePlan!.forEach((element) {
          if (element.price != null && element.price!.isNotEmpty == true) {
            price = price + double.parse(element.price.toString());
          }
        });
      }

      // print("selected: ${_selectedValue.price}");

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.courseDuration!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .apply(color: Colors.white),
            ),
            SizedBox(
              height: 8,
            ),
            Visibility(
              visible:
                  _preferences.getString(hidePayment) == "true" ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      color: Colors.white,
                      child: StreamBuilder<Subscription>(
                          stream: _plansSubscriptionBloc.selectStream,
                          builder: (context, snapshot) {
                            // if (snapshot.hasData) {
                            //   return Container(
                            //     height: 100,
                            //     width: 270,
                            //     child: ListView.builder(
                            //       itemCount: model.subscription!.length,
                            //       itemBuilder: (_, int count) => ListTile(
                            //         onTap: () async {
                            //           print(
                            //               model.subscription![count].toString());
                            //           print(model.subscription!.first);
                            //         },
                            //         // leading: Padding(
                            //         //   padding: const EdgeInsets.all(1.0),
                            //         //   child: Radio<Subscription>(
                            //         //       splashRadius: 2,
                            //         //       activeColor:
                            //         //           HexColor.fromHex(colorPrimary),
                            //         //       value: _selectedValue!,
                            //         //       // value: model.subscription![0],
                            //         //       groupValue: choosed!,
                            //         //       // groupValue: model.subscription![0],
                            //         //       onChanged: (Subscription? newValue) {
                            //         //         choosed = newValue;
                            //         //         _selectedValue = newValue;
                            //         //         _plansSubscriptionBloc
                            //         //             .select(newValue);
                            //         //       }),
                            //         // ),
                            //         title: Container(
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             // direction: Axis.horizontal,
                            //             children: [
                            //               Radio<Subscription>(
                            //                   splashRadius: 2,
                            //                   activeColor:
                            //                       HexColor.fromHex(colorPrimary),
                            //                   value: _selectedValue!,
                            //                   // value: model.subscription![0],
                            //                   groupValue: choosed!,
                            //                   // groupValue: model.subscription![0],
                            //                   onChanged:
                            //                       (Subscription? newValue) {
                            //                     choosed = newValue;
                            //                     _selectedValue = newValue;
                            //                     _plansSubscriptionBloc
                            //                         .select(newValue);
                            //                   }),

                            //               Text(snapshot.data!.package!),
                            //               // Text(

                            //               // model
                            //               //     .subscription![count].package!),
                            //               Text(
                            //                 "${snapshot.data!.currency} ${snapshot.data!.price}",
                            //                 // "${model.subscription![count].currency} ${model.subscription![count].price}",
                            //                 style: TextStyle(
                            //                     fontSize: 13,
                            //                     color: HexColor.fromHex(
                            //                         colorAccent)),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         trailing: Text(
                            //             // "${model.subscription![count].validity} Days",
                            //             "${snapshot.data!.validity} Days",
                            //             style: TextStyle(
                            //                 fontSize: 13,
                            //                 color: HexColor.fromHex(colorBlue))),
                            //       ),
                            //     ),
                            //   );
                            // } else {
                            //   return CircularProgressIndicator();
                            // }

                            if (snapshot.hasData) {
                              print(
                                  "______ ${snapshot.data!.package!.length} selected");

                              subscriptionId = snapshot.data!.subId;
                              subscriptionPlan = snapshot.data!.package;

                              // print("${snapshot.data.toJson()}");
                              // var ran = Random();
                              //
                              Subscription sub = snapshot.data!;
                              print(sub);

                              var list = model.subscription!
                                  .map<DropdownMenuItem<Subscription>>(
                                      (Subscription value) {
                                print("value: ${value.isPurchase}");
                                print("value69: ${value.package}");

                                return DropdownMenuItem<Subscription>(
                                  value: value,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Text(value.package!),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${value.currency} ${value.price}",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: HexColor.fromHex(
                                                        colorAccent)),
                                              ),
                                              SizedBox(
                                                width: 24,
                                              ),
                                              Text("${value.validity} Days",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: HexColor.fromHex(
                                                          colorBlue)))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList();

                              return DropdownButton(
                                isExpanded: true,
                                value:
                                    (choosed != null) ? choosed : list[0].value,
                                onChanged: (Subscription? newValue) {
                                  choosed = newValue;
                                  _selectedValue = newValue;
                                  _plansSubscriptionBloc.select(newValue);
                                },
                                items: list,
                              );
                            }

                            return Container();
                          }),
                    ),
                  ),
                  StreamBuilder<Subscription>(
                      initialData: _selectedValue,
                      stream: _plansSubscriptionBloc.selectStream,
                      builder: (context, snapshot) {
                        String text = 'Buy';

                        if (snapshot.hasData) {
                          print('title: ${snapshot.data!.isPurchase}');

                          if (snapshot.data!.isPurchase == true) {
                            text = 'Renew';
                          }
                        }

                        return Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: ElevatedButton(
                            child: Text(text),
                            onPressed: () {
                              Common.isUserLogin().then((value) {
                                if (value) {
                                  if (Platform.isIOS) {
                                    _naviagetToInAppPay(
                                        model.id,
                                        _selectedValue!.subId,
                                        _selectedValue!.appleProductId);
                                  } else {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (dialogContext) {
                                          WebEngagePlugin.trackEvent(
                                              TAG_BUY_RENEW_CLICKED, {
                                            'Buy or Renew':
                                                _selectedValue!.isPurchase!
                                                    ? 'Renew'
                                                    : 'Buy',

                                            //TODO: I'm not sure if no. of courses is this -Saugat.
                                            'No. Of Courses':
                                                model.subscription!.length,

                                            'Plan Id': int.parse(
                                                _selectedValue!.packageId!),
                                            'Plan Name': model.plans,
                                            'Package Name':
                                                _selectedValue!.package,
                                            'Package Id':
                                                _selectedValue!.packageId,
                                            'Enrolled Status':
                                                _selectedValue!.isPurchase,
                                            'Price': _selectedValue!.price
                                          });
                                          return PaymentMethod(
                                              callback: (String method) {
                                            print("sleected:: " + method);

                                            Navigator.pop(dialogContext);

                                            switch (method) {
                                              case "smart-gateway":
                                                {
                                                  _progressDialog.show();

                                                  _plansSubscriptionBloc
                                                      .smartCoursePayment(
                                                    "${model.plans} ($subscriptionPlan)",
                                                    _selectedValue!.subId,
                                                    price.toString(),
                                                    _selectedValue!.validity,
                                                    "plan",
                                                  )
                                                      .then((value) {
                                                    _progressDialog.hide();

                                                    WebEngagePlugin.trackEvent(
                                                        TAG_SG_PLAN_CHECKOUT_STARTED,
                                                        {
                                                          'Plan Id': int.parse(
                                                              model.id!),
                                                          'Plan Name':
                                                              model.plans,
                                                          'Package Name':
                                                              _selectedValue!
                                                                  .package,
                                                          'Package Id': int.parse(
                                                              _selectedValue!
                                                                  .packageId!),
                                                          'Validity': int.parse(
                                                              _selectedValue!
                                                                  .validity!),
                                                          'Price': int.parse(
                                                              _selectedValue!
                                                                  .price!),
                                                          'Enrolled Status':
                                                              _selectedValue!
                                                                  .isPurchase
                                                        });

                                                    ToastHelper.showShort(
                                                        value.message!);
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            smart_payment_page,
                                                            arguments: <String,
                                                                dynamic>{
                                                          'paymentUrl': value
                                                              .data!
                                                              .paymentProceed,
                                                          'subscription_id':
                                                              '${model.id}',
                                                          'plan_id': model.id,
                                                          'package_name':
                                                              _selectedValue!
                                                                  .package,
                                                          'plan_name':
                                                              model.plans,
                                                          'package_id': int.parse(
                                                              _selectedValue!
                                                                  .packageId!),
                                                          'enrolled_status':
                                                              _selectedValue!
                                                                  .isPurchase,
                                                          'price': int.parse(
                                                              _selectedValue!
                                                                  .price!),
                                                          'validity': int.parse(
                                                              _selectedValue!
                                                                  .validity!),
                                                          'no_of_course': model
                                                              .coursePlan!
                                                              .length
                                                        }).then((value) {
                                                      if (value
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "success") {
                                                        // _plansSubscriptionBloc.updateDetails(model.id);

                                                        // print("planId:: ${model.id} ${value.toString().toLowerCase() }");
                                                        // // Navigator.popAndPushNamed(context, '/screen4');
                                                        // Navigator.popAndPushNamed(
                                                        //     context, plans_details_page,
                                                        //     arguments: <String, String>{
                                                        //       'plan_id': model.id
                                                        //     });

                                                      }
                                                    });
                                                  });
                                                }

                                                break;

                                              case "bank-payment":
                                                {
                                                  //Plan Name
                                                  //
                                                  // Plan Id
                                                  // Package Id
                                                  // Package Name
                                                  // Payment Mode
                                                  // Enrolled Status

                                                  WebEngagePlugin.trackEvent(
                                                      TAG_BANK_PAYMENT_PLAN, {
                                                    'Plan Id':
                                                        int.parse(model.id!),
                                                    'Plan Name': model.plans,
                                                    'Package Name':
                                                        _selectedValue!.package,
                                                    'Package Id': int.parse(
                                                        _selectedValue!
                                                            .packageId!),
                                                    'Payment Mode': 'bank',
                                                    'Enrolled Status':
                                                        _selectedValue!
                                                            .isPurchase
                                                  });

                                                  Navigator.pushNamed(context,
                                                      bank_transfer_page,
                                                      arguments: <String,
                                                          dynamic>{
                                                        'course_id': courseID,
                                                        'subscription_id':
                                                            '${model.id}',
                                                        'plan_id': model.id,
                                                        'package_name':
                                                            _selectedValue!
                                                                .package,
                                                        'plan_name':
                                                            model.plans,
                                                        'package_id': int.parse(
                                                            _selectedValue!
                                                                .packageId!),
                                                        'enrolled_status':
                                                            _selectedValue!
                                                                .isPurchase
                                                      });
                                                }
                                                break;
                                            }
                                          });
                                        });
                                  }

                                  //show the bottom sheet here

                                  // _progressDialog.show();
                                  // _plansSubscriptionBloc
                                  //     .smartCoursePayment(
                                  //         course, courseId, price.toString())
                                  //     .then((value) {
                                  //   _progressDialog.hide();
                                  //   ToastHelper.showShort(value.message);
                                  //   Navigator.of(context).pushNamed(smart_payment_page,
                                  //       arguments: <String, String>{
                                  //         'paymentUrl': value.data.paymentProceed,
                                  //       });
                                  // });

                                } else {
                                  Navigator.pushNamed(context, login_page,
                                      arguments: <String, bool>{
                                        'isPreviousPage': true
                                      }).then((value) => print("pop and call"));
                                }
                              });
                            },
                            //secondColor
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return HexColor.fromHex(
                                        _selectedValue!.isPurchase!
                                            ? secondColor
                                            : colorAccent);
                                  return HexColor.fromHex(_selectedValue!
                                          .isPurchase!
                                      ? secondColor
                                      : colorAccent); // Use the component's default.
                                },
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
              // );
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget updateCourseWidget(AppPlanData data) {
    return ListView.builder(
        itemCount: data.coursePlan!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return loadSingleItemCard(data.coursePlan![index]);
        });
  }

  Widget loadSingleItemCard(Course_plan model) {
    return GestureDetector(
      onTap: () {
        // setState(() => ++_count);

        // Navigator.popAndPushNamed(context, plans_details_page, arguments: <String, String>{
        //   'plan_id': '4'
        //
        // });
        //

        Navigator.pushNamed(context, course_details,
            arguments: <String, String?>{
              'course_id': model.id,
              'title': model.title,
              'price': model.price,
              'thumbnail': model.thumbnail,
            });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                          return ImageError(
                            size: 100,
                          );
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
                        "${model.title.toString().toUpperCase()}",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                HexColor.fromHex(bottomNavigationEnabledState)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${model.duration}",
                        style: TextStyle(
                            color:
                                HexColor.fromHex(bottomNavigationIdealState)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: model.ratings.toDouble(),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (double value) {},
                          ),

                          // SizedBox(
                          //   width: 5,
                          // ),
                          // // Text("${model.instructorName}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "( ${model.numberOfRatings.toString()} )",
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState)),
                          ),
                        ],
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

  Widget updateCourseDetailsWidget(AppPlanData data) {
    return Wrap(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Description",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .apply(color: Colors.black87),
                    ),
                    Icon(
                      Icons.waves_sharp,
                      color: Colors.black87,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: HexColor.fromHex(bottomNavigationIdealState),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data.shortDescription == null
                      ? empty
                      : data.shortDescription!,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
                MyDivider(),
                Text(
                  data.planDescription == null ? empty : data.planDescription!,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _plansSubscriptionBloc.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  _naviagetToInAppPay(
      String? subscriptionId, String? planid, String? productId) async {
    final result = await Navigator.pushNamed(context, in_app_product_list,
        arguments: <String, dynamic>{
          "productId": productId,
          "subscription": subscriptionId
        });

    if (result == true) {
      _plansSubscriptionBloc.updateDetails(planid);
    }
  }
}
