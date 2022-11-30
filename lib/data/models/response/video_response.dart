/// video_url : "http://video.mero.school/science%2010/0.%20Introduction%20To%20Science%7C2.%20Mark%20Distribution"

class VideoResponse {
  String? _videoUrl;

  String? get videoUrl => _videoUrl;

  set videoUrl(String? value) {
    _videoUrl = value;
  }

  VideoResponse({String? videoUrl}) {
    _videoUrl = videoUrl;
  }

  VideoResponse.fromJson(dynamic json) {
    _videoUrl = json["video_url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["video_url"] = _videoUrl;
    return map;
  }
}
