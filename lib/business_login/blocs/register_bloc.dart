import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/data/models/request/registration_request.dart';
import 'package:mero_school/data/models/request/social_login_request.dart';
import 'package:mero_school/data/models/response/registration_response.dart';
import 'package:mero_school/data/models/response/social_login_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class RegisterBloc extends BaseBloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();
  StreamController _dataController =
      StreamController<Response<RegistrationResponse>>();

  StreamSink<Response<RegistrationResponse>> get dataSink =>
      _dataController.sink as StreamSink<Response<RegistrationResponse>>;

  Stream<Response<RegistrationResponse>> get dataStream =>
      _dataController.stream as Stream<Response<RegistrationResponse>>;

  //social Login
  StreamController _dataControllerSocial =
      BehaviorSubject<Response<SocialLoginResponse>>();

  StreamSink<Response<SocialLoginResponse>> get settingDataSinkSocial =>
      _dataControllerSocial.sink as StreamSink<Response<SocialLoginResponse>>;

  Stream<Response<SocialLoginResponse>> get settingDataStreamSocial =>
      _dataControllerSocial.stream as Stream<Response<SocialLoginResponse>>;

  updatePassword(String? phoneNumber, String? password) async {
    var request = RegistrationRequest(
        confirmPassword: password,
        password: password,
        phoneNumber: phoneNumber,
        fcmToken: empty);
    try {
      RegistrationResponse response =
          await _myNetworkClient.fetchRegistration(request);
      if (!_dataController.isClosed) {
        dataSink.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataController.isClosed) {
        dataSink.add(Response.error(e.toString()));
      }

      print(e);
    }
  }

  // registerAffiliate(
  //     String? firstName,
  //     String? lastName,
  //     String? email,
  //     String? phoneNumber,
  //     String? youtubeChannel,
  //     String? website,
  //     String? promoteReason,
  //     String? password,
  //     String? userFrom,
  //     String? fcmToken) async {
  //   var request = AffiliationRequest(
  //       firstName: firstName,
  //       lastName: lastName,
  //       email: email,
  //       phoneNumber: phoneNumber,
  //       youtubeChannel: youtubeChannel,
  //       website: website,
  //       promoteReason: promoteReason ,
  //       password: password,
  //       confirmPassword: password,
  //       userFrom: "app",
  //       fcmToken: DateTime.now.toString());
  //   try {
  //     RegistrationResponse response =
  //         await _myNetworkClient.fetchRegistration(request);
  //     if (!_dataController.isClosed) {
  //       dataSink.add(Response.completed(response));
  //     }
  //   } catch (e) {
  //     if (!_dataController.isClosed) {
  //       dataSink.add(Response.error(e.toString()));
  //     }

  //     print(e);
  //   }
  // }

  dispose() {
    _dataControllerSocial.close();
    _dataController.close();
  }

  void saveDataSocial(SocialLoginResponse data, BuildContext context) {
    var model = data.data!;
    // var pref =  Preference.prefs;
    if (model.token!.isNotEmpty) {
      // print("save=== token" + model.token);

      Preference.setString(token, model.token);
      Preference.setString(user_token, model.token);
      Preference.setString(user_id, model.userId);
      Preference.setString(first_name, model.firstName);
      Preference.setString(last_name, model.lastName);
      Preference.setString(user_email, model.email);
      Preference.setString(phone_number, model.phoneNumber);
      Preference.setString(role, model.role);
      Preference.setInt(validity, model.validity!);
    }

    // print("=====saved-----------");
    // await Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
  }

  fetchSocialLogin(String? displayName, String? email, String? familyName,
      String? id, String provider, String? phoneNumber) async {
    // settingDataSink.add(Response.loading('Getting a Data!'));
    var request = SocialLoginRequest(
        displayName: displayName,
        email: email,
        familyName: familyName,
        phoneNumber: phoneNumber,
        fcmToken: empty,
        id: id,
        provider: provider,
        page: "register");
    try {
      SocialLoginResponse response =
          await _myNetworkClient.socialLogin(request);
      if (!_dataControllerSocial.isClosed) {
        WebEngagePlugin.userLogin(response.data!.userId!);

        WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD, provider);
        WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD_ID, id);

        if (response.data!.email != null &&
            !response.data!.email!.contains("@mero.school")) {
          WebEngagePlugin.setUserEmail(response.data!.email!);
        }

        if (response.data!.firstName!.isNotEmpty) {
          WebEngagePlugin.setUserFirstName(response.data!.firstName!);
        }

        if (response.data!.lastName!.isNotEmpty) {
          WebEngagePlugin.setUserLastName(response.data!.lastName!);
        }

        if (response.data!.isFirstLogin != null &&
            response.data!.isFirstLogin!) {
          WebEngagePlugin.trackEvent(TAG_SIGN_UP, <String, String>{
            'Sign Up Method': provider,
            'Sign Up Mode': 'app'
          });
        }

        settingDataSinkSocial.add(Response.completed(response));
      }
    } catch (e) {
      if (!_dataControllerSocial.isClosed) {
        settingDataSinkSocial.add(Response.error(e.toString()));
      }

      print(e);
    }
  }

  // fetchLogout(String id) async {
  //   try {
  //     LogoutResponse response = await _myNetworkClient.fetchLogoutEveryWhere(
  //         id);
  //
  //     print(response.status.toString() + " " + response.message);
  //
  //     if (!_dataController.isClosed) {
  //
  //       WebEngagePlugin.userLogout();
  //
  //       settingDataSink.add(Response.success(response.message));
  //     }
  //   } catch (e) {
  //     var msg = "Logout Failed";
  //
  //
  //     if (!_dataController.isClosed) {
  //       settingDataSink.add(Response.error("Logout Failed"));
  //     }
  //
  //     print(e);
  //   }
  // }

}
