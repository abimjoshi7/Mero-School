import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mero_school/data/models/response/categories_response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/alphanum_comparator.dart';

class Raw {
  static List<String> getPrice() {
    return ["All", "Free", "Paid"];
  }

  static List<String> getLevel() {
    return ["All", "Beginner", "Intermediate", "Advanced"];
  }

  static List<String> getLanguage() {
    return ["All", "English", "Nepali"];
  }

  static List<String?> getRating() {
    return ["All", "⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"];
  }

  static List<Data> getCategoryWithModel(String categoryList) {
    List<Data> model = [];
    model.add(Data(
        id: "0",
        code: empty,
        name: all,
        parent: empty,
        slug: empty,
        dateAdded: empty,
        lastModified: empty,
        fontAwesomeClass: empty,
        thumbnail: empty,
        numberOfCourses: 0));
    Map map = json.decode(categoryList);
    var categoriesResponse = CategoriesResponse.fromJson(map);
    debugPrint("test${categoriesResponse.data!.last.name}");
    model.addAll(categoriesResponse.data!);
    return model;
  }

  static List<String?> getCategory(String? categoryList) {
    List<String?> model = [];
    model.add("All");

    if (categoryList != null) {
      Map map = json.decode(categoryList);
      var categoriesResponse = CategoriesResponse.fromJson(map);
      categoriesResponse.data!.forEach((element) {
        if (element.numberOfCourses != 0) {
          model.add(element.name);
        }
      });
    }
    model.sort((a, b) => AlphanumComparator.compare(
        a!.trim().toLowerCase(), b!.trim().toLowerCase()));

    // debugPrint("test${categoriesResponse.data.last.name}");
    // model.addAll(categoriesResponse.data);
    return model;
  }
}
