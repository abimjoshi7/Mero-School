import 'dart:async';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mero_school/data/models/request/search_plan_request.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class AllPlansBloc {
  late MyNetworkClient _myNetworkClient;
  bool _isLoading = true;

  //for all plans
  StreamController? _allPlansDataController;

  StreamSink<List<AppPlanData>> get allPlansDataSink =>
      _allPlansDataController!.sink as StreamSink<List<AppPlanData>>;

  Stream<List<AppPlanData>> get allPlansDataStream =>
      _allPlansDataController!.stream as Stream<List<AppPlanData>>;



  StreamController? _countController;

  StreamSink<String> get countDataSink => _countController!.sink as StreamSink<String>;
  Stream<String> get countDataStream => _countController!.stream as Stream<String>;




  AllPlansBloc(){
    initBloc();
  }

  int _offset = 0;

  final myData = <AppPlanData>[];

  initBloc() {
    _myNetworkClient = MyNetworkClient();
    //for all plans
    _allPlansDataController = BehaviorSubject<List<AppPlanData>>();
    _countController = BehaviorSubject<String>();
    // fetchAllPlans("0");
  }


  String  lastPlanId = "all", lastPackageId = "all";

  fetchAllPlansFilter({String? offset,String? planId, String? packageId}) async {
    //for all plans


    print("fetching api....$planId");


    if(planId != null){
      lastPlanId = planId;
    }

    if(packageId != null){
      lastPackageId = packageId;
    }


    try {
      if(offset == "0"){
        myData.clear();
        _offset = 0;
      }else{
        _offset = _offset.toInt();
      }


      var t = await Preference.getString(token);

      AllPlansResponse response = await _myNetworkClient.fetchAllPlansFilter(
          Common.checkNullOrNot(t), _offset.toString(), lastPlanId, lastPackageId);


      print("responseTotla: ${response.total}");

      countDataSink.add("${response.total}");

      myData.addAll(response.data!);

      _allPlansDataController?.add(myData);

      _offset  = myData.length;

    } catch (e) {
      _isLoading = false;
      _allPlansDataController?.add(myData);
      _offset  = myData.length;

    }
  }

  searchPlan(String query) async {
    // allPlansDataSink.add(Response.loading('Getting a Data!'));
    myData.clear();
    _offset = 0;


    try {
      var t = await Preference.getString(token);

      SearchPlanRequest request =
          SearchPlanRequest(authToken: Common.checkNullOrNot(t), query: query);

      WebEngagePlugin.trackEvent(
          TAG_PLAN_SEARCH, <String, String>{'Search Keyword': query});

      AllPlansResponse response = await _myNetworkClient.searchPlan(request);

      countDataSink.add("${response.total}");


      myData.addAll(response.data!);

      allPlansDataSink.add(myData);
      _offset  = myData.length;

    } catch (e) {
      allPlansDataSink.add(myData);
      _offset  = myData.length;

      //print("my error::$e");
    }
  }

  dispose() {
    _isLoading = false;
    myData.clear();
    _allPlansDataController?.close();
    _countController?.close();
  }
}
