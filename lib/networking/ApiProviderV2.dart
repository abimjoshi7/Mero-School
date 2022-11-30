// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:mero_school/presentation/constants/api_end_point.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';
// import 'CustomException.dart';
//
// class ApiProviderV2 {
//   final String _baseUrl = base_url_V2;
//
//   Future<dynamic> getWithParams(String url, String query) async {
//     var requestUrl;
//     if (query.isEmpty) {
//       requestUrl = _baseUrl + url;
//     } else {
//       requestUrl = _baseUrl + url + "?" + query;
//     }
//     var responseJson;
//     try {
//       debugPrint("Request body: $requestUrl");
//       final response = await http.get(Uri.parse(requestUrl));
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }
//
//   Future<dynamic> get(String url) async {
//     var responseJson;
//     try {
//       final response = await http.get(Uri.parse(_baseUrl + url));
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }
//
//   Future<dynamic> getWithBaseUrl(String url) async {
//     var responseJson;
//     try {
//       final response = await http.get(Uri.parse(url));
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }
//
//   Future<dynamic> post(String url, String map) async {
//     debugPrint("Request body: $map");
//     var responseJson;
//     try {
//       final response = await http
//           .post(Uri.parse(_baseUrl + url), body: map, headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       });
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }
//
//   Future<dynamic> uploadFile(String url, File file, String token) async {
//     var responseJson;
//     var postUri = Uri.parse(_baseUrl + url);
//
//     http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
//
//     http.MultipartFile multipartFile =
//         await http.MultipartFile.fromPath('file', file.path);
//
//     request.files.add(multipartFile);
//     request.fields["auth_token"] = token;
//
//     try {
//       await request.send().then((responseValue) async {
//         responseValue.stream.transform(utf8.decoder).listen((event) {
//           switch (responseValue.statusCode) {
//             case 200:
//               responseJson = json.decode(event);
//               // debugPrint("Method,Url: ${response.request}");
//               debugPrint("Response: $responseJson");
//               return responseJson;
//             case 400:
//               throw BadRequestException(event.toString());
//             case 401:
//
//             case 403:
//               throw UnauthorisedException(event.toString());
//             case 404:
//               throw NotFoundException('Record not found');
//             case 500:
//
//             default:
//               throw FetchDataException(
//                   'Error occured while Communication with Server');
//           }
//           // responseJson = event ;
//         });
//       });
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//
//     return responseJson;
//   }
//
//   dynamic _response(http.Response response) {
//     debugPrint("Method,Url: ${response.request}");
//     switch (response.statusCode) {
//       case 200:
//         var responseJson = json.decode(response.body.toString());
//
//         debugPrint("Response: $responseJson");
//         return responseJson;
//       case 400:
//         throw BadRequestException(response.body.toString());
//       case 401:
//
//       case 403:
//         throw UnauthorisedException(response.body.toString());
//       case 404:
//         throw NotFoundException('Record not found');
//       case 500:
//
//       default:
//         throw FetchDataException(
//             'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
//     }
//   }
// }
