import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mero_school/data/models/response/edit_profile_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/data/models/request/edit_profile_request.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/data/models/response/user_image_response.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../utils/toast_helper.dart';

class EditProfileBloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();
  StreamController? _dataController;

  StreamSink<Response<EditProfileResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<EditProfileResponse>>;

  Stream<Response<EditProfileResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<EditProfileResponse>>;

  init() {
    _dataController = StreamController<Response<EditProfileResponse>>();
  }

  //add this in init() method

  //add this to dispose
  //    _dataPopupController?.close();

  updateProfile(
      String? biography,
      String? email,
      String? facebookLink,
      String? firstName,
      String? lastName,
      String? linkedinLink,
      String? twitterLink,
      String? phoneNumber) async {
    var t = await Preference.getString(token);

    var request = EditProfileRequest(
        authToken: Common.checkNullOrNot(t),
        biography: biography,
        email: email,
        facebookLink: facebookLink,
        firstName: firstName,
        lastName: lastName,
        linkedinLink: linkedinLink,
        twitterLink: twitterLink,
        phoneNumber: phoneNumber);
    try {
      if (email != null && !email.contains("@mero.school")) {
        WebEngagePlugin.setUserFirstName(firstName!);
        WebEngagePlugin.setUserLastName(lastName!);
        WebEngagePlugin.setUserPhone(phoneNumber!);
        WebEngagePlugin.setUserEmail(email);
      }

      EditProfileResponse response =
          await _myNetworkClient.updateUserData(request);
      if (response.status == true) {
        Fluttertoast.cancel();
        ToastHelper.showLong('Profile updated successfully');
      }
      if (!_dataController!.isClosed) {
        dataSink.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataController!.isClosed) {
        dataSink.add(Response.error(e.toString()));
      }

      // print(e);
    }
  }

  Future<UserImageResponse> uploadImage(File file) async {
    var t = await Preference.getString(token);

    UserImageResponse response =
        await _myNetworkClient.uploadUserImage(file, Common.checkNullOrNot(t));
    return response;
  }

  dispose() {
    _dataController!.done;
    _dataController?.close();
  }
}
