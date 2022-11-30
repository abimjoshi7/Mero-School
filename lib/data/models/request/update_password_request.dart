/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTcwIiwiZmlyc3RfbmFtZSI6Ik1yLiAiLCJsYXN0X25hbWUiOiJHcnUiLCJlbWFpbCI6Im5pci5hai5zeWFuZ2RlbkBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.jOHJFccqqCGigFiBw_Z5uzp8AKYdN0OYDatTGH_NvrQ"
/// confirm_password : "123456"
/// current_password : "123456"
/// new_password : "123456"

class UpdatePasswordRequest {
  String? _authToken;
  String? _confirmPassword;
  String? _currentPassword;
  String? _newPassword;

  String? get authToken => _authToken;
  String? get confirmPassword => _confirmPassword;
  String? get currentPassword => _currentPassword;
  String? get newPassword => _newPassword;

  UpdatePasswordRequest(
      {String? authToken,
      String? confirmPassword,
      String? currentPassword,
      String? newPassword}) {
    _authToken = authToken;
    _confirmPassword = confirmPassword;
    _currentPassword = currentPassword;
    _newPassword = newPassword;
  }

  UpdatePasswordRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _confirmPassword = json["confirm_password"];
    _currentPassword = json["current_password"];
    _newPassword = json["new_password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["confirm_password"] = _confirmPassword;
    map["current_password"] = _currentPassword;
    map["new_password"] = _newPassword;
    return map;
  }
}
