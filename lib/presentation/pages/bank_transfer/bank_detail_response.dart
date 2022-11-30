class BankDetailResponse {
  String? message;
  String? msg1;
  String? msg2;
  String? msg3;
  bool? status;
  List<DataListBean>? data;

  BankDetailResponse(
      {this.message, this.msg1, this.msg2, this.msg3, this.status, this.data});

  BankDetailResponse.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];
    this.msg1 = json['msg1'];
    this.msg2 = json['msg2'];
    this.msg3 = json['msg3'];
    this.status = json['status'];
    this.data = (json['data'] as List?) != null
        ? (json['data'] as List).map((i) => DataListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['msg1'] = this.msg1;
    data['msg2'] = this.msg2;
    data['msg3'] = this.msg3;
    data['status'] = this.status;
    data['data'] =
        this.data != null ? this.data!.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class DataListBean {
  String? id;
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? createdAt;
  String? status;

  DataListBean(
      {this.id,
      this.bankName,
      this.accountName,
      this.accountNumber,
      this.createdAt,
      this.status});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.bankName = json['bank_name'];
    this.accountName = json['account_name'];
    this.accountNumber = json['account_number'];
    this.createdAt = json['created_at'];
    this.status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_name'] = this.bankName;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
