// To parse this JSON data, do
//
//     final inAppPaymentResponse = inAppPaymentResponseFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InAppPaymentResponse inAppPaymentResponseFromMap(String str) =>
    InAppPaymentResponse.fromMap(json.decode(str));

String inAppPaymentResponseToMap(InAppPaymentResponse data) =>
    json.encode(data.toMap());

class InAppPaymentResponse {
  InAppPaymentResponse({
    required this.status,
    required this.message,
    required this.purchaseToken,
  });

  final bool status;
  final String message;
  final String purchaseToken;

  factory InAppPaymentResponse.fromMap(Map<String, dynamic> json) =>
      InAppPaymentResponse(
        status: json["status"],
        message: json["message"],
        purchaseToken: json["purchaseToken"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "purchaseToken": purchaseToken,
      };
}
