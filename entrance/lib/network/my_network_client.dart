import 'dart:convert';

import 'package:entrance/data/model.dart';
import 'package:entrance/network/api_service.dart';

class MyNetworkClient {
  ApiService _service = ApiService();

  /// 1. Generic response object to return
  /// 2. Path to the endpoint
  /// 3. QueryParameters Optional
  Future<T> getDataPath<T extends Model>(T t, String path,
      {Map<String, dynamic>? queryParams}) async {
    var reqPath = path;
    if (queryParams != null) {
      queryParams.forEach((key, value) {
        reqPath = '$reqPath&$key=$value';
      });
    }
    final response = await _service.get(reqPath);
    return t.fromJson(response);
  }

  /// 1. Generic response object to return
  /// 2. Path to the endpoint
  /// 3. Body encoded in json Optional
  /// 4. Generic Request Send params
  Future<T> postDataPath<T extends Model, S extends Model>(T t, String path,
      {S? s}) async {
    Map<String, dynamic> body = Map();
    if (s != null) {
      body = s.toJson();
    }
    final response = await _service.post(path, jsonEncode(body));
    return t.fromJson(response);
  }
}
