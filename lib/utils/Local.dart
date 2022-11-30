import 'package:get_storage/get_storage.dart';

class Local {
  String? getString(String key) {
    print("called: " + key);
    GetStorage getStorage = GetStorage();

    if (getStorage.hasData(key)) {
      print("hasData");
      return getStorage.read(key);
    }

    return null;
  }

  void setString(String key, String value) {
    GetStorage getStorage = GetStorage();
    getStorage.write(key, value);
  }

  void setInt(String key, int value) {
    GetStorage getStorage = GetStorage();
    getStorage.write(key, value);
  }

  void setDouble(String key, double value) {
    GetStorage getStorage = GetStorage();
    getStorage.write(key, value);
  }

  void setStringList(String key, List<String> value) {
    GetStorage getStorage = GetStorage();
    getStorage.write(key, value);
  }

  void setBool(String key, bool value) {
    GetStorage getStorage = GetStorage();
    getStorage.write(key, value);
  }

  //getStringList

  List<String>? getStringList(String key) {
    GetStorage getStorage = GetStorage();
    return getStorage.read(key);
  }

  int? getInt(String key) {
    GetStorage getStorage = GetStorage();
    return getStorage.read(key);
  }

  bool? getBool(String key) {
    GetStorage getStorage = GetStorage();
    return getStorage.read(key);
  }

  double? getDouble(String key) {
    GetStorage getStorage = GetStorage();
    return getStorage.read(key);
  }

  void remove(String key) {
    GetStorage getStorage = GetStorage();
    getStorage.remove(key);
  }
}
