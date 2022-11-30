import 'dart:developer';

class CertificateStatusResponse {
  final bool? certificateStatus;
  final bool? status;
  final String? title;
  final String? userName;

  CertificateStatusResponse(
      {this.certificateStatus, this.status, this.title, this.userName});

  static CertificateStatusResponse fromJson(Map<String, dynamic> json) {
    log(json['certificateStatus'].toString(), level: 2);
    return CertificateStatusResponse(
      certificateStatus: json['certificateStatus'],
      status: json['status'],
      title: json['title'],
      userName: json['user_name'],
    );
  }
}
