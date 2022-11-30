import 'dart:async';
import 'dart:convert';

import 'package:mero_school/data/models/request/my_transaction_history_request.dart';
import 'package:mero_school/data/models/response/entrance_config.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/data/models/response/top_course_response.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/alphanum_comparator.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/data/models/response/categories_response.dart';
import 'package:rxdart/rxdart.dart';

class CourseBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;

  CourseBloc() {
    initBloc();
  }

  late bool _isStreaming;

  StreamSink<Response<TopCourseResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<TopCourseResponse>>;

  Stream<Response<TopCourseResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<TopCourseResponse>>;

  //for all plans
  StreamController? _allPlansDataController;

  StreamSink<Response<AllPlansResponse>> get allPlansDataSink =>
      _allPlansDataController!.sink as StreamSink<Response<AllPlansResponse>>;

  Stream<Response<AllPlansResponse>> get allPlansDataStream =>
      _allPlansDataController!.stream as Stream<Response<AllPlansResponse>>;

  //for categories
  StreamController? _categoriesDataController;

  StreamSink<Response<CategoriesResponse>> get categoriesDataSink =>
      _categoriesDataController!.sink
          as StreamSink<Response<CategoriesResponse>>;

  Stream<Response<CategoriesResponse>> get categoriesDataStream =>
      _categoriesDataController!.stream as Stream<Response<CategoriesResponse>>;

  initBloc() {
    _dataController = BehaviorSubject<Response<TopCourseResponse>>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchTopCourse();
    //for all plans
    _allPlansDataController = BehaviorSubject<Response<AllPlansResponse>>();
    fetchAllPlans();

    //for categories
    _categoriesDataController = BehaviorSubject<Response<CategoriesResponse>>();
    fetchCategories();

    _dataEntranceConfigController =
        BehaviorSubject<Response<Entrance_config>>();
    fetchEntranceData();
  }

  refresh() {
    fetchTopCourse();
    fetchCategories();
    fetchAllPlans();
    fetchEntranceData();
  }

  refreshEntrance() {
    fetchEntranceData();
  }

  fetchTopCourse() async {
    var t = await Preference.getString(user_token);

    dataSink.add(Response.loading('Getting a Data!'));
    try {
      TopCourseResponse response =
          await _myNetworkClient.fetchTopCourse(Common.checkNullOrNot(t));

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      //print(e);
    }
  }

  fetchAllPlans() async {
    allPlansDataSink.add(Response.loading('Getting a Data!'));
    //for all plans

    var t = await Preference.getString(user_token);

    try {
      AllPlansResponse response =
          await _myNetworkClient.fetchAllPlans(Common.checkNullOrNot(t), "0");
      //print(response.data);
      //print("=== fetching "+ response.message);

      allPlansDataSink.add(Response.completed(response));
    } catch (e) {
      //print("=== error here fetching "+ e.toString());

      allPlansDataSink.add(Response.error(e.toString()));
    }
  }

  fetchCategories() async {
    categoriesDataSink.add(Response.loading('Getting a Data!'));
    //for all plans
    var t = await Preference.getString(user_token);

    try {
      CategoriesResponse allPlansResponse =
          await _myNetworkClient.fetchCategories(Common.checkNullOrNot(t));

      allPlansResponse.data!.sort((a, b) => AlphanumComparator.compare(
          a.name.toString().trim().toLowerCase(),
          b.name.toString().trim().toLowerCase()));

      if (_isStreaming)
        _categoriesDataController?.add(Response.completed(allPlansResponse));
    } catch (e) {
      if (_isStreaming)
        _categoriesDataController?.add(Response.error(e.toString()));
    }
  }

  StreamController? _dataEntranceConfigController;

  StreamSink<Response<Entrance_config>> get dataEntranceConfigSink =>
      _dataEntranceConfigController!.sink
          as StreamSink<Response<Entrance_config>>;

  Stream<Response<Entrance_config>> get dataEntranceConfigStream =>
      _dataEntranceConfigController!.stream
          as Stream<Response<Entrance_config>>;

  //add this in init() method
  //    _dataEntranceConfigController = StreamController<Response<EntranceConfigResponse>>();

  //add this to dispose
  //    _dataEntranceConfigController?.close();

  fetchEntranceData() async {
    //for all plans

    String? t = "";
    t = await Preference.getString(user_token);



    // if(t!=null && t.isNotEmpty){

    print("fetchining pref $t");
    // _dataEntranceConfigController.add(Response.loading('Getting a Data!'));

    GeneralTokenRequest request = GeneralTokenRequest(authToken: t);


    try {
      Entrance_config response =
          await _myNetworkClient.getEntranceConfig(request);
      if (response.status! && response.data!.url!.isNotEmpty) {

        print("here update");
        _dataEntranceConfigController!.add(Response.completed(response));


      } else {
        print("here updateelse ");

        // _dataEntranceConfigController.add(Response.error(response.message));

      }
    } catch (e) {

      print("here update $e");

      // _dataEntranceConfigController.add(Response.error(e.toString()));

    }
    // }else{
    //   // _dataEntranceConfigController.add(Response.error("Login to view entrance"));
    //
    //   print("fetchining: not token exit");
    //
    // }
  }

  saveData(CategoriesResponse? categoriesResponse) async {
    // var pref = await Preference.load();
    String model = json.encode(categoriesResponse);
    Preference.setString(categoryList, model);
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
    _allPlansDataController?.close();
    _categoriesDataController?.close();
    _dataEntranceConfigController?.close();
  }
}
