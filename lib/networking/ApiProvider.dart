import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mero_school/main.dart';
import 'package:mero_school/presentation/constants/api_end_point.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/utils/toast_helper.dart';

import 'CustomException.dart';

class ApiProvider {
  final String _baseUrl = base_url;
  final String _baseUrl_v2 = base_url_V2;

  // ApiProvider(this.context);

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

      final response = await myHttp.get(Uri.parse(requestUrl));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithParamsV2(String url, String query) async {
    var requestUrl;
    if (query.isEmpty) {
      requestUrl = _baseUrl_v2 + url;
    } else {
      requestUrl = _baseUrl_v2 + url + "?" + query;
    }
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp.get(Uri.parse(requestUrl));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithParamsGithub(String url, String query) async {
    var requestUrl;

    // var baseGithub ="https://search.mero.school/indexes/courses/search?";
    var baseGithub = "https://search.mero.school/indexes/courses_v2/search?";

    if (getRootUrl().contains("demo.mero.school")) {
      baseGithub =
          "http://gitea.podamibe.net:7700/indexes/courses_test/search?"; //demo.mero.school
    }

    if (query.isEmpty) {
      requestUrl = baseGithub;
    } else {
      requestUrl = baseGithub + query;
    }
    http.Client myHttp =
        InterceptedClient.build(interceptors: [LoggerInterceptor()]);

    var responseJson;
    try {
      // debugPrint("Request body: $requestUrl");
      final response = await myHttp.get(Uri.parse(requestUrl), headers: {
        'X-Meili-API-Key':
            '4d63491312373693b41c05636a4c40461a97740be379d8d23c8c6defcdbfb980',
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp.get(
        Uri.parse(_baseUrl + url),
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithBaseUrl(String url) async {
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp.get(Uri.parse(url));
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
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<http.Response> postDirectResponse(String url, String map) async {
    debugPrint("Request body: $map");
    var responseData;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);
      http.Response response = await myHttp.post(Uri.parse(_baseUrl + url),
          body: map,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/pdf'
          });
      var bodybytes = response.bodyBytes;
      // log(response.reasonPhrase.toString());
      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> postV2(String url, String map) async {
    debugPrint("Request body: $map");
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);
      final response = await myHttp.post(Uri.parse(_baseUrl_v2 + url),
          body: map,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postWithError(String url, String map) async {
    // debugPrint("Request body: $map");
    var responseJson;
    try {
      http.Client myHttp =
          InterceptedClient.build(interceptors: [LoggerInterceptor()]);

      final response = await myHttp
          .post(Uri.parse(_baseUrl + url), body: map, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> uploadFile(String url, File file, String token) async {
    var responseJson;
    var postUri = Uri.parse(_baseUrl + url);

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', file.path);

    request.files.add(multipartFile);
    request.fields["auth_token"] = token;

    try {
      await request.send().then((responseValue) async {
        responseValue.stream.transform(utf8.decoder).listen((event) {
          switch (responseValue.statusCode) {
            case 200:
              responseJson = json.decode(event);
              // debugPrint("Method,Url: ${response.request}");
              debugPrint("Response: $responseJson");
              return responseJson;
            case 400:
              throw BadRequestException(event.toString());
            case 401:

            case 403:
              throw UnauthorisedException(event.toString());
            case 404:
              throw NotFoundException('Record not found');
            case 500:

            default:
              throw FetchDataException(
                  'Error occured while Communication with Server');
          }
          // responseJson = event ;
        });
      });
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> uploadFileWithFields(
      String url, String path, String token, Map<String, String> maps) async {
    var responseJson;
    var postUri = Uri.parse(_baseUrl + url);

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('voucher_thumbnail', path);

    request.files.add(multipartFile);
    request.fields["auth_token"] = token;
    request.fields.addAll(maps);

    try {
      await request.send().then((responseValue) async {
        responseValue.stream.transform(utf8.decoder).listen((event) {
          switch (responseValue.statusCode) {
            case 200:
              responseJson = json.decode(event);
              // debugPrint("Method,Url: ${response.request}");
              debugPrint("Response: $responseJson");
              return responseJson;
            case 400:
              throw BadRequestException(event.toString());
            case 401:

            case 403:
              throw UnauthorisedException(event.toString());
            case 404:
              throw NotFoundException('Record not found');
            case 500:

            default:
              throw FetchDataException(
                  'Error occurred while Communication with Server');
          }
          // responseJson = event ;
        });
      });
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  dynamic _response(http.Response response) {
    debugPrint("Method,Url: ${response.request}");
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

class LoggerInterceptor implements InterceptorContract {
  // final BuildContext context;
  //
  // LoggerInterceptor({this.context});

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("----- Request ==>");
    print(data.toString());
    print("----- Request ==>");

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("<==----- Response -----");
    print(data.toString());
    print("<==----- Response -----");

    if (data.statusCode == 406) {
      // Preference.remove(token);
      Future.delayed(Duration(milliseconds: 100), () {
        // Navigator.pushNamed(context, login_page);

        ToastHelper.showErrorLong(
            "Login Token Expired. Please Try Login Again.");

        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            login_page, (Route<dynamic> route) => false,
            arguments: <String, String>{'root': 'splash'});
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            login_page, (Route<dynamic> route) => false,
            arguments: <String, String>{'root': 'splash'});
      });

      //print("!!!!!!!!!!!!!!!!!!!!!!!!!! TOKEN EXPIRED !!!!!!!!!!!!!!!!!!!!!!!!!!");
    }

    return data;
  }
}
