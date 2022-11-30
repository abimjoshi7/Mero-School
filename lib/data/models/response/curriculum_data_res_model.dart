import 'dart:convert';

CurriculumDataResModel curriculumDataResModelFromMap(String str) =>
    CurriculumDataResModel.fromMap(json.decode(str));

String curriculumDataResModelToMap(CurriculumDataResModel data) =>
    json.encode(data.toMap());

class CurriculumDataResModel {
  CurriculumDataResModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data data;

  factory CurriculumDataResModel.fromMap(Map<String, dynamic> json) =>
      CurriculumDataResModel(
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
    required this.title,
    required this.categoryId,
    required this.userId,
    required this.similarCourseId,
    required this.isFreeCourse,
    required this.paidExpDays,
    required this.hoursLesson,
    required this.requirements,
    required this.outcomes,
    required this.discountFlag,
    required this.discountedPrice,
    required this.price,
    required this.shortDescription,
    required this.description,
    required this.language,
    required this.level,
    required this.appleProductId,
    required this.lastModified,
    required this.visibility,
    required this.numberOfRatings,
    required this.rating,
    required this.courseOverviewProvider,
    required this.idFromAnotherServer,
    required this.categoryName,
    required this.currency,
    required this.instructorName,
    required this.totalEnrollment,
    required this.shareableLink,
    required this.encodedToken,
    required this.certificateStatus,
    required this.sections,
    required this.isPreviewUrl,
    required this.isWishlisted,
    required this.isPurchased,
    required this.isFreeUsed,
    required this.action,
    required this.expDate,
    required this.includes,
  });

  final String title;
  final String categoryId;
  final String userId;
  final List<SimilarCourseId> similarCourseId;
  final dynamic isFreeCourse;
  final String paidExpDays;
  final String hoursLesson;
  final List<String> requirements;
  final List<dynamic> outcomes;
  final String discountFlag;
  final String discountedPrice;
  final String price;
  final String shortDescription;
  final String description;
  final String language;
  final String level;
  final String appleProductId;
  final String lastModified;
  final dynamic visibility;
  final String numberOfRatings;
  final String rating;
  final String courseOverviewProvider;
  final String idFromAnotherServer;
  final String categoryName;
  final String currency;
  final String instructorName;
  final int totalEnrollment;
  final String shareableLink;
  final String encodedToken;
  final bool certificateStatus;
  final List<Section> sections;
  final String isPreviewUrl;
  final bool isWishlisted;
  final bool isPurchased;
  final bool isFreeUsed;
  final String action;
  final String expDate;
  final List<String> includes;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        title: json["title"],
        categoryId: json["category_id"],
        userId: json["user_id"],
        similarCourseId: List<SimilarCourseId>.from(
            json["similar_course_id"].map((x) => SimilarCourseId.fromMap(x))),
        isFreeCourse: json["is_free_course"],
        paidExpDays: json["paid_exp_days"],
        hoursLesson: json["hours_lesson"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        outcomes: List<dynamic>.from(json["outcomes"].map((x) => x)),
        discountFlag: json["discount_flag"],
        discountedPrice: json["discounted_price"],
        price: json["price"],
        shortDescription: json["short_description"],
        description: json["description"],
        language: json["language"],
        level: json["level"],
        appleProductId: json["appleProductId"],
        lastModified: json["last_modified"],
        visibility: json["visibility"],
        numberOfRatings: json["number_of_ratings"],
        rating: json["rating"],
        courseOverviewProvider: json["course_overview_provider"],
        idFromAnotherServer: json["id_from_another_server"],
        categoryName: json["category_name"],
        currency: json["currency"],
        instructorName: json["instructor_name"],
        totalEnrollment: json["total_enrollment"],
        shareableLink: json["shareable_link"],
        encodedToken: json["encoded_token"],
        certificateStatus: json["certificateStatus"],
        sections:
            List<Section>.from(json["sections"].map((x) => Section.fromMap(x))),
        isPreviewUrl: json["is_preview_url"],
        isWishlisted: json["is_wishlisted"],
        isPurchased: json["is_purchased"],
        isFreeUsed: json["is_free_used"],
        action: json["action"],
        expDate: json["exp_date"],
        includes: List<String>.from(json["includes"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "category_id": categoryId,
        "user_id": userId,
        "similar_course_id":
            List<dynamic>.from(similarCourseId.map((x) => x.toMap())),
        "is_free_course": isFreeCourse,
        "paid_exp_days": paidExpDays,
        "hours_lesson": hoursLesson,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "outcomes": List<dynamic>.from(outcomes.map((x) => x)),
        "discount_flag": discountFlag,
        "discounted_price": discountedPrice,
        "price": price,
        "short_description": shortDescription,
        "description": description,
        "language": language,
        "level": level,
        "appleProductId": appleProductId,
        "last_modified": lastModified,
        "visibility": visibility,
        "number_of_ratings": numberOfRatings,
        "rating": rating,
        "course_overview_provider": courseOverviewProvider,
        "id_from_another_server": idFromAnotherServer,
        "category_name": categoryName,
        "currency": currency,
        "instructor_name": instructorName,
        "total_enrollment": totalEnrollment,
        "shareable_link": shareableLink,
        "encoded_token": encodedToken,
        "certificateStatus": certificateStatus,
        "sections": List<dynamic>.from(sections.map((x) => x.toMap())),
        "is_preview_url": isPreviewUrl,
        "is_wishlisted": isWishlisted,
        "is_purchased": isPurchased,
        "is_free_used": isFreeUsed,
        "action": action,
        "exp_date": expDate,
        "includes": List<dynamic>.from(includes.map((x) => x)),
      };
}

class Section {
  Section({
    required this.id,
    required this.title,
    required this.courseId,
    required this.order,
    required this.status,
    required this.encodedToken,
    required this.totalDuration,
    required this.totalLesson,
  });

  final String id;
  final String title;
  final String courseId;
  final String order;
  final String status;
  final dynamic encodedToken;
  final String totalDuration;
  final int totalLesson;

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json["id"],
        title: json["title"],
        courseId: json["course_id"],
        order: json["order"],
        status: json["status"],
        encodedToken: json["encoded_token"],
        totalDuration: json["total_duration"],
        totalLesson: json["total_lesson"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "course_id": courseId,
        "order": order,
        "status": status,
        "encoded_token": encodedToken,
        "total_duration": totalDuration,
        "total_lesson": totalLesson,
      };
}

class SimilarCourseId {
  SimilarCourseId({
    required this.id,
    required this.title,
    required this.paidExpDays,
    required this.lastModified,
    required this.freeExpDays,
    required this.price,
    required this.discountFlag,
    required this.discountedPrice,
    required this.averageRating,
    required this.noRating,
    required this.thumbnail,
  });

  final String id;
  final String title;
  final String paidExpDays;
  final String lastModified;
  final String freeExpDays;
  final String price;
  final String discountFlag;
  final String discountedPrice;
  final String averageRating;
  final String noRating;
  final String thumbnail;

  factory SimilarCourseId.fromMap(Map<String, dynamic> json) => SimilarCourseId(
        id: json["id"],
        title: json["title"],
        paidExpDays: json["paid_exp_days"],
        lastModified: json["last_modified"],
        freeExpDays: json["free_exp_days"],
        price: json["price"],
        discountFlag: json["discount_flag"],
        discountedPrice: json["discounted_price"],
        averageRating: json["average_rating"],
        noRating: json["no_rating"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "paid_exp_days": paidExpDays,
        "last_modified": lastModified,
        "free_exp_days": freeExpDays,
        "price": price,
        "discount_flag": discountFlag,
        "discounted_price": discountedPrice,
        "average_rating": averageRating,
        "no_rating": noRating,
        "thumbnail": thumbnail,
      };
}
