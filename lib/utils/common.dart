import 'dart:io';

import 'package:mero_school/presentation/constants/strings.dart';
import 'package:http/http.dart' as http;
import 'package:mero_school/utils/preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';

class Common {
  static String checkNullOrNot(String? value) {
    if (value == null) {
      return empty;
    } else {
      return value;
    }
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static Future<String> downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<bool> isUserLogin() async {
    var t = await Preference.getString(token);
    if (checkNullOrNot(t) == empty) {
      return false;
    } else {
      return true;
    }
  }

//here goes the function
  static String parseHtmlString(String? htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
