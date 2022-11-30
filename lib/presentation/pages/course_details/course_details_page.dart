import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/course_details_bloc.dart';
import 'package:mero_school/business_login/blocs/my_cart_bloc.dart';
import 'package:mero_school/business_login/blocs/reviews_bloc.dart';
import 'package:mero_school/data/models/request/in_app_payment_request.dart';
import 'package:mero_school/data/models/response/certificate_status_response.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/related_plan_response.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/pages/pdf_viewer_page.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/load_view_pager.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/presentation/widgets/loading/placeholder_loading_vertical.dart';
import 'package:mero_school/test/consumable_store.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/offers_button_sheet.dart';
import 'package:mero_school/utils/payment_button_sheet.dart';
import 'package:mero_school/utils/toast_helper.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
//import for InAppPurchaseAndroidPlatformAddition
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//import for BillingResponse
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

import '../../../utils/app_progress_dialog.dart';

class CourseDetails extends StatelessWidget {
  Map? _arguments;

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    return Scaffold(
      body: CourseDetailsPage(_arguments),
    );
  }
}

class CourseDetailsPage extends StatefulWidget {
  Map? _arguments;

  CourseDetailsPage(this._arguments);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState(_arguments);
}

class _CourseDetailsPageState extends State<CourseDetailsPage>
    with SingleTickerProviderStateMixin {
  Map? _arguments;

  _CourseDetailsPageState(this._arguments);

  TabController? _tabController;
  late MyCartBloc _myCartBloc;
  late CourseDetailsBloc _courseDetailsBloc;
  late ReviewsBloc _reviewBloc;
  MyCartModelData? _myCartModel;
  bool? isWishlisted;
  String text = "Enroll";
  bool isEnroll = false;
  Lessons? enrollLessons;
  String? courseId;
  late SharedPreferences _preferences;
  late SystemSettingsResponse _systemSettingsResponse;
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
      if (mounted)
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

  Future initPreferences() async {
    _systemSettingsResponse = await MyNetworkClient().fetchSystemSettings();
    _preferences = await SharedPreferences.getInstance();
    userToken = _preferences.getString(token);
    _productID = await fecthGooglePrice(_arguments!["course_id"], userToken!);
    _kProductIds = <String>[_productID!];
    print("PRODUCTSSSSSSSSSSSSSSSSSSSS: " + _productID!);
    print("PRODUCTSSSSSSSSSSSSSSSSSSSS2: " + _kProductIds.toString());
    await _getUserProducts();
    // _productID = await fecthGooglePrice(_arguments!["course_id"], userToken!);
    // setState(() {
    //   _kProductIds = [_productID];
    // });
    // await fecthGooglePrice(_arguments!["course_id"], userToken!);
    // log(
    //   _arguments!["course_id"].toString(),
    // );
    // log(userToken!);
    // log(_productID);
  }

  //INFO: ADDED BY -Saugat
  var priceToSend = 0.0;
  var discountPrice = 0.0;
  var courseCreatedBy = "";

  //INFO OUT

  void gotoCartAndWait() {
    Navigator.pushNamed(context, my_carts).then((value) {
      // print("in course Detail Page: $value");
      // _courseDetailsBloc.fetchCourseDetailsById(courseId);
      _courseDetailsBloc.fetchCourseDetailsById(courseId);
      setState(() {});

      if (value.toString().toLowerCase() == "success") {
        _courseDetailsBloc.fetchCourseDetailsById(courseId);
      }
    });
  }

  bool fromVideo = false;

  @override
  void initState() {
    initPreferences();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
        (List<PurchaseDetails> purchaseDetailsList) async {
      // log("PRODUCT ID: " + _productID);
      // log("User Token: " + userToken!);
      for (PurchaseDetails s in purchaseDetailsList) {
        final Map<String, dynamic> json =
            jsonDecode(s.verificationData.localVerificationData);
        log("Purchase Token: " + json["purchaseToken"]);
        log(
          "JSON: " + json.toString(),
        );
        final res = await MyNetworkClient().getInAppResponse(
            InAppPaymentRequest(
                orderId: json["orderId"].toString(),
                packageName: json["packageName"].toString(),
                productId: json["productId"].toString(),
                purchaseTime: int.parse(json["purchaseTime"].toString()),
                purchaseState: int.parse(json["purchaseState"].toString()),
                purchaseToken: json["purchaseToken"].toString(),
                quantity: int.parse(json["quantity"].toString()),
                acknowledged: json["acknowledged"] as bool,
                authToken: userToken!));

        log("Response: " + res.toMap().toString());
        log("Transaction Data: " +
            s.verificationData.localVerificationData.toString());
        // await _verifyPurchase(s).then((value) async {
        //   if (value == true) {
        //     final Map<String, dynamic> json =
        //         jsonDecode(s.verificationData.localVerificationData);
        //     log("Purchase Token: " + json["purchaseToken"]);
        //     log("Purchase Token: " +
        //         json["purchaseToken"].runtimeType.toString());
        //     log(
        //       "JSON: " + json.toString(),
        //     );
        //     // print(json.toString());
        //     final res = await MyNetworkClient().getInAppResponse(
        //         InAppPaymentRequest(
        //             orderId: json["orderId"].toString(),
        //             packageName: json["packageName"].toString(),
        //             productId: json["productId"].toString(),
        //             purchaseTime: int.parse(json["purchaseTime"].toString()),
        //             purchaseState: int.parse(json["purchaseState"].toString()),
        //             purchaseToken: json["purchaseToken"].toString(),
        //             quantity: int.parse(json["quantity"].toString()),
        //             acknowledged: json["acknowledged"] as bool,
        //             authToken: userToken!));

        //     log("Response: " + res.toMap().toString());
        //     log("Transaction Data: " +
        //         s.verificationData.localVerificationData.toString());
        //     if (res.status == true && res.message == "Sucessfully enrolled") {
        //       await deliverProduct(s);
        //       print(s.status);
        //     }
        //   }
        // });

        if (s.status == PurchaseStatus.purchased) {
          print('Product Purchased.');
          if (mounted)
            setState(() {
              _purchases.add(s);
            });
        } else {
          print("Product not purchased.");
        }
      }
      log(purchaseDetailsList.first.purchaseID ?? "PurchaseDetailList Empty");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      print("Subscription Error: " + error.toString());
    });
    initStoreInfo();

    if (_arguments!.containsKey('fromVideo')) {
      fromVideo = true;
    }

    // _tabController!.animateTo(isDetail ? 4 : 0);
    _tabController = new TabController(
        initialIndex: fromVideo ? 6 : 0, length: 8, vsync: this);
    _courseDetailsBloc = CourseDetailsBloc();
    courseId = _arguments?['course_id'].toString();

    _myCartBloc = MyCartBloc();
    _myCartBloc.initBloc();

    _reviewBloc = ReviewsBloc();
    _reviewBloc.initBloc();

    // print("courseId: from argument: $courseId");
    _courseDetailsBloc.initBloc();

    if (courseId?.isNotEmpty == true) {
      _courseDetailsBloc.fetchCourseDetailsById(courseId);
      _courseDetailsBloc.checkCertificate(courseId);
      _reviewBloc.fetchRelatedPlan(courseId);
    }

    callDynamicLink();
    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_COURSE_DETAIL);
  }

  void goBackOrOpenHome() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
    }
  }

  void callBackFromOffer(String planId) {
    Navigator.pushNamed(context, plans_details_page,
        arguments: <String, String?>{'plan_id': planId});
  }

  void showPopupForOffers(RelatedPlanResponse? relatedPlanResponse) {
    isExtended.value = !isExtended.value;
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Container(
            height: 350,
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            child: OffersBottomSheets(
              courseId: "$courseId",
              callback: callBackFromOffer,
              systemSettingsResponse: relatedPlanResponse,
            ),
          );
        }).whenComplete(() {
      isExtended.value = !isExtended.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return mainView();
  }

  CourseDetailsByIdResponse? data;
  final ValueNotifier<bool> isExtended = ValueNotifier<bool>(false);
  Widget mainView() {
    // return Container(color: Colors.red,);
    return StreamBuilder<Response<CourseDetailsByIdResponse>>(
        stream: _courseDetailsBloc.dataStream,
        builder: (context, snapshot) {
          // print("snapshotHasdata: ${snapshot.hasData}");

          if (snapshot.hasData) {
            // print("Sanpshot: Status ${snapshot.data?.status}");
            switch (snapshot.data?.status) {
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
                    style: TextStyle(
                      color: Colors.black87,
                    ),
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
                                    HexColor.fromHex(colorBlue)
                                        .withOpacity(0.5),
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
                data = snapshot.data!.data;

                //INFO: ADDED BY SAUGAT

                _courseDetailsBloc.updateWish(data!.isWishlisted);

                // print("DISCOUNTFLAG"+data.discountFlag.toString());

                courseCreatedBy = snapshot.data!.data!.instructorName ?? "";
                if (snapshot.data!.data!.price == "Free" ||
                    snapshot.data!.data!.price!.isEmpty) {
                  priceToSend = 0.0;
                } else if (data!.discountFlag!.trim() == "1") {
                  priceToSend = double.parse(data!.discountedPrice!);
                  discountPrice = double.parse(data!.price!) -
                      double.parse(data!.discountedPrice!);
                } else {
                  priceToSend = double.parse(data!.price!);
                }

                // print("Price: $priceToSend :: Discount: $discountPrice");
                // print("RATING ${snapshot.data.data.rating}");
                //print("=<>="+double.parse(snapshot.data.data.price).runtimeType.toString());
                //INFO OUT
                WebEngagePlugin.trackEvent(TAG_PAGE_COURSE_DETAIL, {
                  'Category Id': int.parse(snapshot.data!.data!.categoryId!),
                  'Category Name': "${snapshot.data!.data!.categoryName}",
                  'Discount': discountPrice,
                  //snapshot.data.data.discountedPrice.isNotEmpty ? int.parse( snapshot.data.data.discountedPrice) :0,
                  'Course Id': int.parse(snapshot.data!.data!.id!),
                  'Purchase Status': snapshot.data!.data!.isPurchased,
                  'Level': "${snapshot.data!.data!.level}",
                  'Course Level': "${snapshot.data!.data!.level}",
                  'Price': priceToSend,
                  //snapshot.data.data.price == "Free"? 0.0: snapshot.data.data.price.isEmpty? 0.0 : double.parse(snapshot.data.data.price),

                  'Rating': snapshot.data!.data!.rating ?? 0.0,
                  'Course Rating': snapshot.data!.data!.rating,
                  'Course Name': snapshot.data!.data!.title,
                  'Total Enrollments': snapshot.data!.data!.totalEnrollment,
                  'Enrollment Status':
                      (snapshot.data!.data!.action == "Enrolled" ||
                              snapshot.data!.data!.action == "Purchased")
                          ? true
                          : false,
                  'Course Time Duration': snapshot.data!.data!.hoursLesson,
                  'Course Duration':
                      int.parse(snapshot.data!.data!.paidExpDays!),
                  'Course Created By': snapshot.data!.data!.instructorName ?? ""
                });

                bool hasPreview = false;

                if (snapshot.data?.data?.is_preview_url?.isNotEmpty == true) {
                  hasPreview = true;
                }

                // _tabController.

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
                    snapshot.data!.data!.title!,
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
                                    snapshot.data!.data!.thumbnail!),
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                    HexColor.fromHex(colorBlue)
                                        .withOpacity(0.5),
                                    BlendMode.srcOver)),
                          ),
                          child: snapshot.hasData
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible:
                                          _preferences.getString(hidePayment) ==
                                                  "true"
                                              ? false
                                              : true,
                                      child: updateWidget(snapshot.data!.data),
                                    ),
                                    tabTitle(hasPreview)
                                  ],
                                )
                              : Column(
                                  children: [tabTitle(hasPreview)],
                                )),
                      viewPagerApi(hasPreview),
                    ],
                  ),

                  //related plans starts
                  floatingActionButton:
                      StreamBuilder<Response<RelatedPlanResponse>>(
                    stream: _reviewBloc.relatedPlanStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data?.status == Status.COMPLETED &&
                            snapshot.data!.data!.data!.length > 0) {
                          return Container(
                            height: 42,
                            child: FloatingActionButton.extended(
                              extendedPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              onPressed: () {
                                showPopupForOffers(snapshot.data?.data);
                              },
                              label: ValueListenableBuilder<bool>(
                                valueListenable: isExtended,
                                builder: (BuildContext context, bool value,
                                    Widget? child) {
                                  return AnimatedSwitcher(
                                    duration: Duration(milliseconds: 100),
                                    transitionBuilder: (Widget child,
                                            Animation<double> animation) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child: SizeTransition(
                                        child: child,
                                        sizeFactor: animation,
                                        axis: Axis.horizontal,
                                      ),
                                    ),
                                    child: value
                                        ? Icon(Icons.close, size: 12)
                                        : Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: Icon(
                                                  Icons.card_giftcard_outlined,
                                                  size: 12,
                                                ),
                                              ),
                                              Text(
                                                "Related Plans",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                        }
                      }
                      return SizedBox();
                    },
                  ),
                  // floatingActionButtonAnimator:
                  //     FloatingActionButtonAnimator.scaling,
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.endTop,
                );

              case Status.ERROR:
                // return Container(color: Colors.red,);

                return Error(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () =>
                        _courseDetailsBloc.fetchCourseDetailsById(courseId));
            }
          }

          return Container();
        });
  }

  Widget tabTitle(bool hasPreview) {
    return Container(
      color: Colors.white,
      child: TabBar(
        unselectedLabelColor: HexColor.fromHex(colorBlue),
        isScrollable: true,
        indicator: BoxDecoration(
            color: HexColor.fromHex(colorBlue), shape: BoxShape.rectangle),
        tabs: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text(
              "Curriculum",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Preview", style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Reviews", style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Includes", style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Outcomes", style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Requirements", style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Details", style: TextStyle(fontSize: 16)),
          ),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
          //   child: Text("Discussions", style: TextStyle(fontSize: 16)),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
            child: Text("Similar Courses", style: TextStyle(fontSize: 16)),
          )
        ],
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
    // if(hasPreview){
    //
    // }
    // else{
    //   return Container(
    //     color: Colors.white,
    //     child: TabBar(
    //       unselectedLabelColor: HexColor.fromHex(colorBlue),
    //       isScrollable: true,
    //       indicator: BoxDecoration(
    //           color: HexColor.fromHex(colorBlue), shape: BoxShape.rectangle),
    //       tabs: [
    //
    //
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    //         child: Text(
    //           "Curriculum",
    //           style: TextStyle(fontSize: 16),
    //         ),
    //       ),
    //
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    //         child: Text("Includes", style: TextStyle(fontSize: 16)),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    //         child: Text("Outcomes", style: TextStyle(fontSize: 16)),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    //         child: Text("Requirements", style: TextStyle(fontSize: 16)),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    //         child: Text("Details", style: TextStyle(fontSize: 16)),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    //         child: Text("Reviews", style: TextStyle(fontSize: 16)),
    //       )
    //       ],
    //       controller: _tabController,
    //       indicatorSize: TabBarIndicatorSize.tab,
    //     ),
    //   );
    // }
  }

  Widget viewPagerApi(bool hasPreview) {
    return StreamBuilder<Response<CourseDetailsByIdResponse>>(
        stream: _courseDetailsBloc.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data!.message);
              case Status.COMPLETED:
                CourseDetailsByIdResponse model = snapshot.data!.data!;

                var priceToSend = double.parse(model.price!);

                if (model.discountFlag!.trim() == "1") {
                  priceToSend = double.parse(model.discountedPrice!);
                  discountPrice = double.parse(model.price!) -
                      double.parse(model.discountedPrice!);
                }

                _myCartModel = MyCartModelData(
                    cartId: model.id.toString(),
                    title: model.title.toString(),
                    shortDescription: model.shortDescription.toString(),
                    level: model.level.toString(),
                    price: priceToSend.toString(),
                    appleProductId: "${model.appleProductId}",

                    // tried to change by -Saugat. Works.

                    tagsmeta: json.encode(model.toJson())
                    //tagsmeta: model.toJson().toString()
                    );

                if (isEnroll) {
                  isEnroll = false;
                  if (enrollLessons != null) {
                    late var myLesson;
                    String? sectionTitle = "";
                    model.sections!.forEach((section) {
                      section.lessons!.forEach((lesson) {
                        if (enrollLessons!.id == lesson.id) {
                          sectionTitle = section.title;
                          myLesson = lesson;
                        }
                      });
                    });
                    Common.isUserLogin().then((value) {
                      if (value) {
                        // //send tag:::
                        //     // Video Name
                        //     // Chapter Name
                        //     // Category Name
                        //     // Category Id
                        //     // Course Name
                        //     // Course Id
                        //     // Video Duration

                        var maps = <String, String?>{
                          'action': STR_ENROLLED,
                          'video_url': myLesson.videoUrl,
                          'encoded_token': model.encodedToken,
                          'lessons_title': myLesson.title,
                          'title': model.title,
                          'course_id': myLesson.courseId,
                          'price': model.price,
                          'shareableLink': model.shareableLink,
                          'thumbnail': model.thumbnail,
                          'enrollment': model.totalEnrollment.toString(),
                          'shortDescription': model.shortDescription,
                          'level': model.level,
                          'appleProductId': model.appleProductId,
                          'category_id': model.categoryId == null
                              ? 0 as String?
                              : model.categoryId,
                          'category_name': model.categoryName,
                          'video_duration': model.hoursLesson,
                          'section_title': sectionTitle,
                          'tags': json.encode(model.toJson())
                        };

                        // print('===arguments sendn: ${json.encode(model.toJson())}');

                        Navigator.of(context)
                            .pushNamed(video_player, arguments: maps)
                            .then((value) {
                          // print("retrunback: in course details $value");

                          if (value.toString().toLowerCase() == "success") {
                            _courseDetailsBloc.fetchCourseDetailsById(courseId);
                          }
                        });
                      } else {
                        Navigator.pushNamed(context, login_page,
                            arguments: <String, bool>{'isPreviousPage': true});
                      }
                    });
                  }
                }

                return LoadViewPager(
                  fromVideo,
                  courseId,
                  model,
                  _tabController,
                  callback: (value, lesson) {
                    switch (value) {
                      case STR_BUY_NOW:
                        {
                          // print("#1123 RATINGHERE ${data.rating}");

                          if (_myCartModel != null) {
                            if (Platform.isIOS) {
                              _naviagetToInAppPay(_myCartModel!.cartId,
                                  _myCartModel!.appleProductId);
                            } else {
                              Common.isUserLogin().then((value) {
                                if (value) {
                                  if (data != null) {
                                    print("RATINGDATA ${data!.rating}");
                                    WebEngagePlugin.trackEvent(TAG_CART_ADDED, {
                                      'Category Id':
                                          int.parse(data!.categoryId!),
                                      'Category Name': "${data!.categoryName}",
                                      'Course Time Duration':
                                          "${data!.hoursLesson}",
                                      'Course Duration':
                                          int.parse(data!.paidExpDays!),
                                      'Course Created By': courseCreatedBy,
                                      'Course Id': int.parse(data!.id!),
                                      'Course Level': "${data!.level}",
                                      'Language': data!.language,
                                      'Price': priceToSend,
                                      //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
                                      'Discount': discountPrice,
                                      //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
                                      'Course Rating': data!.rating,
                                      'Course Name': data!.title,
                                      'Total Enrollments':
                                          data!.totalEnrollment,
                                    });
                                  }

                                  _courseDetailsBloc
                                      .insertDataIntoDatabase(_myCartModel!);
                                  // Navigator.pushNamed(context, my_carts);
                                  gotoCartAndWait();
                                } else {
                                  // print("#1123 User not loggedin");
                                  // Navigator.pushNamed(context, login_page,
                                  //     arguments: <String, bool>{'isPreviousPage': true}).then((value) =>
                                  //
                                  //     Common.isUserLogin().then((lggedin){
                                  //
                                  //       print("1123 loggedin $lggedin");
                                  //       if(lggedin){
                                  //         _courseDetailsBloc
                                  //             .insertDataIntoDatabase(_myCartModel);
                                  //         // Navigator.pushNamed(context, my_carts);
                                  //         gotoCartAndWait();
                                  //
                                  //       }else{
                                  //         print("1123 couldnot login agina");
                                  //       }
                                  //
                                  //     })
                                  //
                                  // );

                                }
                              });
                            }
                          }
                          break;
                        }
                      case STR_ENROLL:
                        {
                          Common.isUserLogin().then((value) {
                            if (value) {
                              _courseDetailsBloc
                                  .enrolledToFreeCourse(courseId, data)
                                  .then((response) {
                                ToastHelper.showShort(response.message!);

                                if (response.data!.is_enrolled!) {
                                  setState(() {
                                    text = "Enrolled";
                                  });
                                  _courseDetailsBloc
                                      .fetchCourseDetailsById(courseId);
                                  isEnroll = true;
                                  enrollLessons = lesson;
                                }
                              });
                            } else {
                              // Navigator.pushNamed(context, login_page,
                              //     arguments: <String, bool>{'isPreviousPage': true});
                            }
                          });

                          break;
                        }
                    }
                  },
                );
                // return Container() ;
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () =>
                      _courseDetailsBloc.fetchCourseDetailsById(courseId),
                );
                break;
            }
          }
          return Container();
        });
  }

  @override
  void dispose() {
    _courseDetailsBloc.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Widget updateWidget(CourseDetailsByIdResponse? response) {
    if (response == null) {
      return SizedBox();
    }

    if (isWishlisted == null) {
      isWishlisted = response.isWishlisted;
    }
    late ElevatedButton button;
    Text? expiredText;
    late var courseFreeDays;

    switch (response.action!.toLowerCase()) {
      case STR_BUY_NOW:
        {
          courseFreeDays = false;
          button = ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor.fromHex(colorPrimary),
            ),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: PaymentMethod(
                    systemSettingsResponse: _systemSettingsResponse,
                    callback: (String method) async {
                      print(_productID);
                      // try {
                      //   _prawait fecthGooglePrice(courseId!, userToken!);
                      // } catch (e) {
                      //   print(e.toString());
                      // }
                      switch (method) {
                        case "google-pay":
                          // InAppPaymentRequest iapr = InAppPaymentRequest(
                          //     orderId: orderId,
                          //     packageName: packageName,
                          //     productId: productId,
                          //     purchaseTime: purchaseTime,
                          //     purchaseState: purchaseState,
                          //     purchaseToken: purchaseToken,
                          //     quantity: quantity,
                          //     acknowledged: acknowledged,
                          //     authToken: authToken);
                          // final res = await MyNetworkClient().getInAppResponse(iapr);

                          _buyProduct(
                            ProductDetails(
                                id: _productID!,
                                title: course,
                                description: description,
                                price: priceToSend.toString(),
                                rawPrice: priceToSend,
                                currencyCode: "USD"),
                          );

                          // InAppPaymentRequest inAppPaymentRequest =
                          //     inAppPaymentRequestFromMap(_purchases
                          //         .last.verificationData.localVerificationData);

                          // final x = await MyNetworkClient()
                          //     .getInAppResponse(inAppPaymentRequest);
                          // log(x.message);

                          break;
                        case "bank-payment":
                          Navigator.pushNamed(context, bank_transfer_page,
                              arguments: <String, dynamic>{
                                'course_id': '$courseId',
                                'course_amount': priceToSend.toString(),
                                'subscription_id': '',
                                'carts': '',
                              }).then((value) {
                            print("ReturnedBack $value");
                          });
                          break;
                        case "smart-gateway":
                          _myCartBloc
                              .smartCoursePayment(
                                  _arguments!["title"],
                                  courseId,
                                  priceToSend.toString(),
                                  validity,
                                  "course")
                              .then((value) {
                            continuePurchase(value);
                          });
                          Navigator.of(context).pushNamed(smart_payment_page,
                              arguments: <String, dynamic>{
                                'paymentUrl': "",
                                'carts': '',
                                'subscription_id': ''
                              }).then((value) {
                            Navigator.of(context).pop(value);

                            print("fromSmartGateway: $value");
                          });
                          print(4321);
                          _purchases.forEach((element) {
                            log(element.productID);
                          });
                          break;
                      }
                    },
                  ),
                ),
              );
            },
            child: Text("Buy Now"),
          );
          // button = ElevatedButton(
          //   onPressed: () {
          //     // print(_splashBloc.s);
          //     // print("BUYNOW ${data.rating.toString()}");

          //     Common.isUserLogin().then(
          //       (value) {
          //         if (value) {
          //           if (_myCartModel != null) {
          //             if (Platform.isIOS) {
          //               _naviagetToInAppPay(
          //                   _myCartModel!.cartId, _myCartModel!.appleProductId);
          //             } else {
          //               _courseDetailsBloc
          //                   .insertDataIntoDatabase(_myCartModel!);
          //               if (data != null) {
          //                 WebEngagePlugin.trackEvent(TAG_CART_ADDED, {
          //                   'Category Id': int.parse(data!.categoryId!),
          //                   'Category Name': "${data!.categoryName}",
          //                   'Course Time Duration': "${data!.hoursLesson}",
          //                   'Course Created By': courseCreatedBy,
          //                   'Course Id': int.parse(data!.id!),
          //                   'Course Level': "${data!.level}",
          //                   'Language': data!.language,
          //                   'Price': priceToSend,
          //                   //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
          //                   'Discount': discountPrice,
          //                   //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
          //                   //'Course Ratings': data.rating,
          //                   'Course Name': data!.title,
          //                   'Total Enrollments': data!.totalEnrollment,
          //                   'Course Rating': data!.rating,
          //                   'Course Duration': int.parse(data!.paidExpDays!),
          //                 });
          //               }
          //               // Navigator.pushNamed(context, my_carts);
          //               gotoCartAndWait();
          //             }
          //           }
          //         } else {
          //           // print("#1123 login redirect");
          //           Navigator.pushNamed(context, login_page,
          //               arguments: <String, bool>{'isPreviousPage': true});
          //         }
          //       },
          //     );
          //   },
          //   child: Text(
          //     "Buy Now",
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.resolveWith<Color>(
          //       (Set<MaterialState> states) {
          //         if (states.contains(MaterialState.pressed))
          //           return HexColor.fromHex(colorAccent);
          //         return HexColor.fromHex(
          //             colorAccent); // Use the component's default.
          //       },
          //     ),
          //   ),
          // );
          if (int.parse(response.paidExpDays!) > 0) {
            expiredText = Text(
              "Purchase for ${response.paidExpDays} days",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
            courseFreeDays = true;
          } else {
            courseFreeDays = false;
          }

          break;
        }
      case STR_ENROLL:
        {
          button = ElevatedButton(
            onPressed: () {
              Common.isUserLogin().then((value) {
                if (value) {
                  _courseDetailsBloc
                      .enrolledToFreeCourse(courseId, data)
                      .then((value) {
                    ToastHelper.showShort(value.message!);
                    setState(() {
                      text = "Enrolled";
                    });
                  });
                } else {
                  Navigator.pushNamed(context, login_page,
                      arguments: <String, bool>{'isPreviousPage': true});
                }
              });
            },
            child: Text(text, style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  var color;
                  if (text == "Enrolled") {
                    color = secondColor;
                  } else {
                    color = colorAccent;
                  }
                  if (states.contains(MaterialState.pressed))
                    return HexColor.fromHex(color);
                  return HexColor.fromHex(
                      color); // Use the component's default.
                },
              ),
            ),
          );
          if (int.parse(response.freeExpDays!) > 0) {
            expiredText = Text(
              "Enroll free for ${response.freeExpDays} days",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
            courseFreeDays = true;
          } else {
            courseFreeDays = false;
          }
          break;
        }
      case STR_PURCHASED:
        {
          button = ElevatedButton(
            onPressed: null,
            child: Text("Purchased", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return HexColor.fromHex(colorAccent);
                  return HexColor.fromHex(
                      colorAccent); // Use the component's default.
                },
              ),
            ),
          );

          courseFreeDays = true;
          expiredText = Text(
            response.expDate!,
            style: TextStyle(color: Colors.white),
          );
          break;
        }
      case STR_ENROLLED:
        {
          button = ElevatedButton(
            onPressed: null,
            child: Text("Enrolled", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return HexColor.fromHex(secondColor);
                  return HexColor.fromHex(
                      secondColor); // Use the component's default.
                },
              ),
            ),
          );
          courseFreeDays = true;

          expiredText = Text(
            response.expDate!,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          );
          break;
        }
      case STR_EXPIRED:
        {
          button = ElevatedButton(
            onPressed: null,
            child: Text("Expired", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return HexColor.fromHex(colorAccent);
                  return HexColor.fromHex(
                      colorAccent); // Use the component's default.
                },
              ),
            ),
          );
          courseFreeDays = false;
          break;
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<Object>(
            stream: _courseDetailsBloc.certStream,
            builder: (context, snapshot) {
              print("THIISSPARTA ${snapshot.data.runtimeType}");
              if (snapshot.hasData && snapshot.data is Response<dynamic>) {
                Response<dynamic> datafetched =
                    snapshot.data as Response<dynamic>;
                CertificateStatusResponse certificateStatusResponse;
                // try {
                //   certificateStatusResponse =
                //       datafetched.data as CertificateStatusResponse;
                //   log(certificateStatusResponse.certificateStatus.toString());
                // } catch (e) {
                //   throw e;
                // }
                return Visibility(
                  // visible: certificateStatusResponse.certificateStatus ?? false,
                  child: InkWell(
                    onTap: () {
                      AppProgressDialog _progressDialog =
                          new AppProgressDialog(context);
                      _progressDialog.show();
                      _courseDetailsBloc
                          .generateCertificate(courseId, context)
                          .then((value) {
                        _progressDialog.hide();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => PdfViewerPage(
                                      path: value,
                                      name: _arguments!['title'] ??
                                          "cert-$courseId",
                                      arguments: {
                                        'Category Id':
                                            int.parse(data!.categoryId!),
                                        'Category Name':
                                            "${data!.categoryName}",
                                        'Course Duration':
                                            "${data!.hoursLesson}",
                                        'Course Id': int.parse(data!.id!),
                                        'Course Level': "${data!.level}",
                                        'Language': data!.language,
                                        'Course Name': data!.title,
                                        'Rating': data!.rating,
                                        'Certificate Generated Date': "",
                                      },
                                    ))));
                        log("FILE RECEIVED" + value.toString());
                      });
                    },
                    child: Container(
                      // height: 40,
                      // width: 160,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      // child: Center(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Icon(FontAwesome5.file_pdf),
                      //       SizedBox(
                      //         width: 4,
                      //       ),
                      //       Text("View Certificate")
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    FontAwesome.graduation_cap,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(response.totalEnrollment.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Row(
                      children: [
                        // RatingBar.builder( itemSize: 20,
                        //   initialRating: response.rating.toDouble(),
                        //   itemBuilder: (context, _) => Icon(
                        //     Icons.star,
                        //     color: Colors.amber,
                        //   ),
                        //   ignoreGestures: true, onRatingUpdate: (double value) {
                        //
                        // },
                        //
                        // ),
                        // SmoothStarRating(
                        //     isReadOnly: true,
                        //     size: 20,
                        //     rating: response.rating.toDouble(),
                        //     color: HexColor.fromHex(colorGolden),
                        //     borderColor:
                        //         HexColor.fromHex(bottomNavigationIdealState)),
                        Text(" ( ${response.numberOfRatings} )",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ),
                  Text(
                    response.level!.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Visibility(
                        visible: (response.discountFlag == "1") ? true : false,
                        child: Text(
                          "${response.price}",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Visibility(
                          visible:
                              (response.discountFlag == "1") ? true : false,
                          child: SizedBox(
                            width: 6,
                          )),
                      Text(
                        (response.price == "Free")
                            ? "Free"
                            : (response.discountFlag == "1")
                                ? "${response.currency}. ${response.discountedPrice}"
                                : "${response.currency}. ${response.price}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Visibility(
                      visible: courseFreeDays,
                      child: (expiredText == null) ? Container() : expiredText)
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      createShareableLink(response.shareableLink!,
                          response.description, response.thumbnail!);

                      analytics.logEvent(
                          name: SHARE,
                          parameters: <String, String?>{
                            ITEM_ID: response.id,
                            CONTENT_TYPE: response.categoryId
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: InkWell(
                          onTap: () {
                            //call api
                            Common.isUserLogin().then((value) {
                              analytics.logEvent(
                                  name: ADD_TO_WISHLIST,
                                  parameters: <String, String?>{
                                    ITEM_ID: response.id,
                                    ITEM_NAME: response.title,
                                  });

                              if (value) {
                                _courseDetailsBloc
                                    .removeData(courseId)
                                    .then((value) {
                                  // setState(() {
                                  //
                                  // });

                                  if (isWishlisted!) {
                                    isWishlisted = false;
                                    //Category Name
                                    // Category Id
                                    // Course Name
                                    // Course Level
                                    // Course Time Duration
                                    // Price
                                    // Course Duration
                                    // Course Created By
                                    // Course Ratings
                                    // Total Enrollments
                                    // Language

                                    if (data != null) {
                                      WebEngagePlugin.trackEvent(
                                          TAG_WISHLIST_REMOVED, {
                                        'Category Id':
                                            int.parse(data!.categoryId!),
                                        'Category Name':
                                            "${data!.categoryName}",
                                        'Course Time Duration':
                                            "${data!.hoursLesson}",
                                        'Course Created By': courseCreatedBy,
                                        'Course Id': int.parse(data!.id!),
                                        'Course Level': "${data!.level}",
                                        'Language': data!.language,
                                        'Discount': discountPrice,
                                        'Course Duration':
                                            int.parse(data!.paidExpDays!),
                                        'Price': priceToSend,
                                        // data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
                                        'Course Ratings': data!.rating,
                                        'Course Name': data!.title,
                                        'Total Enrollments':
                                            data!.totalEnrollment,
                                      });
                                    }

                                    _courseDetailsBloc.updateWish(isWishlisted);
                                  } else {
                                    isWishlisted = true;
                                    if (data != null) {
                                      WebEngagePlugin.trackEvent(
                                          TAG_WISHLIST_ADDED, {
                                        'Category Id':
                                            int.parse(data!.categoryId!),
                                        'Category Name':
                                            "${data!.categoryName}",
                                        'Course Time Duration':
                                            "${data!.hoursLesson}",
                                        'Course Duration':
                                            int.parse(data!.paidExpDays!),
                                        'Course Created By': courseCreatedBy,
                                        'Course Id': int.parse(data!.id!),
                                        'Course Level': "${data!.level}",
                                        'Language': data!.language,
                                        'Price': priceToSend,
                                        //data.price == "Free"? 0: data.price.isEmpty? 0 : double.parse(data.price),
                                        'Course Ratings': data!.rating,
                                        'Discount': discountPrice,
                                        'Course Name': data!.title,
                                        'Total Enrollments':
                                            data!.totalEnrollment,
                                      });
                                    }

                                    _courseDetailsBloc.updateWish(isWishlisted);
                                  }

                                  ToastHelper.showShort(value.message!);
                                });
                              } else {
                                Navigator.pushNamed(context, login_page,
                                    arguments: <String, bool>{
                                      'isPreviousPage': true
                                    });
                              }
                            });
                          },
                          child: StreamBuilder<bool>(
                              stream: _courseDetailsBloc.wishStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Icon(
                                    snapshot.data!
                                        ? AntDesign.heart
                                        : AntDesign.hearto,
                                    color: isWishlisted!
                                        ? Colors.white
                                        : Colors.white,
                                  );
                                } else {
                                  return Container();
                                }
                              }))),
                  button

                  // color: HexColor.fromHex(colorAccent),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void callDynamicLink() async {
    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();

    FirebaseDynamicLinks.instance.onLink.listen((event) {
      _handleDynamicLink(event.link);
    });
  }

  _handleDynamicLink(Uri deepLink) async {
    // final Uri deepLink = data?.link;

    print("deeplink: $deepLink $courseId");
    if (deepLink == null) {
      _courseDetailsBloc.fetchCourseDetailsById(courseId);
      return;
    }

    // print("issue causing the dynamic link: ${deepLink.toString()}");

    if (deepLink.toString().contains("course")) {
      var parts = deepLink.toString().split("/");
      courseId = parts.last;
      _courseDetailsBloc.fetchCourseDetailsById(courseId);
    }
  }

  void createShareableLink(
      String shareableLink, String? description, String thumbnail) async {
    WebEngagePlugin.trackEvent(TAG_COURSE_LINK_SHARE, {
      'Course Id': int.parse(data!.id!),
      'Course Name': data!.title,
    });

    var converted = Common.parseHtmlString(description);

    // thumbnail = "https://picsum.photos/300/200";
    // print("#thumbnail: $thumbnail");
    // print("#shareAblelink: $shareableLink");

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://share.mero.school',
      link: Uri.parse(shareableLink),
      androidParameters: AndroidParameters(packageName: 'school.mero.lms'),
      iosParameters: IOSParameters(bundleId: 'school.mero.ios'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Check the latest course in Mero School',
          description: converted,
          imageUrl: Uri.parse(thumbnail)),
    );

    // final Uri dynamicUrl = await FirebaseDynamicLinks.instance.buildUrl(parameters);

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri shortUrl = shortDynamicLink.shortUrl;
    // print("shortLInk: $shortUrl");
    // print("longLInk: $dynamicUrl");
    await Share.share("Check the latest course " + shortUrl.toString());
  }

  void continuePurchase(dynamic value) {
    var sumTotal = 0.0;
    // myCartList!.forEach((element) {
    //   sumTotal = sumTotal + double.parse(element.price);
    // });

    // myCartList!.forEach((element) {
    //   var tagString = element.tagsmeta.toString();
    //   print(element.tagsmeta);
    //   var course = CourseDetailsByIdResponse.fromJson(json.decode(tagString));

    //   var priceToSend = 0.0;
    //   var discountPrice = 0.0;
    //   var courseCreatedBy = "";

    //   courseCreatedBy = course.instructorName ?? "";
    //   if (course.price == "Free" || course.price!.isEmpty) {
    //     priceToSend = 0.0;
    //   } else if (course.discountFlag!.trim() == "1") {
    //     priceToSend = double.parse(course.discountedPrice!);
    //     discountPrice =
    //         double.parse(course.price!) - double.parse(course.discountedPrice!);
    //   } else {
    //     priceToSend = double.parse(course.price!);
    //   }
    //   WebEngagePlugin.trackEvent(TAG_CHECKOUT_STARTED, {
    //     'Category Id': int.parse(course.categoryId!),
    //     'Category Name': "${course.categoryName}",
    //     'Course Id': int.parse(course.id!),
    //     // 'Purchase Status': course.isPurchased,
    //     'Course Level': "${course.level}",
    //     'Price':
    //         priceToSend, //course.price == "Free"? 0.0: course.price.isEmpty? 0.0 : double.parse(course.price),
    //     // 'Payment Mode':'bank',
    //     // 'Course Rating': course.rating,
    //     'Total Amount': sumTotal,
    //     'Language': course.language,
    //     'Course Name': course.title,
    //     'No. Of Courses': 1,
    //     'Course Created By': course.instructorName ?? "",
    //     'Course Duration': int.parse(course.paidExpDays!),
    //     'Discount': discountPrice,
    //   });
    // });

    ToastHelper.showShort(value.message ?? "");
    Navigator.of(context).pushNamed(smart_payment_page,
        arguments: <String, dynamic>{
          'paymentUrl': value.data.paymentProceed,
          'carts': "",
          'subscription_id': ''
        }).then((value) {
      Navigator.of(context).pop(value);

      print("fromSmartGateway: $value");
    });
  }

  _naviagetToInAppPay(String? courseId, String? productId) async {
    final result = await Navigator.pushNamed(context, in_app_product_list,
        arguments: <String, dynamic>{
          "productId": productId,
          "courseId": courseId
        });

    if (result == true) {
      _courseDetailsBloc.fetchCourseDetailsById(courseId);
    }
  }

  @override
  bool get wantKeepAlive => true;

// String expireDay(String expDate) {
//   if (expDate.isEmpty) {
//     return empty;
//   }
//   var parts = expDate.split("-");
//   final expireDate =
//   DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
//   final today = DateTime.now();
//   final difference = expireDate.difference(today).inDays;
//   if (difference > 0) {
//     return "$difference days Remaining";
//   } else {
//     return "Expired";
//   }
// }
}
