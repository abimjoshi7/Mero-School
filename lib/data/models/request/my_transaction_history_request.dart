/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjA3IiwiZmlyc3RfbmFtZSI6Ik1yLiIsImxhc3RfbmFtZSI6Ik5vYm9keSIsImVtYWlsIjoibi5pLnJhai5zeWFuZ2RlbkBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.YTXN-sPkyHnUUaiUOysrBsEs0bGzZJM_vGrt56r_F3Q"

class GeneralTokenRequest {
  String? _authToken;

  String? get authToken => _authToken;

  GeneralTokenRequest({String? authToken}) {
    _authToken = authToken;
  }

  GeneralTokenRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    return map;
  }
}
