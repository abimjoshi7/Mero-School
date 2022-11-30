/// auth_token : "eyj0exaioijkv1qilcjhbgcioijiuzi1nij9.eyj1c2vyx2lkijoimja3iiwizmlyc3rfbmftzsi6ik1yliisimxhc3rfbmftzsi6ik5vym9kesisimvtywlsijoibi5plnjhai5zewfuz2rlbkbnbwfpbc5jb20ilcjyb2xlijoidxnlciisinzhbglkaxr5ijoxfq.ytxn-spkyhnuuaiuoysrbses0bgzzjm_vgrt56r_f3q"
/// biography : ""
/// email : "n.i.raj.syangden@gmail.com"
/// facebook_link : ""
/// first_name : "Mr."
/// last_name : "Nobodys"
/// linkedin_link : ""
/// twitter_link : ""

class EditProfileRequest {
  String? _authToken;
  String? _biography;
  String? _email;
  String? _facebookLink;
  String? _firstName;
  String? _lastName;
  String? _linkedinLink;
  String? _twitterLink;
  String? _phoneNumber;

  String? get authToken => _authToken;
  String? get biography => _biography;
  String? get email => _email;
  String? get facebookLink => _facebookLink;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get linkedinLink => _linkedinLink;
  String? get twitterLink => _twitterLink;
  String? get phoneNumber => _phoneNumber;

  EditProfileRequest(
      {String? authToken,
      String? biography,
      String? email,
      String? facebookLink,
      String? firstName,
      String? lastName,
      String? linkedinLink,
      String? twitterLink,
      String? phoneNumber}) {
    _authToken = authToken;
    _biography = biography;
    _email = email;
    _facebookLink = facebookLink;
    _firstName = firstName;
    _lastName = lastName;
    _linkedinLink = linkedinLink;
    _twitterLink = twitterLink;
    _phoneNumber = phoneNumber;
  }

  EditProfileRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _biography = json["biography"];
    _email = json["email"];
    _facebookLink = json["facebook_link"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _linkedinLink = json["linkedin_link"];
    _twitterLink = json["twitter_link"];
    _phoneNumber = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["biography"] = _biography;
    map["email"] = _email;
    map["facebook_link"] = _facebookLink;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["linkedin_link"] = _linkedinLink;
    map["twitter_link"] = _twitterLink;
    map["phone_number"] = _phoneNumber;
    return map;
  }
}
