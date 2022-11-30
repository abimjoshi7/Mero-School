import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/data/models/response/filter_course_response.dart';

class AllCourseBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;
  late bool _isStreaming;

  StreamSink<Response<FilterCourseResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<FilterCourseResponse>>;

  Stream<Response<FilterCourseResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<FilterCourseResponse>>;

  initBloc() {
    _dataController = StreamController<Response<FilterCourseResponse>>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
  }

  fetchAllCourse(String category, String price, String level, String language,
      String rating, String searchString, String catName) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      FilterCourseResponse response = await _myNetworkClient.fetchFilterCourse(
          category, price, level, language, rating, searchString, catName);

      ascendingSort(response);
      response.data!.forEach((element) {
        debugPrint("after ${element.title}");
      });

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      //print(e);
    }
  }

  fetchCategoryWiseCourse(String categoryId) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      FilterCourseResponse response =
          await _myNetworkClient.fetchCategoryWiseCourse(categoryId);
      ascendingSort(response);

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      //print(e);
    }
  }

  Future<FilterCourseResponse?> coursesBySearchStringPaged(
      String searchString) async {
    dataSink.add(Response.loading('Getting a Data!'));

    try {
      FilterCourseResponse response =
          await _myNetworkClient.coursesBySearchString(searchString, "");

      //print("SIZE::"+response.data.length.toString());
      ascendingSort(response);

      return response;

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      //print(e);
    }
    return null;
  }

  coursesBySearchString(String searchString, String plain) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      FilterCourseResponse response =
          await _myNetworkClient.coursesBySearchString(searchString, plain);

      //print("SIZE::"+response.data.length.toString());

      ascendingSort(response);

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      //print(e);
    }
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
  }

  FilterCourseResponse ascendingSort(FilterCourseResponse response) {
    // response.data.sort((a, b) => AlphanumComparator.compare(
    //     a.title.toString().trimRight().toUpperCase(),
    //     b.title.toString().trimRight().toUpperCase()));

    response.data!.sort((a, b) => a.title
        .toString()
        .trimRight()
        .toUpperCase()
        .compareTo(b.title.toString().trimRight().toUpperCase()));
    response.data!.forEach((element) {
      debugPrint("after ${element.title}");
    });

    return response;
  }
}
