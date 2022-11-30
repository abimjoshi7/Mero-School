/// status : true
/// message : "user data"
/// data : {"user_id":"14872","id":"14872","first_name":"9823225046","last_name":"","email":"9823225046@mero.school","facebook":"","twitter":"","linkedin":"","biography":null,"provider":"","login_via ":"You are logged in via :  Phone Number","image":"https://demo.mero.school/uploads/user_image/placeholder.png"}

class UserDataResponse {
  UserDataResponse({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserDataResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
// affiliate_status: non-affiliate,
//  affiliate_message: "you ahee",
/// user_id : "14872"
/// id : "14872"
/// first_name : "9823225046"
/// last_name : ""
/// email : "9823225046@mero.school"
/// facebook : ""
/// twitter : ""
/// linkedin : ""
/// biography : null
/// provider : ""
/// login_via  : "You are logged in via :  Phone Number"
/// image : "https://demo.mero.school/uploads/user_image/placeholder.png"

class Data {
  Data(
      {String? affiliateStatus,
      String? affiliateMessage,
      String? userId,
      String? id,
      String? firstName,
      String? lastName,
      String? email,
      String? facebook,
      String? twitter,
      String? linkedin,
      dynamic biography,
      String? provider,
      String? loginVia,
      String? image,
      String? phoneNumber,
      String? profileCompletedStatus}) {
    _affiliateStatus = affiliateStatus;
    _affiliateMessage = affiliateMessage;
    _userId = userId;
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _facebook = facebook;
    _twitter = twitter;
    _linkedin = linkedin;
    _biography = biography;
    _provider = provider;
    _loginVia = loginVia;
    _phoneNumber = phoneNumber;
    _image = image;
    _profileCompletedStatus = profileCompletedStatus;
  }

  Data.fromJson(dynamic json) {
    _affiliateStatus = json['affiliate_status'];
    _affiliateMessage = json['affiliate_message'];
    _userId = json['user_id'];
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _facebook = json['facebook'];
    _twitter = json['twitter'];
    _linkedin = json['linkedin'];
    _biography = json['biography'];
    _provider = json['provider'];
    _loginVia = json['login_via '];
    _image = json['image'];
    _phoneNumber = json['phone_number'];
    _profileCompletedStatus = json['profile_completed_status'];
  }
  String? _affiliateStatus;
  String? _affiliateMessage;
  String? _userId;
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _facebook;
  String? _twitter;
  String? _linkedin;
  dynamic _biography;
  String? _provider;
  String? _loginVia;
  String? _image;
  String? _phoneNumber;
  String? _profileCompletedStatus;

  String? get affiliateStatus => _affiliateStatus;
  String? get affiliateMessage => _affiliateMessage;
  String? get userId => _userId;
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get facebook => _facebook;
  String? get twitter => _twitter;
  String? get linkedin => _linkedin;
  dynamic get biography => _biography;
  String? get provider => _provider;
  String? get loginVia => _loginVia;
  String? get image => _image;
  String? get phoneNumber => _phoneNumber;
  String? get profileCompletedStatus => _profileCompletedStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['affiliate_status'] = _affiliateStatus;
    map['affiliate_message'] = _affiliateMessage;
    map['user_id'] = _userId;
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['facebook'] = _facebook;
    map['twitter'] = _twitter;
    map['linkedin'] = _linkedin;
    map['biography'] = _biography;
    map['provider'] = _provider;
    map['login_via '] = _loginVia;
    map['image'] = _image;
    map['phone_number'] = _phoneNumber;
    map['profile_completed_status'] = _profileCompletedStatus;
    return map;
  }
}
