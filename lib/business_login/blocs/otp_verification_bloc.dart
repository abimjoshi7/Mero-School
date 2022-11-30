import 'dart:async';
import 'dart:convert';

import 'package:mero_school/data/models/request/otp_verification_request.dart';
import 'package:mero_school/data/models/response/login_response.dart';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
// import 'package:sms_retriever/sms_retriever.dart';

class OTPVerificationBloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();
  StreamController _dataController =
      StreamController<Response<LoginResponse>>();
  StreamController _otpController = StreamController<String>();

  StreamSink<String> get otpSink => _otpController.sink as StreamSink<String>;

  Stream<String> get otpStream => _otpController.stream as Stream<String>;

  StreamSink<Response<LoginResponse>> get dataSink =>
      _dataController.sink as StreamSink<Response<LoginResponse>>;

  Stream<Response<LoginResponse>> get dataStream =>
      _dataController.stream as Stream<Response<LoginResponse>>;

  oTPVerification(String? phoneNumber, String? otpCode) async {
    var request =
        OtpVerificationRequest(otpNum: otpCode, phoneNUm: phoneNumber);
    try {
      LoginResponse response =
          await _myNetworkClient.fetchOTPVerification(request);
      if (!_dataController.isClosed) {
        dataSink.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataController.isClosed) {
        print("here is the issue");

        ErrResponse res = ErrResponse.fromJson(jsonDecode(e.toString()));
        var msg = res.message;
        dataSink.add(Response.error((null != msg) ? msg : e.toString()));
      }

      print(e);
    }
  }

  getCode(String sms) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    final code = intRegex.allMatches(sms).first.group(0);
    return code;
    return '';
  }

  optHashKey() async {
    // String  signature = await SmsRetriever.getAppSignature();
    // print("Signature: $signature");
  }

  optStartListening() async {
    // Future.delayed(Duration(seconds: 3),(){
    //     otpSink.add("1243");
    //
    // });
    //

    // String smsCode = await SmsRetriever.startListening();
    // String code = getCode(smsCode);
    //
    // print("smscode: $code");
    //
    // if(code.isNotEmpty){
    //   otpSink.add(code);
    // }
  }

  dispose() {
    // SmsRetriever.stopListening();
    _otpController.close();
    _dataController.close();
  }
}
