/// status : true
/// message : ""
/// data : null

class InAppValidateResponse {
  bool? _status;
  String? _message;
  dynamic _data;

  bool? get status => _status;
  String? get message => _message;
  dynamic get data => _data;

  InAppValidateResponse({bool? status, String? message, dynamic data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  InAppValidateResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['data'] = _data;
    return map;
  }
}
