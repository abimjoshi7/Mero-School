import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  // static Preference prefs;
  static Map<String, dynamic> _memoryPrefs = Map<String, dynamic>();

  // static Future<Preference> load() async {
  //   if (prefs == null) {
  //     prefs = Preference();
  //   }
  //   return prefs;
  // }

  static Future<void> setString(String key, String? value) async {
    // prefs.setString(key, value);
    // _memoryPrefs[key] = value;
    //

    if (value == null) {
      print("issueCheck------------------------>>> $key");
      value = "";
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);

    // print("save=== write(key $key value $value");
    // GetStorage().write(key, value);
  }

  static void setInt(String key, int value) async {
    // prefs.setInt(key, value);
    // _memoryPrefs[key] = value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);

    // GetStorage().write(key, value);
  }

  static void setDouble(String key, double value) {
    // prefs.setDouble(key, value);
    // _memoryPrefs[key] = value;

    GetStorage().write(key, value);
  }

  static void setBool(String key, bool value) {
    // prefs.setBool(key, value);
    // _memoryPrefs[key] = value;
    GetStorage().write(key, value);
  }

  static void setStringList(String key, List<String> value) {
    // prefs.setStringList(key, value);
    // _memoryPrefs[key] = value;

    GetStorage().write(key, value);
  }

  static List<String>? getStringList(String key) {
    // List<String> val;
    // if (_memoryPrefs.containsKey(key)) {
    //   val = _memoryPrefs[key];
    // }
    // if (val == null) {
    //   val = prefs.getStringList(key);
    // }
    // if (val == null) {
    //   val = List.empty();
    // }
    // _memoryPrefs[key] = val;
    // return val;

    return GetStorage().read(key);
  }

  static Future<String?> getString(String key, {String? def}) async {
    String? val;
    // if (_memoryPrefs.containsKey(key)) {
    //   val = _memoryPrefs[key];
    // }
    // if (val == null) {
    //   val = prefs.getString(key);
    // }
    // if (val == null) {
    //   val = def;
    // }
    // _memoryPrefs[key] = val;
    // return val;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    val = prefs.getString(key);

    if (val == null) {
      return def;
    }

    return val;
  }

  // static String getString(String key) {
  //   // String val;
  //   // if (_memoryPrefs.containsKey(key)) {
  //   //   val = _memoryPrefs[key];
  //   // }
  //   // if (val == null) {
  //   //   val = prefs.getString(key);
  //   // }
  //   // if (val == null) {
  //   //   val = def;
  //   // }
  //   // _memoryPrefs[key] = val;
  //   // return val;
  //
  //   return GetStorage().read(key);
  //
  // }

  static int? getInt(String key, {int? def}) {
    // int val;
    // if (_memoryPrefs.containsKey(key)) {
    //   val = _memoryPrefs[key];
    // }
    // if (val == null) {
    //   val = prefs.getInt(key);
    // }
    // if (val == null) {
    //   val = def;
    // }
    // _memoryPrefs[key] = val;
    // return val;

    return GetStorage().read(key);
  }

  static double? getDouble(String key, {double? def}) {
    // double val;
    // if (_memoryPrefs.containsKey(key)) {
    //   val = _memoryPrefs[key];
    // }
    // if (val == null) {
    //   val = prefs.getDouble(key);
    // }
    // if (val == null) {
    //   val = def;
    // }
    // _memoryPrefs[key] = val;
    // return val;

    return GetStorage().read(key);
  }

  static bool? getBool(String key, {bool def = false}) {
    // bool val;
    // if (_memoryPrefs.containsKey(key)) {
    //   val = _memoryPrefs[key];
    // }
    // if (val == null) {
    //   val = prefs.getBool(key);
    // }
    // if (val == null) {
    //   val = def;
    // }
    // _memoryPrefs[key] = val;
    //

    return GetStorage().read(key);

    // return val;
  }

  static Future<void> remove(String key) async {
    // prefs.remove(key);
    // _memoryPrefs.remove(key);

    print("save=== remove key $key");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);

    GetStorage().remove(key);
  }
}

// class MyPref{
//
//     void setString(String key, String value){
//       GetStorage getStorage = GetStorage();
//       getStorage.write(key, value);
//     }
//
//     void setInt(String key, int value){
//       GetStorage getStorage = GetStorage();
//       getStorage.write(key, value);
//     }
//
//     void setDouble(String key, double value){
//       GetStorage getStorage = GetStorage();
//       getStorage.write(key, value);
//     }
//
//     void  setStringList(String key, List<String> value) {
//       GetStorage getStorage = GetStorage();
//       getStorage.write(key, value);
//     }
//
//     void setBool(String key, bool value){
//       GetStorage getStorage = GetStorage();
//       getStorage.write(key, value);
//     }
//
//
//
//     String getString(String key){
//
//       print("called");
//
//       GetStorage getStorage = GetStorage();
//       return getStorage.read(key);
//     }
//
//     //getStringList
//
//
//     List<String> getStringList(String key){
//       GetStorage getStorage = GetStorage();
//       return getStorage.read(key);
//     }
//
//     int getInt(String key){
//       GetStorage getStorage = GetStorage();
//       return getStorage.read(key);
//     }
//
//     bool getBool(String key){
//       GetStorage getStorage = GetStorage();
//       return getStorage.read(key);
//     }
//
//     double getDouble(String key){
//       GetStorage getStorage = GetStorage();
//       return getStorage.read(key);
//     }
//
//
//     void remove(String key){
//       GetStorage getStorage = GetStorage();
//       getStorage.remove(key);
//     }
//
// }
