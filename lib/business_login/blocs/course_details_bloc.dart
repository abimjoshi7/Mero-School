import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/models/response/certificate_status_response.dart';
import 'base_bloc.dart';

class CourseDetailsBloc extends BaseBloc {
  StreamController? _dataController;
  late bool _isStreaming;

  StreamController? _wishController;
  StreamSink<bool?> get wishSink => _wishController!.sink as StreamSink<bool?>;

  Stream<bool> get wishStream => _wishController!.stream as Stream<bool>;

  StreamController? _certificateController;
  StreamSink<Response<dynamic>> get certSink =>
      _certificateController!.sink as StreamSink<Response<dynamic>>;
  Stream<Response<dynamic>> get certStream =>
      _certificateController!.stream as Stream<Response<dynamic>>;

  StreamSink<Response<CourseDetailsByIdResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<CourseDetailsByIdResponse>>;

  Stream<Response<CourseDetailsByIdResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<CourseDetailsByIdResponse>>;

  initBloc() {
    _dataController = BehaviorSubject<Response<CourseDetailsByIdResponse>>();
    _wishController = BehaviorSubject<bool>();
    _certificateController = BehaviorSubject<Response<dynamic>>();
    myNetworkClient = MyNetworkClient();
    _isStreaming = true;
  }

  fetchCourseDetailsById(String? courseId) async {
    dataSink.add(Response.loading('Getting a Data!'));

    // var pref = await Preference.load();

    var t = await Preference.getString(token);

    print("token-t $t");

    try {
      CourseDetailsByIdResponse response = await myNetworkClient
          .fetchCourseDetailsById(Common.checkNullOrNot(t), courseId);
      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      print("my error:::$e");
    }
  }

  updateWish(bool? isWishlisted) async {
    wishSink.add(isWishlisted);
  }

  checkCertificate(String? courseId) async {
    certSink.add(Response.loading("Getting certificate details"));
    print("Getting certificate deails");
    var t = await Preference.getString(token);

    try {
      CertificateStatusResponse response =
          await myNetworkClient.checkCertificate(t!, courseId);
      certSink.add(Response.completed(response));
    } catch (e) {
      certSink.add(Response.error(e.toString()));
      print("my error:::$e");
    }
  }

  Future<String> generateCertificate(
      String? courseId, BuildContext context) async {
    var t = await Preference.getString(token);
    var downloadfolder = await getApplicationDocumentsDirectory();
    File file = new File("${downloadfolder.path}/$courseId.pdf");
    try {
      var response = await myNetworkClient.getCertificate(t!, courseId!);
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e) {
      print("my error:::$e");
      throw e;
    }
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
    _wishController?.close();
    _certificateController?.close();
  }
}
