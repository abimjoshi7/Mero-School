import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mero_school/data/models/response/my_valid_course_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/data/models/response/my_course_response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class MyCourseBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;
  late bool _isStreaming;

  StreamSink<Response<MyCourseResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<MyCourseResponse>>;

  Stream<Response<MyCourseResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<MyCourseResponse>>;

  initBloc() {
    _dataController = StreamController<Response<MyCourseResponse>>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchData();
    fetchValidCourse();
  }

  fetchData() async {
    dataSink.add(Response.loading('Getting a Data!'));

    var t = await Preference.getString(token);

    try {
      MyCourseResponse systemSettings =
          await _myNetworkClient.fetchMyCourses(Common.checkNullOrNot(t));
      if (_isStreaming) dataSink.add(Response.completed(systemSettings));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
    }
  }

  fetchValidCourse() async {
    var t = await Preference.getString(token);

    MyValidCourseResponse systemSettings =
        await _myNetworkClient.fetchValidCourse(Common.checkNullOrNot(t));

    // print("validcourse ${systemSettings.data.toString()}");

    const platform = const MethodChannel("native_channel");
    var map = {
      "validIds": jsonEncode(systemSettings.data),
    };

    platform.invokeMethod("validCourse", map);
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
  }
}
