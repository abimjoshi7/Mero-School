import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiService {
  final String _baseUrl = "https://demo.mero.school/Api/";

  Future<dynamic> get(String path) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + path));

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
      // "No internet connection. Please check your internet."
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
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
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

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class NotFoundException extends CustomException {
  NotFoundException([String? message]) : super(message, "");
}
