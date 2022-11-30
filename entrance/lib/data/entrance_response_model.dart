import 'package:entrance/data/model.dart';

class EntranceModelResponse extends Model {
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  EntranceModelResponse({bool? status, String? message, List<Data>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  @override
  EntranceModelResponse fromJson(dynamic json) {
    print("$json");

    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Data({String? id, String? name}) {
    _id = id;
    _name = name;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;

    map["name"] = _name;

    return map;
  }
}
