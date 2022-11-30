/// status : true
/// message : "status removed"
/// data : "removed"

class RemoveWishListResponse {
  bool? _status;
  String? _message;
  String? _data;

  bool? get status => _status;
  String? get message => _message;
  String? get data => _data;

  RemoveWishListResponse({bool? status, String? message, String? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  RemoveWishListResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["data"] = _data;
    return map;
  }
}
