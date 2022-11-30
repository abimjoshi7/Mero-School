import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/data/models/custom/section_title_model.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';
import 'package:mero_school/data/models/response/my_valid_course_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/data/models/response/video_response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mero_school/data/models/response/section_response.dart';
import 'package:webengage_flutter/webengage_flutter.dart';


class HLSVideoPlayerBloc extends BaseBloc {
  late MyNetworkClient _myNetworkClient;
  bool courseCompleted = false;
  StreamController? _dataController;
  StreamController? _dataControllerSection;
  final _dataControllerTitle = BehaviorSubject<SectionTitle>();
  late StreamController _dataControllerUrl;
  late bool _isStreaming;
  StreamController? _completionController;

  StreamSink<Response<bool>> get completionSink =>
      _completionController!.sink as StreamSink<Response<bool>>;

  Stream<Response<bool>> get completionStream =>
      _completionController!.stream as Stream<Response<bool>>;

  StreamSink<Response<VideoResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<VideoResponse>>;

  Stream<Response<VideoResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<VideoResponse>>;

  StreamSink<Response<SectionResponse>> get dataSinkSection =>
      _dataControllerSection!.sink as StreamSink<Response<SectionResponse>>;

  Stream<Response<SectionResponse>> get dataStreamSection =>
      _dataControllerSection!.stream as Stream<Response<SectionResponse>>;

  StreamSink<SectionTitle> get dataSinkTitle => _dataControllerTitle.sink;

  Stream<SectionTitle> get dataStreamTitle => _dataControllerTitle.stream;

  StreamSink<String?> get dataSinkUrl =>
      _dataControllerUrl.sink as StreamSink<String?>;
  Stream<String> get dataStreamUrl =>
      _dataControllerUrl.stream as Stream<String>;

  String? videoUrl = "";

  initBloc(String? url) {
    videoUrl = url;
    _dataController = BehaviorSubject<Response<VideoResponse>>();
    _dataControllerSection = BehaviorSubject<Response<SectionResponse>>();
    _completionController = BehaviorSubject<Response<bool>>();
    // _dataControllerTitle = BehaviorSubject<SectionTitle>();
    _dataControllerUrl = BehaviorSubject<String>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
  }

  setCompletion(bool status) {
    _completionController!.add(Response.completed(status));
  }

  fetchUpdateCount(int a, int b) {
    // print(" change dA; $a B: $b");

    SectionTitle sectionTitle = _dataControllerTitle.value;
    sectionTitle.totalLesson = a;
    sectionTitle.markedLesson = b;
    dataSinkTitle.add(sectionTitle);
  }

