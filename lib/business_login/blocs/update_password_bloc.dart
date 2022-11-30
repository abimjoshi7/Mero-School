import 'dart:async';

import 'package:mero_school/data/models/response/update_password_response.dart';
import 'package:mero_school/data/models/request/update_password_request.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class UpdatePasswordBloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();
  StreamController _dataController =
      StreamController<Response<UpdatePasswordResponse>>();

  StreamSink<Response<UpdatePasswordResponse>> get dataSink =>
      _dataController.sink as StreamSink<Response<UpdatePasswordResponse>>;

  Stream<Response<UpdatePasswordResponse>> get dataStream =>
      _dataController.stream as Stream<Response<UpdatePasswordResponse>>;

  updatePassword(String? currentPassword, String? newPassword,
      String? confirmPassword) async {
    var t = await Preference.getString(token);
    // settingDataSink.add(Response.loading('Getting a Data!'));
    var request = UpdatePasswordRequest(
        authToken: Common.checkNullOrNot(t),
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
    try {
      UpdatePasswordResponse response =
          await _myNetworkClient.updatePassword(request);
      if (!_dataController.isClosed) {
        dataSink.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataController.isClosed) {
        dataSink.add(Response.error("Current password did not matched"));
      }

      print(e);
    }
  }

  dispose() {
    _dataController.close();
  }
}
