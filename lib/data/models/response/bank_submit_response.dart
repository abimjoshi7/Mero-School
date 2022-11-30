class BankSubmitResponse {
  String? message;
  bool? status;

  BankSubmitResponse({this.message, this.status});

  BankSubmitResponse.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];
    this.status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
