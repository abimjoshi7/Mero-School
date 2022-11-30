import 'dart:async';

import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/data/models/response/smart_course_payment_response.dart';
import 'package:mero_school/data/models/response/subscription_type_response.dart';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mero_school/data/models/request/search_plan_request.dart';
import 'package:mero_school/data/models/request/smart_plan_payment.dart';

class PlansSubscriptionBloc extends BaseBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;

  StreamController? _planDetailController;

  StreamController? _selectedController;

  StreamSink<Subscription?> get selectSink =>
      _selectedController!.sink as StreamSink<Subscription?>;

  Stream<Subscription> get selectStream =>
      _selectedController!.stream as Stream<Subscription>;

  StreamSink<Response<AppPlanData>> get detailSink =>
      _planDetailController!.sink as StreamSink<Response<AppPlanData>>;

  Stream<Response<AppPlanData>> get detailStream =>
      _planDetailController!.stream as Stream<Response<AppPlanData>>;

  StreamSink<Response<SubscriptionTypeResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<SubscriptionTypeResponse>>;

  Stream<Response<SubscriptionTypeResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<SubscriptionTypeResponse>>;

  initBloc() {
    _myNetworkClient = MyNetworkClient();

    _dataController = BehaviorSubject<Response<SubscriptionTypeResponse>>();
    _planDetailController = BehaviorSubject<Response<AppPlanData>>();
    _selectedController = BehaviorSubject<Subscription>();
  }

  select(Subscription? planData) {
    selectSink.add(planData);
  }

  Future<AppPlanData?> updateDetailFuture(String planId) async {
    // if(data!=null){
    //   return Future<AppPlanData>.delayed(Duration(seconds: 2), ()=>data);
    // }
    var t = await Preference.getString(token);

    PlanDetailResponse response =
        await _myNetworkClient.getPlanDetail(Common.checkNullOrNot(t), planId);
    return response.data;
  }

  updateDetails(String? planId) async {
    detailSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);

      PlanDetailResponse response = await _myNetworkClient.getPlanDetail(
          Common.checkNullOrNot(t), planId);
      detailSink.add(Response.completed(response.data));
    } catch (e) {
      detailSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  subscriptionType(String planId) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);

      SubscriptionTypeResponse response = await _myNetworkClient
          .subscriptionType(planId, Common.checkNullOrNot(t));
      dataSink.add(Response.completed(response));
    } catch (e) {
      dataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  searchPlan(String query) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);

      SearchPlanRequest request =
          SearchPlanRequest(authToken: Common.checkNullOrNot(t), query: query);
      // SubscriptionTypeResponse response =
      //     await _myNetworkClient.searchPlan(request);

      // dataSink.add(Response.completed(response));
    } catch (e) {
      dataSink.add(Response.error(e.toString()));
      print("my error::$e");
    }
  }

  Future<SmartCoursePaymentResponse> smartPayment(String planVilid,
      String subscriptionId, String subscriptionPlan, String totalPrice) async {
    var t = await Preference.getString(token);

    SmartPlanPayment payment = SmartPlanPayment(
        authToken: Common.checkNullOrNot(t),
        endside: "app",
        planVilid: planVilid,
        subscriptionId: subscriptionId,
        subscriptionPlan: subscriptionPlan,
        totalPrice: totalPrice);

    SmartCoursePaymentResponse response =
        await _myNetworkClient.smartPaymentPlan(payment);

    return response;
  }

  dispose() {
    _dataController?.close();
    _selectedController?.close();
    _planDetailController?.close();
  }
}
