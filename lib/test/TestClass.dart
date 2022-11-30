import 'package:flutter/material.dart';
import 'package:mero_school/data/models/response/course_details_by_id_response.dart';

class TestClass {
  static const SPLITTER = '|';
  var finalMap = Map<String, dynamic>();
  List<Lessons> lessons;
  TestClass(this.lessons);

  void mapperFunction(List<Lessons> lessons) {
    lessons.forEach((element) {
      var parts = element.title!.split(SPLITTER);
      parts.forEach((title) {
        // var map = Map();
        // if (finalMap['title'] != title) {
        //   finalMap['title'] = title;

        // }
      });
    });
    debugPrint("this is map ${finalMap['title']}");
  }
}
