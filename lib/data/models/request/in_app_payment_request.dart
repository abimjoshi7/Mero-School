// To parse this JSON data, do
//
//     final inAppPaymentRequest = inAppPaymentRequestFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InAppPaymentRequest inAppPaymentRequestFromMap(String str) => InAppPaymentRequest.fromMap(json.decode(str));

String inAppPaymentRequestToMap(InAppPaymentRequest data) => json.encode(data.toMap());

class InAppPaymentRequest {
  InAppPaymentRequest({
    required this.orderId,
    required this.packageName,
    required this.productId,
    required this.purchaseTime,
    required this.purchaseState,
    required this.purchaseToken,
    required this.quantity,
    required this.acknowledged,
    required this.authToken,
  });

  final String orderId;
  final String packageName;
  final String productId;
  final int purchaseTime;
  final int purchaseState;
  final String purchaseToken;
  final int quantity;
  final bool acknowledged;
  final String authToken;

  factory InAppPaymentRequest.fromMap(Map<String, dynamic> json) => InAppPaymentRequest(
    orderId: json["orderId"],
    packageName: json["packageName"],
    productId: json["productId"],
    purchaseTime: json["purchaseTime"],
    purchaseState: json["purchaseState"],
    purchaseToken: json["purchaseToken"],
    quantity: json["quantity"],
    acknowledged: json["acknowledged"],
    authToken: json["auth_token"],
  );

  Map<String, dynamic> toMap() => {
    "orderId": orderId,
    "packageName": packageName,
    "productId": productId,
    "purchaseTime": purchaseTime,
    "purchaseState": purchaseState,
    "purchaseToken": purchaseToken,
    "quantity": quantity,
    "acknowledged": acknowledged,
    "auth_token": authToken,
  };
}
