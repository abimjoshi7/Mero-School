/// auth_token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMjMxIiwiZmlyc3RfbmFtZSI6InVzZXIiLCJsYXN0X25hbWUiOiJkZW1vIiwiZW1haWwiOiJjIGMiLCJyb2xlIjoidXNlciIsInZhbGlkaXR5IjoxfQ.MnYukY0Sy9Qp3ggt2QF0BNN6Lm2t8BFQNJEF-spS_Qk"
/// query : "gold"

class SearchPlanRequest {
  String? _authToken;
  String? _query;

  String? get authToken => _authToken;
  String? get query => _query;

  SearchPlanRequest({String? authToken, String? query}) {
    _authToken = authToken;
    _query = query;
  }

  SearchPlanRequest.fromJson(dynamic json) {
    _authToken = json["auth_token"];
    _query = json["query"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["auth_token"] = _authToken;
    map["query"] = _query;
    return map;
  }
}
