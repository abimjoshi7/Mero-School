// To parse this JSON data, do
//
//     final googlePriceResModel = googlePriceResModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GooglePriceResModel googlePriceResModelFromMap(String str) =>
    GooglePriceResModel.fromMap(json.decode(str));

String googlePriceResModelToMap(GooglePriceResModel data) =>
    json.encode(data.toMap());

class GooglePriceResModel {
  GooglePriceResModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data data;

  factory GooglePriceResModel.fromMap(Map<String, dynamic> json) =>
      GooglePriceResModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data.toMap(),
      };
}

class Data {
  Data({
    required this.id,
    required this.title,
    required this.googleProductId,
    required this.googleProductPrice,
    required this.ussdSymbol,
  });

  final String id;
  final String title;
  final String googleProductId;
  final String googleProductPrice;
  final String ussdSymbol;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        googleProductId: json["google_product_id"],
        googleProductPrice: json["google_product_price"],
        ussdSymbol: json["ussd_symbol"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "google_product_id": googleProductId,
        "google_product_price": googleProductPrice,
        "ussd_symbol": ussdSymbol,
      };
}
