import 'dart:convert';

import 'package:mero_school/data/models/response/course_details_by_id_response.dart';

class PrepareLesson {
  PrepareLesson(this.lessons);

  final SPLITTER = '|';

  List<Lessons> lessons = [];

  //create jsonArray
  var root;

  List<String> getList(String path) {
    return path.split(SPLITTER);
  }

  //return jsonArray
  refactorToJsonNested() {
    lessons.forEach((lesson) {
      var list = getList(lesson.title!.trim());
      var pointer = root;

      list.forEach((key) {
        pointer = addChildInArray(key, pointer, lesson);
      });
    });
    return root;
  }

  //return jsonArray
  addChildInArray(String key, pointer, Lessons lesson) {
    //create jsonObject
    var temp;
    var array = checkArrayContainsKey(key, pointer);
  }

  checkArrayContainsKey(String key, pointer) {
    pointer.forEach((element) {
      var child = jsonEncode(element);
      // if(child.ge)
    });
  }
}
