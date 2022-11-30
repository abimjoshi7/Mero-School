import 'dart:async';

import 'package:mero_school/data/models/response/filter_course_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:rxdart/rxdart.dart';

class AllCoursePagiBloc {
  late MyNetworkClient _myNetworkClient;
  bool _isLoading = true;
  bool _isFinished = false;

  //for all plans
  StreamController? _allPlansDataController;
  StreamSink<List<Data>?> get allPlansDataSink =>
      _allPlansDataController!.sink as StreamSink<List<Data>?>;
  Stream<List<Data>> get allPlansDataStream =>
      _allPlansDataController!.stream as Stream<List<Data>>;

  final myData = <Data>[];

  initBloc() {
    _myNetworkClient = MyNetworkClient();
    //for all plans
    _allPlansDataController = BehaviorSubject<List<Data>>();

    // fetchAllPlans("0");
  }

  fetchSearch(String searchString, int offset, String? query) async {
    //for all plans
    try {
      if (offset == 0) {
        myData.clear();
      }

      FilterCourseResponse response;
      response =
          await _myNetworkClient.coursesBySearchString(searchString, query);

      // if(query.isEmpty){
      //
      //    response = await _myNetworkClient.coursesBySearchStringOld(searchString);
      //
      // }else{
      //
      //   response = await _myNetworkClient.coursesBySearchString(searchString, query);

      // }

      if (response.data!.isEmpty) {
        _isFinished = true;
      }

      myData.addAll(response.data!);
      _allPlansDataController!.add(myData);

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _allPlansDataController!.add(myData);
    }
  }

  fetchAllCourse(
      String category,
      String? price,
      String? level,
      String? language,
      String? rating,
      String? searchString,
      String catName) async {

    //print("apicall==$category");

    try {
      FilterCourseResponse response = await _myNetworkClient.fetchFilterCourse(
          category, price, level, language, rating, searchString, catName);

      if (response.data!.isEmpty) {
        _isFinished = true;
      }

      myData.addAll(response.data!);
      _allPlansDataController!.add(myData);

      // if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      // if (_isStreaming) dataSink.add(Response.error(e.toString()));

      _isLoading = false;
      _allPlansDataController!.add(myData);
      _allPlansDataController!.add(myData);
      //print(e);
    }
  }

  //
  // coursesBySearchString(String searchString) async {
  //   dataSink.add(Response.loading('Getting a Data!'));
  //   try {
  //     FilterCourseResponse response =
  //     await _myNetworkClient.coursesBySearchString(searchString);
  //
  //    //print("SIZE::"+response.data.length.toString());
  //
  //
  //
  //
  //     ascendingSort(response);
  //
  //     if (_isStreaming) dataSink.add(Response.completed(response));
  //   } catch (e) {
  //     if (_isStreaming) dataSink.add(Response.error(e.toString()));
  //    //print(e);
  //   }
  // }

  //
  // searchPlan(String query) async {
  //   // allPlansDataSink.add(Response.loading('Getting a Data!'));
  //   myData.clear();
  //   try {
  //     SearchPlanRequest request = SearchPlanRequest(
  //         authToken: Common.checkNullOrNot(Preference.getString(token)),
  //         query: query);
  //     AllPlansResponse response =
  //     await _myNetworkClient.searchPlan(request);
  //     myData.addAll(response.data);
  //
  //     allPlansDataSink.add(myData);
  //   } catch (e) {
  //     allPlansDataSink.add(myData);
  //    //print("my error::$e");
  //   }
  // }

  dispose() {
    _isLoading = false;
    myData.clear();
    _allPlansDataController?.close();
  }
}
