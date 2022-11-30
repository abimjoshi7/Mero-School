import 'package:http/http.dart' as http;
import 'package:mero_school/presentation/constants/api_end_point.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'CustomException.dart';

class ApiService {
  final String _baseUrl = base_url;

  Future<dynamic> getWithParams(String url, String query) async {
    var requestUrl;
    if (query.isEmpty) {
      requestUrl = _baseUrl + url;
    } else {
      requestUrl = _baseUrl + url + "?" + query;
    }
    var responseJson;
    try {
      //debugPrint("Request body: $requestUrl");
      final response = await http.get(Uri.parse(requestUrl));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url));

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithBaseUrl(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String map) async {
    //debugPrint("Request body: $map");
    var responseJson;
    try {
      final response = await http
          .post(Uri.parse(_baseUrl + url), body: map, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        //debugPrint("Method,Url: ${response.request}");
        //debugPrint("Response: $responseJson");
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        //debugPrint("Method,Url: ${response.request}");
        //debugPrint("Response: $responseJson");
        return responseJson;
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw NotFoundException('Record not found');
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
