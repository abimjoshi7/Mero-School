import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/my_cart_bloc.dart';
import 'package:mero_school/business_login/blocs/splash_bloc.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/api_end_point.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/carts_alert_dialog.dart';
import 'package:mero_school/presentation/widgets/coupen_alert_dialog.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/test/consumable_store.dart';
import 'package:mero_school/utils/app_progress_dialog.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/payment_button_sheet.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
//import for InAppPurchaseAndroidPlatformAddition
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//import for BillingResponse
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

class MyCartsPage extends StatefulWidget {
  @override
  _MyCartsPageState createState() => _MyCartsPageState();
}

class _MyCartsPageState extends State<MyCartsPage> {
  late MyCartBloc _myCartBloc;
  double myPrice = 0;
  final key = GlobalKey<AnimatedListState>();
  List<MyCartModelData>? myCartList;
  late AppProgressDialog _progressDialog;
  bool? _checkbox = false;
  String? _coupon_code = "";
  GlobalKey<FormState> _formKeyCode = GlobalKey<FormState>();
  late SplashBloc _splashBloc;
  late SharedPreferences _preferences;
  String? userToken;

  // * In app purchase
  // static const String _productID = "mero0003";
  String? _productID;
  late List<String> _kProductIds = <String>[_productID!];
  // static const List<String> _kProductIds = <String>[_productID];
  final InAppPurchase _iap = InAppPurchase.instance;
  final iapConnection = InAppPurchase.instance;
  // checks if the API is available on this device
  bool _isAvailable = false;
  //keeps a list of ids not found
  List<String> _notFoundIds = <String>[];
// keeps a list of products queried from Playstore or app store
  List<ProductDetails> _products = <ProductDetails>[];
// List of users past purchases
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
// subscription that listens to a stream of updates to purchase details
  late StreamSubscription<List<PurchaseDetails>> _subscription;
// used to represents consumable credits the user can buy
  int _credits = 0;
  List<String> _consumables = <String>[];
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _productID) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) async {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          children: [
            Text("ID: " + purchaseDetails.productID),
            Text("Status: " + purchaseDetails.status.toString()),
            Text("Error: " + purchaseDetails.error!.message),
            Text("Purchase Complete?: " +
                purchaseDetails.pendingCompletePurchase.toString()),
          ],
        ),
      ),
    );
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
        await showModalBottomSheet(
          context: context,
          builder: (_) => Center(
            child: Text("Purchase Pending"),
          ),
        );
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
          await showDialog(
            context: context,
            builder: (_) => Dialog(
              child: Text(purchaseDetails.error!.message),
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (purchaseDetails.productID == _productID) {
            final InAppPurchaseAndroidPlatformAddition androidAddition = _iap
                .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  // * Get users products
  Future<void> _getUserProducts() async {
    try {
      Set<String> ids = {_productID!};
      ProductDetailsResponse response = await _iap.queryProductDetails(ids);

      setState(() {
        _products = response.productDetails;
      });
      print("ID: " + _products.first.id);
      print("Title: " + _products.first.title);
      print("Price: " + _products.first.price);
    } catch (e) {
      print(e);
    }
  }

  // * Get past purchases
  Future<void> _getPastPurchases() async {
    await _iap.restorePurchases();
  }

  // * To purchase new product
  void _buyProduct(ProductDetails prod) {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
      _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
    } catch (e) {
      print(e);
    }
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((element) => element.productID == productID);
  }

  // * To verify purchases
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    purchaseDetails = _hasPurchased(_productID!);
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  // void _spendCredits(PurchaseDetails purchase) async {
  //   setState(() {
  //     _credits--;
  //   });
  //
  //   if (_credits == 0) {
  //     var res = await _iap.completePurchase(purchase);
  //   }
  // }

  Future<String> fecthGooglePrice(String courseID, String token) async {
    try {
      final res =
          await MyNetworkClient().getGooglePrice(int.parse(courseID), token);
      print("GOOGLE PRICE: " + res.toMap().toString());
      return res.data.googleProductId;
    } catch (e) {
      print(
        "GOOGLE PRICE FETCHING ERROR: " + e.toString(),
      );
      rethrow;
    }

    // setState(() {
    //   _productID = res.data.googleProductId;
    // });
  }

  Future initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    userToken = _preferences.getString(token);
    _productID = await fecthGooglePrice(myCartList!.first.cartId, userToken!);
    _kProductIds = <String>[_productID!];
    print("PRODUCTSSSSSSSSSSSSSSSSSSSS: " + _productID!);
    print("PRODUCTSSSSSSSSSSSSSSSSSSSS2: " + _kProductIds.toString());
    await _getUserProducts();
  }

  @override
  void initState() {
    initPreferences();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      for (PurchaseDetails s in purchaseDetailsList) {
        if (s.status == PurchaseStatus.purchased) {
          print(123);
          setState(() {
            _purchases.add(s);
          });
        } else {
          print(321);
        }
      }
      log(purchaseDetailsList.toString());
      log("initiating purchase");
      log(purchaseDetailsList.first.status.toString());
      log(purchaseDetailsList.first.purchaseID ?? "ASDF");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      print("Subscription Error: " + error.toString());
    });
    initStoreInfo();

    _myCartBloc = MyCartBloc();
    _myCartBloc.initBloc();

    _splashBloc = SplashBloc();
    _splashBloc.systemSettingsBloc();
    _splashBloc.fetchSystemSettings();

    _progressDialog = new AppProgressDialog(context);

    _checkbox = false;
    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_COURSE_DETAIL);
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
        await _iap.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();
    // setState(() {
    //   _isAvailable = isAvailable;
    //   _products = productDetailResponse.productDetails;
    //   _notFoundIds = productDetailResponse.notFoundIDs;
    //   _consumables = consumables;
    //   _purchasePending = false;
    //   _loading = false;
    // });
  }

  SystemSettingsResponse? systemSettingsResponse;

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: () async {
              for (PurchaseDetails s in _purchases) {
                print(s.status);
                print(s.purchaseID);
                print(s.error);
                print(s.pendingCompletePurchase);
                print(s.productID);
                print(s.transactionDate);
                print(s.verificationData.localVerificationData);
                print(s.verificationData.serverVerificationData);
                print(s.verificationData.source);
              }
              // _iap.restorePurchases(applicationUserName: _productID);
              // if (Platform.isAndroid) {
              //   final InAppPurchaseAndroidPlatformAddition androidAddition =
              //   _iap
              //       .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
              //   var priceChangeConfirmationResult =
              //   await androidAddition.launchPriceChangeConfirmationFlow(
              //     sku: _productID,
              //   );
              //   if (priceChangeConfirmationResult.responseCode == BillingResponse.ok){
              //     // TODO acknowledge price change
              //     print("Done");
              //   }else{
              //     print("Error occured");
              //     // TODO show error
              //   }
              // }

              // _getUserProducts();
            },
            icon: Icon(Icons.deblur),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Carts",
                      style: TextStyle(
                          color: HexColor.fromHex(colorAccent),
                          fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<String>(
                        stream: _myCartBloc.dataStreamPrice,
                        builder: (context, snapshot) {
                          return updatePriceWidget();
                        }),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder<Response<List<MyCartModelData>>>(
                    stream: _myCartBloc.dataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return Loading(
                                loadingMessage: snapshot.data!.message);
                          case Status.COMPLETED:
                            myCartList = snapshot.data!.data;

                            List<String?> title = [];
                            myPrice = 0;
                            myCartList!.forEach((model) {
                              title.add(model.title);

                              if (Common.isNumeric(model.price)) {
                                myPrice += double.parse(model.price);
                              }
                            });
                            _myCartBloc.updatePrice(myPrice);

                            if (myCartList!.length > 0) {
                              print("MYPRICE $myPrice");
                              WebEngagePlugin.trackEvent(TAG_CART_VIEWED, {
                                'No. Of Courses': myCartList!.length,
                                'Total Amount': myPrice,
                                'Course Details': title,
                              });
                            }

                            return AnimatedList(
                              key: key,
                              initialItemCount: myCartList!.length,
                              padding: EdgeInsets.only(bottom: 400),
                              itemBuilder: (context, index, animation) {
                                return loadSingleItemCard(
                                    myCartList![index], index, animation);
                              },
                            );

                          case Status.ERROR:
                            return Error(
                              errorMessage: snapshot.data!.message,
                              isDisplayButton: false,
                              onRetryPressed: () => _myCartBloc.getAllData(),
                            );
                        }
                      }
                      return Container();
                    }),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.white,
                child: StreamBuilder<Response<List<MyCartModelData>>>(
                    stream: _myCartBloc.dataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return _checkOutButton();
                          case Status.COMPLETED:
                            if (snapshot.data!.data!.isNotEmpty) {
                              return _checkOutButton(snapshot.data!.data);
                            } else {
                              return _checkOutButton();
                            }
                          case Status.ERROR:
                            return _checkOutButton();
                        }
                      }
                      return _checkOutButton();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void logREMOVE(MyCartModelData model) {
    var tagString = model.tagsmeta.toString();

    var priceToSend = 0.0;
    var discountPrice = 0.0;
    var courseCreatedBy = "";
    var data = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

    courseCreatedBy = data.instructorName ?? "";
    if (data.price == "Free" || data.price!.isEmpty) {
      priceToSend = 0.0;
    } else if (data.discountFlag!.trim() == "1") {
      priceToSend = double.parse(data.discountedPrice!);
      discountPrice =
          double.parse(data.price!) - double.parse(data.discountedPrice!);
    } else {
      priceToSend = double.parse(data.price!);
    }

    WebEngagePlugin.trackEvent(TAG_CART_REMOVED, {
      'Category Id': int.parse(data.categoryId!),
      'Category Name': "${data.categoryName}",
      'Course Time Duration': "${data.hoursLesson}",
      'Course Created By': data.instructorName,
      'Course Id': int.parse(data.id!),
      'Course Level': "${data.level}",
      'Language': data.language,
      'Price':
          priceToSend, //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
      'Discount':
          discountPrice, //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
      'Course Rating': data.rating,
      'Course Name': data.title,
      'Total Enrollments': data.totalEnrollment,
    });
  }

  Widget loadSingleItemCard(
      MyCartModelData model, int index, Animation<double> animation) {
    // print("===Tags Meta===");
    // print(model.tagsmeta);
    // print("===Tags Meta===");
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: GridTile(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                                color: HexColor.fromHex(
                                    bottomNavigationEnabledState),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            VoidCallback continueCallBack = () => {
                                  // WebEngagePlugin.trackEvent(TAG, {
                                  // 'Category Id':null,
                                  // 'Category Name': "",
                                  // 'Course Time Duration': "",
                                  // 'Course Created By': '',
                                  // 'Course Id': int.parse(data.id),
                                  // 'Course Level': "${data.level}",
                                  // 'Language':data.language,
                                  // 'Price': model.,
                                  // 'Course Ratings': data.rating,
                                  // 'Course Name': data.title,
                                  // 'Total Enrollments': data.totalEnrollment,
                                  // });

                                  // WebEngagePlugin.trackEvent(TAG_, {
                                  // 'Category Id':int.parse(data.categoryId),
                                  // 'Category Name': "${data.categoryName}",
                                  // 'Course Time Duration': "${data.hoursLesson}",
                                  // 'Course Created By': courseCreatedBy,
                                  // 'Course Id': int.parse(data.id),
                                  // 'Course Level': "${data.level}",
                                  // 'Language':data.language,
                                  // 'Price': priceToSend,//data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
                                  // 'Discount': discountPrice,//data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
                                  // 'Course Ratings': data.rating,
                                  // 'Course Name': data.title,
                                  // 'Total Enrollments': data.totalEnrollment,
                                  // });
                                  //

                                  // model.
                                  //

                                  logREMOVE(model),

                                  Navigator.of(context).pop(),
                                  deleteItem(model, index)
                                };
                            var dialog = CartsAlertDialog(
                                "Confirmation",
                                "Do you really want to remove this Course from your cart ?",
                                continueCallBack);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              },
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.black26,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      model.shortDescription.toString(),
                      style: TextStyle(
                          color: HexColor.fromHex(bottomNavigationIdealState)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    AntDesign.gift,
                                    size: 14,
                                    color: HexColor.fromHex(colorAccent),
                                  ),
                                ),
                                WidgetSpan(child: Text(" ")),
                                TextSpan(
                                    text:
                                        toBeginningOfSentenceCase(model.level),
                                    style: TextStyle(
                                        color: HexColor.fromHex(colorAccent))),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    SimpleLineIcons.tag,
                                    size: 14,
                                    color: HexColor.fromHex(colorBlue),
                                  ),
                                ),
                                WidgetSpan(child: Text(" ")),
                                TextSpan(
                                    text:
                                        "${Common.isNumeric(model.price) ? "Rs" : ""} ${model.price}",
                                    style: TextStyle(
                                        color: HexColor.fromHex(colorBlue))),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    FontAwesome.graduation_cap,
                                    size: 14,
                                    color: HexColor.fromHex(firstColor),
                                  ),
                                ),
                                WidgetSpan(child: Text(" ")),
                                TextSpan(
                                    text: "Course",
                                    style: TextStyle(
                                        color: HexColor.fromHex(firstColor))),
                              ],
                            ),
                          )
                        ])
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void removeItem(int index) {
    final item = myCartList!.removeAt(index);

    key.currentState!.removeItem(
      index,
      (context, animation) => loadSingleItemCard(item, index, animation),
    );
  }

  deleteItem(MyCartModelData model, int index) {
    _myCartBloc.deleteData(model).then((message) {
      if (Common.isNumeric(model.price)) {
        myPrice -= double.parse(model.price);
      }
      _myCartBloc.updatePrice(myPrice);
      removeItem(index);
      // ToastHelper.showShort(message);
    });
  }

  Widget _checkOutButton([List<MyCartModelData>? data]) {
    var course;
    var courseId;
    var courseAmount;
    if (data != null && data.isNotEmpty) {
      course = [for (var element in data) element.title].join(",");
      courseId = [for (var element in data) element.cartId].join(",");
      courseAmount = [
        for (var element in data) double.parse(element.price).round().toString()
      ].join(",");
    }
    return Visibility(
      visible: _preferences.getString(hidePayment) == "true" ? false : true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 8),
        child: SizedBox(
          child: Column(
            children: [
              StreamBuilder<Response<SystemSettingsResponse>>(
                  stream: _splashBloc.settingDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: Lottie.asset('assets/progress_two.json'),
                          );
                        case Status.COMPLETED:
                          _splashBloc
                              .saveData(snapshot.data!.data!)
                              .then((value) {});

                          systemSettingsResponse = snapshot.data!.data;

                          if (snapshot.data!.data!.data!.hideCoupon ==
                              "false") {
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                got_coupon_code,
                                style: TextStyle(
                                    color: HexColor.fromHex(colorAccent)),
                              ),
                              value: _checkbox,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checkbox = value;
                                });
                              },
                            );
                          } else {
                            return Container();
                          }
                        case Status.ERROR:
                          return Container();
                      }
                    }
                    return SizedBox();
                  }),
              Visibility(
                visible: _checkbox!,
                child: Form(
                  key: _formKeyCode,
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              "Coupon/Promo Code",
                              style:
                                  TextStyle(color: HexColor.fromHex(colorBlue)),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.card_giftcard_outlined,
                                color: HexColor.fromHex(
                                    bottomNavigationIdealState),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("This field can't be empty");
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              this._coupon_code = value;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0,
                                bottom: 16.0,
                                left: 32.0,
                                right: 32.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: '*Mero School\'s '),
                                  TextSpan(
                                      text: 'Terms and Conditions ',
                                      style: TextStyle(
                                          color: HexColor.fromHex(colorAccent)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print('Terms of Service"');

                                          Navigator.of(context).pushNamed(
                                              web_page,
                                              arguments: <String, String>{
                                                'paymentUrl':
                                                    'https://mero.school/terms_and_condition'
                                              });
                                        }),
                                  TextSpan(text: 'applies'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      print("MYCARTSCHECKOUTBTN");
                      Common.isUserLogin().then((value) {
                        print("LoginValue: $value");
                        if (value) {
                          if (_checkbox!) {
                            if (_formKeyCode.currentState!.validate()) {
                              _formKeyCode.currentState!.save();
                            } else {
                              return;
                            }
                          }

                          print("CouponCOde: $_coupon_code");

                          if (data != null && data.isNotEmpty) {
                            course = [for (var element in data) element.title]
                                .join(",");
                            courseId = [
                              for (var element in data) element.cartId
                            ].join(",");

                            print("totalPrice $myPrice courseId: $courseId");

                            if (Platform.isIOS) {
                              List<String?> appleId = [];

                              for (var element in data) {
                                print(
                                    "${element.appleProductId} ${element.title}");

                                appleId.add(element.appleProductId);
                              }

                              Navigator.pushReplacementNamed(
                                  context, in_app_product_list,
                                  arguments: <String, dynamic>{
                                    "productId": appleId
                                  });
                            } else {}

                            if (_checkbox! && _coupon_code!.startsWith("SMN")) {
                              _progressDialog.show();
                              _myCartBloc
                                  .smartCoursePayment(course, courseId,
                                      myPrice.toString(), "", "course",
                                      coupenCode:
                                          _coupon_code!.replaceAll(' ', ''))
                                  .then((
                                value1,
                              ) {
                                _progressDialog.hide();

                                if (_checkbox!) {
                                  CoupenAlertDialog alertDialog;
                                  if (value1.data!.amount == 0) {
                                    var valueResponseJson =
                                        value1.data!.courses["data"];

                                    try {
                                      DateTime parsedDate = DateTime.parse(
                                          "${valueResponseJson["plan_exp_date"]}T23:59:59.000Z");
                                      // final DateTime now = DateTime.now();
                                      final DateFormat formatter = DateFormat(
                                          "'~t'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                                      var formatted =
                                          formatter.format(parsedDate);

                                      WebEngagePlugin.trackEvent(
                                          TAG_ENROLL_COURSE, {
                                        'Category Id': int.parse(
                                            valueResponseJson["category_id"]),
                                        'Category Name':
                                            valueResponseJson["categoryName"],
                                        'Course Id':
                                            int.parse(valueResponseJson["id"]),
                                        'Course Level':
                                            valueResponseJson["level"],
                                        'Price':
                                            0.0, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
                                        'Discount':
                                            0.0, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
                                        'Course Language':
                                            valueResponseJson["language"],
                                        'Coupon Code': _coupon_code,
                                        'Course Time Duration':
                                            valueResponseJson["hours_lesson"],
                                        'Course Name':
                                            valueResponseJson["title"],
                                        'Course Created By':
                                            valueResponseJson["instructorName"],
                                        //'Order Id': txnId,
                                        'Payment Mode': "Free Coupon Used",
                                        'Total Enrollments': valueResponseJson[
                                            "totalEnrollments"],
                                        'Course Expiry Date':
                                            valueResponseJson["plan_exp_date"],
                                        'Course Expiry': formatted,
                                        'Free Enrollment': true,
                                        'Course Ratings': double.tryParse(
                                                valueResponseJson[
                                                    "average_rating"]) ??
                                            0.0
                                      });
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                    if (value1.data!.courses['status'] ==
                                        false) {
                                      alertDialog = CoupenAlertDialog(
                                          (null != value1.data!.couponMessage)
                                              ? value1.data!.couponMessage
                                              : "Invalid Coupon Code",
                                          false, () {
                                        //continuePurchase(value);
                                      });
                                    } else {
                                      alertDialog = CoupenAlertDialog(
                                          (null != value1.data!.couponMessage)
                                              ? value1.data!.couponMessage
                                                      .toString() +
                                                  " " +
                                                  valueResponseJson["title"]
                                                      .toString()
                                              : "Invalid Coupon Code",
                                          (null != value1.data!.isSuccess)
                                              ? value1.data!.isSuccess
                                              : false, () {
                                        deleteAllCartData();
                                        try {
                                          log("LOGGINGCOURSERESPONSE" +
                                              value1.data!.courses);
                                          // var courseDetails =
                                          //     CourseDetailsByIdResponse
                                          //         .fromJson();
                                          print("COURSEDETAILS===>>>");
                                        } catch (e) {
                                          log(e.toString());
                                        }

                                        Navigator.pushReplacementNamed(
                                            context, course_details,
                                            arguments: <String, String>{
                                              'course_id':
                                                  value1.data!.courses['id']
                                            });
                                        //continuePurchase(value);
                                      }, callBackOnCross: () {
                                        deleteAllCartData();
                                        Navigator.pushReplacementNamed(
                                            context, course_details,
                                            arguments: <String, String>{
                                              'course_id':
                                                  value1.data!.courses['id']
                                            });
                                      });
                                    }
                                    //Courses courses = Courses.fromJson(value.data!.courses);

                                    print(
                                        "SMARTGATEWAYPAY ${value1.data!.courses.toString()}");
                                  } else {
                                    alertDialog = CoupenAlertDialog(
                                        (null != value1.data!.couponMessage)
                                            ? value1.data!.couponMessage
                                            : "Invalid Coupon Code",
                                        (null != value1.data!.isSuccess)
                                            ? value1.data!.isSuccess
                                            : false, () {
                                      continuePurchase(value1);
                                    });
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alertDialog;
                                    },
                                  );
                                } else {
                                  continuePurchase(value1);
                                }
                              });
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (dialogContext) {
                                    return Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: PaymentMethod(
                                          systemSettingsResponse:
                                              systemSettingsResponse,
                                          callback: (String method) {
                                            print("selected:: " + method);

                                            Navigator.pop(dialogContext);

                                            switch (method) {
                                              case "google-pay":
                                                print(myPrice);
                                                print(courseAmount);
                                                print(courseId);
                                                print(course);
                                                print(_isAvailable);
                                                _buyProduct(
                                                  ProductDetails(
                                                      id: _productID!,
                                                      title: course,
                                                      description: description,
                                                      price: myPrice.toString(),
                                                      rawPrice: myPrice,
                                                      currencyCode: "USD"),
                                                );

                                                break;
                                              case "smart-gateway":
                                                {
                                                  _progressDialog.show();

                                                  _myCartBloc
                                                      .smartCoursePayment(
                                                          course,
                                                          courseId,
                                                          myPrice.toString(),
                                                          "",
                                                          "course",
                                                          coupenCode:
                                                              _coupon_code!
                                                                  .replaceAll(
                                                                      ' ', ''))
                                                      .then((
                                                    value1,
                                                  ) {
                                                    _progressDialog.hide();

                                                    if (_checkbox!) {
                                                      CoupenAlertDialog
                                                          alertDialog;
                                                      if (value1.data!.amount ==
                                                          0) {
                                                        if (value1.data!
                                                                    .courses[
                                                                'status'] ==
                                                            false) {
                                                          alertDialog = CoupenAlertDialog(
                                                              (null !=
                                                                      value1
                                                                          .data!
                                                                          .couponMessage)
                                                                  ? value1.data!
                                                                      .couponMessage
                                                                  : "Invalid Coupon Code",
                                                              false, () {
                                                            //continuePurchase(value);
                                                          });
                                                        } else {
                                                          alertDialog = CoupenAlertDialog(
                                                              (null !=
                                                                      value1
                                                                          .data!
                                                                          .couponMessage)
                                                                  ? value1.data!
                                                                          .couponMessage
                                                                          .toString() +
                                                                      " " +
                                                                      value1
                                                                          .data!
                                                                          .courses[
                                                                              'title']
                                                                          .toString()
                                                                  : "Invalid Coupon Code",
                                                              (null !=
                                                                      value1
                                                                          .data!
                                                                          .isSuccess)
                                                                  ? value1.data!
                                                                      .isSuccess
                                                                  : false, () {
                                                            deleteAllCartData();
                                                            Navigator.pushReplacementNamed(
                                                                context,
                                                                course_details,
                                                                arguments: <
                                                                    String,
                                                                    String>{
                                                                  'course_id':
                                                                      value1
                                                                          .data!
                                                                          .courses['id']
                                                                });
                                                            //continuePurchase(value);
                                                          }, callBackOnCross:
                                                                  () {
                                                            print(
                                                                'CALLBABCCALLED');
                                                            deleteAllCartData();
                                                            Navigator.pushReplacementNamed(
                                                                context,
                                                                course_details,
                                                                arguments: <
                                                                    String,
                                                                    String>{
                                                                  'course_id':
                                                                      value1
                                                                          .data!
                                                                          .courses['id']
                                                                });
                                                          });
                                                        }
                                                        //Courses courses = Courses.fromJson(value.data!.courses);

                                                        print(
                                                            "SMARTGATEWAYPAY ${value1.data!.courses.toString()}");
                                                      } else {
                                                        alertDialog = CoupenAlertDialog(
                                                            (null !=
                                                                    value1.data!
                                                                        .couponMessage)
                                                                ? value1.data!
                                                                    .couponMessage
                                                                : "Invalid Coupon Code",
                                                            (null !=
                                                                    value1.data!
                                                                        .isSuccess)
                                                                ? value1.data!
                                                                    .isSuccess
                                                                : false, () {
                                                          continuePurchase(
                                                              value1);
                                                        });
                                                      }
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return alertDialog;
                                                        },
                                                      );
                                                    } else {
                                                      continuePurchase(value1);
                                                    }
                                                  });
                                                }

                                                break;
                                              case "bank-payment":
                                                {
                                                  //TODO: Added by -Saugat

                                                  var sumTotal = 0.0;
                                                  myCartList!
                                                      .forEach((element) {
                                                    sumTotal = sumTotal +
                                                        double.parse(
                                                            element.price);
                                                  });

                                                  myCartList!
                                                      .forEach((element) {
                                                    var priceToSend = 0.0;
                                                    var discountPrice = 0.0;
                                                    var courseCreatedBy = "";

                                                    var tagString = element
                                                        .tagsmeta
                                                        .toString();
                                                    print(element.tagsmeta);
                                                    var course =
                                                        CourseDetailsByIdResponse
                                                            .fromJson(
                                                                json.decode(
                                                                    tagString));

                                                    courseCreatedBy =
                                                        course.instructorName ??
                                                            "";
                                                    if (course.price ==
                                                            "Free" ||
                                                        course.price!.isEmpty) {
                                                      priceToSend = 0.0;
                                                    } else if (course
                                                            .discountFlag!
                                                            .trim() ==
                                                        "1") {
                                                      priceToSend =
                                                          double.parse(course
                                                              .discountedPrice!);
                                                      discountPrice = double
                                                              .parse(course
                                                                  .price!) -
                                                          double.parse(course
                                                              .discountedPrice!);
                                                    } else {
                                                      priceToSend =
                                                          double.parse(
                                                              course.price!);
                                                    }
                                                    WebEngagePlugin.trackEvent(
                                                        TAG_BANK_DEPOSIT_FOR_COURSE,
                                                        {
                                                          'Category Id':
                                                              int.parse(course
                                                                  .categoryId!),
                                                          'Category Name':
                                                              "${course.categoryName}",
                                                          'Course Id':
                                                              int.parse(
                                                                  course.id!),
                                                          // 'Purchase Status': course.isPurchased,
                                                          'Course Level':
                                                              "${course.level}",
                                                          'Price':
                                                              priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
                                                          'Payment Mode':
                                                              'bank',
                                                          'Course Rating':
                                                              course.rating,
                                                          'Amount': sumTotal,
                                                          'Language':
                                                              course.language,
                                                          'Course Name':
                                                              course.title,
                                                          // 'Enrollment Status':course.isFreeUsed,
                                                          'No. Of Courses':
                                                              myCartList!
                                                                  .length,
                                                          'Course Created By':
                                                              course.instructorName ??
                                                                  "",
                                                        });
                                                  });
                                                  print("Reached here");
                                                  Navigator.pushNamed(context,
                                                      bank_transfer_page,
                                                      arguments: <String,
                                                          dynamic>{
                                                        'course_id':
                                                            '$courseId',
                                                        'course_amount':
                                                            '$courseAmount',
                                                        'subscription_id': '',
                                                        'carts': myCartList
                                                      }).then((value) {
                                                    print(
                                                        "ReturnedBack $value");
                                                  });
                                                }
                                                break;

                                              case "apple-pay":
                                                {
                                                  List<String?> appleId = [];

                                                  for (var element in data) {
                                                    print(
                                                        "${element.appleProductId} ${element.title}");

                                                    appleId.add(
                                                        element.appleProductId);
                                                  }

                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          in_app_product_list,
                                                          arguments: <String,
                                                              dynamic>{
                                                        "productId": appleId
                                                      });
                                                }

                                                break;
                                            }
                                          }),
                                    );
                                  });
                            }
                          }
                        } else {
                          //* Navigate to Login Page
                          Navigator.pushNamed(context, login_page,
                              arguments: <String, bool>{
                                'isPreviousPage': true
                              }).then((value) => print("lgoin"));
                        }
                      });
                    },
                    child: Text("CHECK OUT")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void continuePurchase(dynamic value) {
    var sumTotal = 0.0;
    myCartList!.forEach((element) {
      sumTotal = sumTotal + double.parse(element.price);
    });

    myCartList!.forEach((element) {
      var tagString = element.tagsmeta.toString();
      print(element.tagsmeta);
      var course = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

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
      WebEngagePlugin.trackEvent(TAG_CHECKOUT_STARTED, {
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
        'No. Of Courses': myCartList!.length,
        'Course Created By': course.instructorName ?? "",
        'Course Duration': int.parse(course.paidExpDays!),
        'Discount': discountPrice,
      });
    });

    ToastHelper.showShort(value.message ?? "");
    Navigator.of(context)
        .pushNamed(smart_payment_page, arguments: <String, dynamic>{
      'paymentUrl': value.data.paymentProceed,
      'carts': myCartList,
      'subscription_id': ''
    }).then((value) {
      Navigator.of(context).pop(value);

      print("fromSmartGateway: $value");
    });
  }

  @override
  void dispose() {
    _myCartBloc.dispose();
    _splashBloc.close();
    _subscription.cancel();

    super.dispose();
  }

  Widget updatePriceWidget() {
    return Text(
      (myPrice == null)
          ? ""
          : (myPrice == 0.0)
              ? ""
              : "Total: $myPrice",
      style: TextStyle(color: HexColor.fromHex(colorBlue)),
    );
  }

  void deleteAllCartData() async {
    var db = AppDatabase.instance;
    db.delete(db.myCartModel).go();
    // await locator<AppDatabase>().deleteAllCartData();
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
