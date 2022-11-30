/// status : true
/// message : "password update"
/// data : {"status":"success"}

class UpdatePasswordResponse {
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  UpdatePasswordResponse({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  UpdatePasswordResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

/// status : "success"

class Data {
  String? _status;

  String? get status => _status;

  Data({String? status}) {
    _status = status;
  }

  Data.fromJson(dynamic json) {
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    return map;
  }
}
