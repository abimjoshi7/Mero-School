import 'dart:async';

import 'package:mero_school/data/models/request/reset_password_request.dart';
import 'package:mero_school/data/models/response/reset_passwod_response.dart';
import 'package:mero_school/data/models/response/reset_response.dart';

import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/data/models/request/reset_request.dart';

class ChangePasswordBloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();
  StreamController _dataController =
      StreamController<Response<ResetPasswodResponse>>.broadcast();

  StreamSink<Response<ResetPasswodResponse>> get dataSink =>
      _dataController.sink as StreamSink<Response<ResetPasswodResponse>>;

  Stream<Response<ResetPasswodResponse>> get dataStream =>
      _dataController.stream as Stream<Response<ResetPasswodResponse>>;

  //reset api
  StreamController _dataControllerReset =
      StreamController<Response<ResetResponse>>.broadcast();

  StreamSink<Response<ResetResponse>> get dataSinkReset =>
      _dataControllerReset.sink as StreamSink<Response<ResetResponse>>;

  Stream<Response<ResetResponse>> get dataStreamReset =>
      _dataControllerReset.stream as Stream<Response<ResetResponse>>;

  changePassword(String? phoneNumber) async {
    var request = ResetPasswordRequest(phoneNumber: phoneNumber);
    try {
      ResetPasswodResponse response =
          await _myNetworkClient.fetchResetPassword(request);
      if (!_dataController.isClosed) {
        dataSink.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataController.isClosed) {
        dataSink.add(Response.error(e.toString()));
      }

      //print(e);
    }
  }

  reset(String? phoneNumber, String? password, String? otpNumber) async {
    var request = ResetRequest(
        password: password, confirmPassword: password, otpNum: otpNumber);
    try {
      ResetResponse response =
          await _myNetworkClient.fetchReset(request, phoneNumber);
      if (!_dataControllerReset.isClosed) {
        dataSinkReset.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataControllerReset.isClosed) {
        dataSinkReset.add(Response.error(e.toString()));
      }

      //print(e);
    }
  }

  dispose() {
    _dataController.close();
    _dataControllerReset.close();
  }
}
