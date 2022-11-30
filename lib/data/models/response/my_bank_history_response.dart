class MyBankHistoryResponse {
  String? message;
  bool? status;
  List<DataListBean>? data;

  MyBankHistoryResponse({this.message, this.status, this.data});

  MyBankHistoryResponse.fromJson(Map<String, dynamic> json) {
    this.message = json['message'];
    this.status = json['status'];
    this.data = (json['data'] as List?) != null
        ? (json['data'] as List).map((i) => DataListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['data'] =
        this.data != null ? this.data!.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class DataListBean {
  String? id;
  String? courseId;
  String? course;
  String? plans;
  String? depositerName;
  String? depositedAccountNumer;
  String? subscriptionId;
  String? bankBranch;
  String? depositedDate;
  String? depositedAmount;
  String? mobileNumber;
  String? image;
  String? depositedType;
  String? userId;
  String? username;
  String? bankName;
  String? accountName;
  String? status;

  DataListBean(
      {this.id,
      this.courseId,
      this.course,
      this.plans,
      this.depositerName,
      this.depositedAccountNumer,
      this.subscriptionId,
      this.bankBranch,
      this.depositedDate,
      this.depositedAmount,
      this.mobileNumber,
      this.image,
      this.depositedType,
      this.userId,
      this.username,
      this.bankName,
      this.accountName,
      this.status});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.courseId = json['course_id'];
    this.course = json['course'];
    this.plans = json['plans'];
    this.depositerName = json['depositer_name'];
    this.depositedAccountNumer = json['deposited_account_numer'];
    this.subscriptionId = json['subscription_id'];
    this.bankBranch = json['bank_branch'];
    this.depositedDate = json['deposited_date'];
    this.depositedAmount = json['deposited_amount'];
    this.mobileNumber = json['mobile_number'];
    this.image = json['image'];
    this.depositedType = json['deposited_type'];
    this.userId = json['user_id'];
    this.username = json['username'];
    this.bankName = json['bank_name'];
    this.accountName = json['account_name'];
    this.status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['course'] = this.course;
    data['plans'] = this.plans;
    data['depositer_name'] = this.depositerName;
    data['deposited_account_numer'] = this.depositedAccountNumer;
    data['subscription_id'] = this.subscriptionId;
    data['bank_branch'] = this.bankBranch;
    data['deposited_date'] = this.depositedDate;
    data['deposited_amount'] = this.depositedAmount;
    data['mobile_number'] = this.mobileNumber;
    data['image'] = this.image;
    data['deposited_type'] = this.depositedType;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['bank_name'] = this.bankName;
    data['account_name'] = this.accountName;
    data['status'] = this.status;
    return data;
  }
}
