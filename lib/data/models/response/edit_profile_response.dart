/// status : true
/// message : "Profile Updated!!"
/// data : {"id":"207","first_name":"Mr.","last_name":"Nobodys","email":"n.i.raj.syangden@gmail.com","facebook":"","twitter":"","linkedin":"","biography":"","provider":"","image":"http://mero.school/uploads/user_image/207.jpg","status":"success","error_reason":"None"}

class EditProfileResponse {
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  EditProfileResponse({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  EditProfileResponse.fromJson(dynamic json) {
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

/// id : "207"
/// first_name : "Mr."
/// last_name : "Nobodys"
/// email : "n.i.raj.syangden@gmail.com"
/// facebook : ""
/// twitter : ""
/// linkedin : ""
/// biography : ""
/// provider : ""
/// image : "http://mero.school/uploads/user_image/207.jpg"
/// status : "success"
/// error_reason : "None"

class Data {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _facebook;
  String? _twitter;
  String? _linkedin;
  String? _biography;
  String? _provider;
  String? _image;
  String? _status;
  String? _errorReason;
  bool? _isProfileCompleted;

  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get facebook => _facebook;
  String? get twitter => _twitter;
  String? get linkedin => _linkedin;
  String? get biography => _biography;
  String? get provider => _provider;
  String? get image => _image;
  String? get status => _status;
  String? get errorReason => _errorReason;
  bool? get isProfileCompleted => _isProfileCompleted;

  Data(
      {String? id,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? facebook,
      String? twitter,
      String? linkedin,
      String? biography,
      String? provider,
      String? image,
      String? status,
      String? errorReason,
      bool? isProfileCompleted}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _facebook = facebook;
    _twitter = twitter;
    _linkedin = linkedin;
    _biography = biography;
    _provider = provider;
    _image = image;
    _status = status;
    _errorReason = errorReason;
    _isProfileCompleted = isProfileCompleted;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _email = json["email"];
    _phoneNumber = json["phone_number"];
    _facebook = json["facebook"];
    _twitter = json["twitter"];
    _linkedin = json["linkedin"];
    _biography = json["biography"];
    _provider = json["provider"];
    _image = json["image"];
    _status = json["status"];
    _errorReason = json["error_reason"];
    _isProfileCompleted = json["is_profile_completed"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["email"] = _email;
    map["phone_number"] = _phoneNumber;
    map["facebook"] = _facebook;
    map["twitter"] = _twitter;
    map["linkedin"] = _linkedin;
    map["biography"] = _biography;
    map["provider"] = _provider;
    map["image"] = _image;
    map["status"] = _status;
    map["error_reason"] = _errorReason;
    map["is_profile_completed"] = _isProfileCompleted;
    return map;
  }
}
