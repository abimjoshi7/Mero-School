import 'dart:async';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/data/models/response/my_course_response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:rxdart/rxdart.dart';

class ExpiredCourseBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;
  late bool _isStreaming;

  StreamSink<Response<MyCourseResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<MyCourseResponse>>;

  Stream<Response<MyCourseResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<MyCourseResponse>>;

  initBloc() {
    _dataController = BehaviorSubject<Response<MyCourseResponse>>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Getting a Data!'));
    var t = await Preference.getString(token);

    try {
      MyCourseResponse response =
          await _myNetworkClient.fetchCoursesExpire(Common.checkNullOrNot(t));
      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      // print(e);
    }
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
  }
}