  fetchData(String url) async {
    dataSink.add(Response.loading(empty));
    // var videores = VideoResponse();
    // videores.videoUrl = url;
    // dataSink.add(Response.completed(videores));

    try {
      VideoResponse response = await _myNetworkClient.fetchVideoLink(url);
      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  fetchSection(String? courseId) async {
    var t = await Preference.getString(token);

    dataSinkSection.add(Response.loading('Getting a Data!'));
    try {
      SectionResponse response =
          await _myNetworkClient.section(courseId, Common.checkNullOrNot(t));

      _totalCourse = 0;
      _markedLession = 0;

      response.data!.forEach((element) {
        element.lessons!.forEach((response) {
          _totalCourse = _totalCourse + 1;
          if (response.isCompleted.toString() == "1") {
            _markedLession = _markedLession + 1;
          }
        });
      });

      if (_isStreaming) dataSinkSection.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSinkSection.add(Response.error(e.toString()));
      print(e);
    }
  }

  int _totalCourse = 0;
  int _markedLession = 0;

  fetchTitle(
      String? courseTitle,
      String? subTitle,
      String? url,
      int? totalCourse,
      int? markedLesson,
      String? chapter,
      String? lesDuration) {
    SectionTitle title = SectionTitle(courseTitle, subTitle, _totalCourse,
        _markedLession, chapter, lesDuration);
    dataSinkTitle.add(title);
    dataSinkUrl.add(url);

    // print("fetchTitle: $courseTitle $subTitle");

    //send tag:::
    // Video Name
    // Chapter Name
    // Category Name
    // Category Id
    // Course Name
    // Course Id
    // Video Duration
    // print("====send tage: ");
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
    _dataControllerSection?.close();
    _dataControllerTitle.close();
  }

  Future<void> fetchAndLog(
      String? courseId, String? url, String tag, double percent) async {
    print("LOG WEB $courseId $url $tag");
    var t = await Preference.getString(token);

    if (url == null || url.isEmpty) {
      url = videoUrl;
    }

    if (course_data == null) {
      course_data = await myNetworkClient.fetchCourseDetailsById(
          Common.checkNullOrNot(t), courseId);
    }

    String? chapter = "";
    String? videoTitle = "";
    String? lessonDuration = "";

    int total = 0;

    course_data!.sections!.forEach((s) {
      chapter = s.title;

      s.lessons!.forEach((l) {
        total = total + 1;

        if (videoUrl == null || videoUrl!.isEmpty) {
          videoUrl = l.videoUrl;
        }

        if (url == l.videoUrl) {
          // print("comparing; $url ${l.videoUrl}");

          lessonDuration = l.duration;
          videoTitle = l.title;
        }
      });
    });

    if (tag == TAG_VIDEO_STARTED) {
      WebEngagePlugin.trackEvent(TAG_VIDEO_STARTED, {
        'Course Id': int.parse(course_data!.id!),
        'Video Name': "$videoTitle",
        'Chapter Name': "$chapter",
        'Category Id': course_data!.categoryId != null
            ? int.tryParse(course_data!.categoryId!)
            : 0,
        'Course Name': course_data!.title,
        'Category Name': course_data!.categoryName,
        'Video Duration': lessonDuration,
      });
    } else if (tag == TAG_VIDEO_COMPLETED) {
      WebEngagePlugin.trackEvent(TAG_VIDEO_COMPLETED, {
        'Course Id': int.parse(course_data!.id!),
        'Video Name': "$videoTitle",
        'Chapter Name': "$chapter",
        'Category Id': course_data!.categoryId != null
            ? int.tryParse(course_data!.categoryId!)
            : 0,
        'Course Name': course_data!.title,
        'Category Name': course_data!.categoryName,
        'Video Duration': lessonDuration,
      });
    } else if (tag == TAG_COURSE_COMPLETION) {
      //bank deposite complet

      var priceToSend = 0.0;
      var discountPrice = 0.0;
      if (course_data!.discountFlag!.trim() == "1") {
        priceToSend = double.parse(course_data!.discountedPrice!);
        discountPrice = double.parse(course_data!.price!) -
            double.parse(course_data!.discountedPrice!);
      } else {
        priceToSend = double.parse(course_data!.price!);
      }

      WebEngagePlugin.trackEvent(TAG_COURSE_COMPLETION, {
        'Category Id': int.parse(course_data!.categoryId!),
        'Category Name': "${course_data!.categoryName}",
        'Course Time Duration': "${course_data!.hoursLesson}",
        'Course Created By': '${course_data!.instructorName}',
        'Course Id': int.parse(course_data!.id!),
        'Course Level': "${course_data!.level}",
        'Price': priceToSend,
        'Course Name': course_data!.title,
        'Discount': discountPrice,
        'Percentage Completed': percent.toInt(),
        'Course Expiry Date': '${course_data!.expDate}',
        'Video Name': "$videoTitle",
        'Total Lessons': total,

        // 'Action': ack ? 'Mark As Complete': "Mark As InComplete"
      });
    }
  }

  CourseDetailsByIdResponse? course_data;

  void log(String courseId, String s, String t, String courseTimeDuration) {
    // print("LOG_VIDEO courseId $course_id chapter: $s video: $t duration $course_time_duration");
  }

  fetchValidCourse() async {
    var t = await Preference.getString(token);

    MyValidCourseResponse systemSettings =
        await _myNetworkClient.fetchValidCourse(Common.checkNullOrNot(t));

    const platform = const MethodChannel("native_channel");
    var map = {
      "validIds": jsonEncode(systemSettings.data),
    };

    platform.invokeMethod("validCourse", map);
  }
}
