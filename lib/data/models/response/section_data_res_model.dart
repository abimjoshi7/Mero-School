import 'dart:convert';

SectionDataResModel sectionDataResModelFromMap(String str) =>
    SectionDataResModel.fromMap(json.decode(str));

String sectionDataResModelToMap(SectionDataResModel data) =>
    json.encode(data.toMap());

class SectionDataResModel {
  SectionDataResModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Section> data;

  factory SectionDataResModel.fromMap(Map<String, dynamic> json) =>
      SectionDataResModel(
        status: json["status"],
        message: json["message"],
        data: List<Section>.from(json["data"].map((x) => Section.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Section {
  Section({
    required this.title,
    required this.parentId,
    required this.sectionId,
    required this.lessons,
  });

  final String title;
  final String parentId;
  final String sectionId;
  final List<Lesson> lessons;

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        title: json["title"],
        parentId: json["parent_id"],
        sectionId: json["section_id"],
        lessons:
            List<Lesson>.from(json["lessons"].map((x) => Lesson.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "parent_id": parentId,
        "section_id": sectionId,
        "lessons": List<dynamic>.from(lessons.map((x) => x.toMap())),
      };

  @override
  String toString() {
    // TODO: implement toString
    return "Section Data: Parent Id:${this.parentId}, Section Id:${this.sectionId}, title:${this.title}";
  }
}

class Lesson {
  Lesson({
    required this.id,
    required this.attachment,
    required this.attachmentType,
    required this.sectionId,
    required this.isPreview,
    required this.courseId,
    required this.title,
    required this.duration,
    required this.videoType,
    required this.videoUrl,
    required this.isLessonFree,
    required this.lessonType,
  });

  final String id;
  final dynamic attachment;
  final String attachmentType;
  final String sectionId;
  final String isPreview;
  final String courseId;
  final String title;
  final String duration;
  final String videoType;
  final String videoUrl;
  final String isLessonFree;
  final String lessonType;

  factory Lesson.fromMap(Map<String, dynamic> json) => Lesson(
        id: json["id"],
        attachment: json["attachment"],
        attachmentType: json["attachment_type"],
        sectionId: json["section_id"],
        isPreview: json["is_preview"],
        courseId: json["course_id"],
        title: json["title"],
        duration: json["duration"],
        videoType: json["video_type"],
        videoUrl: json["video_url"],
        isLessonFree: json["is_lesson_free"],
        lessonType: json["lesson_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "attachment": attachment,
        "attachment_type": attachmentType,
        "section_id": sectionId,
        "is_preview": isPreview,
        "course_id": courseId,
        "title": title,
        "duration": duration,
        "video_type": videoType,
        "video_url": videoUrl,
        "is_lesson_free": isLessonFree,
        "lesson_type": lessonType,
      };
}
