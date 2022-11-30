// To parse this JSON data, do
//
//     final planDetailResponseV2 = planDetailResponseV2FromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PlanDetailResponseV2 planDetailResponseV2FromMap(String str) =>
    PlanDetailResponseV2.fromMap(json.decode(str));

String planDetailResponseV2ToMap(PlanDetailResponseV2 data) =>
    json.encode(data.toMap());

class PlanDetailResponseV2 {
  PlanDetailResponseV2({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Datum> data;

  factory PlanDetailResponseV2.fromMap(Map<String, dynamic> json) =>
      PlanDetailResponseV2(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    required this.thumbnail,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.categoryName,
    required this.idFromAnotherServer,
    required this.rating,
    required this.numberOfRatings,
    required this.instructorName,
    required this.totalEnrollment,
    required this.shareableLink,
  });

  final String thumbnail;
  final String id;
  final String title;
  final String originalTitle;
  final String categoryName;
  final String idFromAnotherServer;
  final int rating;
  final int numberOfRatings;
  final String instructorName;
  final dynamic totalEnrollment;
  final String shareableLink;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        thumbnail: json["thumbnail"],
        id: json["id"],
        title: json["title"],
        originalTitle: json["original_title"],
        categoryName: json["category_name"],
        idFromAnotherServer: json["id_from_another_server"],
        rating: json["rating"],
        numberOfRatings: json["number_of_ratings"],
        instructorName:
            json["instructor_name"] == null ? null : json["instructor_name"],
        totalEnrollment: json["total_enrollment"],
        shareableLink: json["shareable_link"],
      );

  Map<String, dynamic> toMap() => {
        "thumbnail": thumbnail,
        "id": id,
        "title": title,
        "original_title": originalTitle,
        "category_name": categoryName,
        "id_from_another_server": idFromAnotherServer,
        "rating": rating,
        "number_of_ratings": numberOfRatings,
        "instructor_name": instructorName == null ? null : instructorName,
        "total_enrollment": totalEnrollment,
        "shareable_link": shareableLink,
      };
}
