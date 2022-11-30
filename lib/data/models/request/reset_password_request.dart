/// phone_number : "9823225046"

class ResetPasswordRequest {
  String? _phoneNumber;

  String? get phoneNumber => _phoneNumber;

  ResetPasswordRequest({String? phoneNumber}) {
    _phoneNumber = phoneNumber;
  }

  ResetPasswordRequest.fromJson(dynamic json) {
    _phoneNumber = json["phone_number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["phone_number"] = _phoneNumber;
    return map;
  }
}
