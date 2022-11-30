import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:mero_school/networking/ApiProvider.dart';
import 'package:mero_school/networking/CustomException.dart';
import 'package:mero_school/presentation/constants/api_end_point.dart';

String getQuizRootUrl() {
  var base = getRootUrl();
  if (base == "https://mero.school/") {
    return "https://playquiz.mero.school/";
  } else {
    //return "https://playquiz.mero.school/";
     return "https://quiz.yunik.live/";
  }
}

String getAuthorization() {
  var base = getRootUrl();
  if (base == "https://mero.school/") {
    var auth = 'Basic ' + base64Encode(utf8.encode('api_user:dtNqN3Yyk3qv2W'));
    return auth;
  } else {
    var auth = 'Basic ' + base64Encode(utf8.encode('unique1o1:0'));
    return auth;
  }
}

class QuizApiProvider {
  final String _baseUrl = getQuizRootUrl();

  Future<dynamic> getWithParams(String url, String query) async {
    var requestUrl;
    if (query.isEmpty) {
      requestUrl = _baseUrl + url;
    } else {
      requestUrl = _baseUrl + url + "?" + query;
    }
    var responseJson;
    try {
      // debugPrint("Request body: $requestUrl");

      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp.get(Uri.parse(requestUrl),
          headers: {"Authorization": "$getAuthorization()"});
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String map) async {
    debugPrint("Request body: $map");
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp
          .post(Uri.parse(_baseUrl + url), body: map, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "${getAuthorization()}"
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postStatusCode(String url, String map) async {
    debugPrint("Request body: $map");
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp
          .post(Uri.parse(_baseUrl + url), body: map, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "${getAuthorization()}"
      });

      responseJson = _response_status_code(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response_status_code(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return 200;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        {
          var responseJson = json.decode(response.body.toString());

          throw NotFoundException(responseJson['message'] != null
              ? responseJson['message']
              : 'Record not found');
        }
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());

        debugPrint("Response: $responseJson");
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        {
          var responseJson = json.decode(response.body.toString());

          throw NotFoundException(responseJson['message'] != null
              ? responseJson['message']
              : 'Record not found');
        }

      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
