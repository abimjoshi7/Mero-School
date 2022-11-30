/// status : true
/// message : "status removed"
/// data : "removed"

class GenericResponse {
  bool? _status;
  String? _message;

  bool? get status => _status;
  String? get message => _message;
  // String get data => _data;

  UserImageResponse({bool? status, String? message}) {
    _status = status;
    _message = message;
  }

  GenericResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    return map;
  }
}
