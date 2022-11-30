import 'dart:async';

// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/services.dart';
import 'package:mero_school/data/models/request/in_app_receipt_validate_request.dart';
import 'package:mero_school/data/models/response/in_app_validate_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class InAppProductListBloc extends BaseBloc {
  initBloc() {
    _dataController = StreamController<Response<List<IAPItem>>>();
    _purchasedController = StreamController<Response<List<PurchasedItem>>>();

    _validateController = StreamController<Response<InAppValidateResponse>>();

    _availabilityController = StreamController<Response<bool>>();
    _popUpController = BehaviorSubject<Response<bool>>();

    _isStreaming = true;
    // fetchData();
    checkStore();

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
      validatePurchase(
          courseId, productItem!.transactionReceipt, productItem.transactionId);
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      popupSink.add(Response.error(purchaseError!.message));
    });
  }

  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;

  StreamController? _dataController;
  late StreamController _purchasedController;
  StreamController? _availabilityController;
  late StreamController _popUpController;
  late StreamController _validateController;

  late bool _isStreaming;

  StreamSink<Response<List<IAPItem>>> get dataSink =>
      _dataController!.sink as StreamSink<Response<List<IAPItem>>>;
  StreamSink<Response<List<PurchasedItem>>> get purchasedSink =>
      _purchasedController.sink as StreamSink<Response<List<PurchasedItem>>>;

  StreamSink<Response<bool>> get availableSink =>
      _availabilityController!.sink as StreamSink<Response<bool>>;
  StreamSink<Response<bool>> get popupSink =>
      _popUpController.sink as StreamSink<Response<bool>>;

  Stream<Response<List<IAPItem>>> get dataStream =>
      _dataController!.stream as Stream<Response<List<IAPItem>>>;
  Stream<Response<List<PurchasedItem>>> get purchasedStream =>
      _purchasedController.stream as Stream<Response<List<PurchasedItem>>>;
  Stream<Response<bool>> get availableStream =>
      _availabilityController!.stream as Stream<Response<bool>>;
  Stream<Response<bool>> get popupStream =>
      _popUpController.stream as Stream<Response<bool>>;

  late StreamSubscription<List<IAPItem>> _subscription;

  StreamSink<Response<InAppValidateResponse>> get validateSink =>
      _validateController.sink as StreamSink<Response<InAppValidateResponse>>;
  Stream<Response<InAppValidateResponse>> get validateStream =>
      _validateController.stream as Stream<Response<InAppValidateResponse>>;

  checkStore() async {
    availableSink.add(Response.loading('Getting a Data!'));

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.initialize();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');

    availableSink.add(Response.completed(true));
  }

  fetchData(String prodcutIds) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      List<IAPItem> products = [];

      List<String> pids = [];

      pids.add(prodcutIds);

      print("==ids: $pids");
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getProducts(pids);
      products.addAll(items);

      if (_isStreaming) dataSink.add(Response.completed(products));
    } catch (e) {
      print(e);

      if (_isStreaming) dataSink.add(Response.error("ERR: ${e.toString()}"));
    }
  }

  fetchPurchases() async {
    purchasedSink.add(Response.loading('Getting a Data!'));
    try {
      List<PurchasedItem>? items =
          await FlutterInappPurchase.instance.getAvailablePurchases();
      print("$items");
      if (_isStreaming) purchasedSink.add(Response.completed(items));
    } catch (e) {
      print(e);
      if (_isStreaming)
        purchasedSink.add(Response.error("ERR: ${e.toString()}"));
    }
  }

  void showPopup(String msg) {
    popupSink.add(Response.loading(msg));
  }

  dispose() {
    _subscription.cancel();
    _isStreaming = false;
    _dataController?.close();
    _availabilityController?.close();

    _purchaseUpdatedSubscription!.cancel();
    _purchaseUpdatedSubscription = null;
    _purchaseErrorSubscription!.cancel();
    _purchaseErrorSubscription = null;
  }

  String? courseId = "";

  void requestPurchase(IAPItem item, String? course) {
    courseId = course;
    showPopup("loading...");
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  MyNetworkClient _myNetworkClient = MyNetworkClient();

  Future<void> validatePurchase(
      String? courseid, String? receipt, String? transactionId) async {
    showPopup("validating...");

    var t = await Preference.getString(token);

    var authToken = Common.checkNullOrNot(t);

    var request = InAppReceiptValidateRequest(
        courseId: courseid, receiptData: receipt, authToken: authToken);
    try {
      InAppValidateResponse response =
          await _myNetworkClient.validateInApp(request);

      if (response.status == true) {
        FlutterInappPurchase.instance.finishTransactionIOS(transactionId!);
        popupSink.add(Response.completedDataMessage(
            true, "Successfully Enrolled to Course."));
      } else {
        popupSink.add(Response.completedDataMessage(
            false, "Receipt could not verified."));
      }
    } catch (e) {
      popupSink.add(Response.error(e.toString()));

      print(e);
    }
  }
}
