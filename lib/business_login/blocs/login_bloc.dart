import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mero_school/business_login/blocs/base_bloc.dart';
import 'package:mero_school/data/models/request/login_request.dart';
import 'package:mero_school/data/models/request/social_login_request.dart';
import 'package:mero_school/data/models/response/login_response.dart';
import 'package:mero_school/data/models/response/logout_response.dart';
import 'package:mero_school/data/models/response/social_login_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../data/models/response/affiliate_response.dart';

class LoginBloc extends BaseBloc {
  MyNetworkClient _myNetworkClient = MyNetworkClient();
  StreamController _dataController =
      StreamController<Response<LoginResponse>>.broadcast();

  StreamSink<Response<LoginResponse>> get settingDataSink =>
      _dataController.sink as StreamSink<Response<LoginResponse>>;

  Stream<Response<LoginResponse>> get settingDataStream =>
      _dataController.stream as Stream<Response<LoginResponse>>;

  // Future<bool> isShow;

  fetchLogin(String phoneNumber, String? password,
      [String? firstName, String? lastName, String? email]) async {
    var loginRequest = LoginRequest(
        phoneNumber: phoneNumber,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email);

    // isShow  = delay(true);

    // print("login mthod called");
    var t = await Preference.getString(fcm_token);

    var fcm = Common.checkNullOrNot(t);

    loginRequest.fcmToken = fcm;

    String? msg = "";

    try {
      LoginResponse response =
          await _myNetworkClient.fetchLoginResponse(loginRequest);

      if ((response.data != null &&
              response.data!.token != null &&
              response.data!.validity == 1) ||
          (response.data != null &&
              response.data!.token != null &&
              response.data!.validity == 4)) {
        try {
          print("userId: $phoneNumber");
          WebEngagePlugin.userLogin(response.data!.userId!);
          WebEngagePlugin.setUserPhone(phoneNumber);
          WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD, "phone");
          WebEngagePlugin.setUserAttribute(
              TAG_USER_LOGIN_METHOD_ID, phoneNumber);

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
        } catch (e) {
          print(e);
        }

        saveDataWIthOutContext(response);
        // saveDataWIthOutContext(response);

        settingDataSink.add(Response.completed(response));
      } else {
        msg = response.message;
        settingDataSink.add(Response.error(
            (msg != null && msg.isNotEmpty) ? msg : "Login Failed"));
      }
    } catch (e) {
      print("e ${e.toString()})");

      ErrResponse res = ErrResponse.fromJson(jsonDecode(e.toString()));
      msg = res.message;

      if (!_dataController.isClosed) {
        settingDataSink.add(Response.error(
            (msg != null && msg.isNotEmpty) ? msg : "Login Failed"));
      }

      print(e);
    }
  }

  // fetchAffiliateLogin(
  //   String firstName,
  //   String lastName,
  //   String email,
  //   String phoneNumber,
  //   String? password,
  // ) async {
  //   var affiliateRequest = AffiliateRequest(
  //     firstName: firstName,
  //     lastName: lastName,
  //     phoneNumber: phoneNumber,
  //     password: password,
  //   );
  //
  //   // isShow  = delay(true);
  //
  //   // print("login mthod called");
  //   var t = await Preference.getString(fcm_token);
  //
  //   var fcm = Common.checkNullOrNot(t);
  //
  //   affiliateRequest.fcmToken = fcm;
  //
  //   String? msg = "";
  //
  //   try {
  //     AffiliateResponse response =
  //         await _myNetworkClient.fetchAffiliateResponse(AffiliateRequest);
  //
  //     if ((response.data != null && response.data!.authToken != null) ||
  //         (response.data != null && response.data!.authToken != null)) {
  //       try {
  //         print("userId: $phoneNumber");
  //         WebEngagePlugin.userLogin(response.data!.userId!);
  //         WebEngagePlugin.setUserPhone(phoneNumber);
  //
  //         WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD, "phone");
  //         WebEngagePlugin.setUserAttribute(
  //             TAG_USER_LOGIN_METHOD_ID, phoneNumber);
  //
  //         if (response.data!.email != null &&
  //             !response.data!.email!.contains("@mero.school")) {
  //           WebEngagePlugin.setUserEmail(response.data!.email!);
  //         }
  //
  //         if (response.data!.firstName!.isNotEmpty) {
  //           WebEngagePlugin.setUserFirstName(response.data!.firstName!);
  //         }
  //
  //         if (response.data!.lastName!.isNotEmpty) {
  //           WebEngagePlugin.setUserLastName(response.data!.lastName!);
  //         }
  //       } catch (e) {
  //         print(e);
  //       }
  //
  //       saveDataWIthOutContext(response);
  //       // saveDataWIthOutContext(response);
  //
  //       settingDataSink.add(Response.completed(response));
  //     } else {
  //       msg = response.message;
  //       settingDataSink.add(Response.error(
  //           (msg != null && msg.isNotEmpty) ? msg : "Login Failed"));
  //     }
  //   } catch (e) {
  //     print("e ${e.toString()})");
  //
  //     ErrResponse res = ErrResponse.fromJson(jsonDecode(e.toString()));
  //     msg = res.message;
  //
  //     if (!_dataController.isClosed) {
  //       settingDataSink.add(Response.error(
  //           (msg != null && msg.isNotEmpty) ? msg : "Login Failed"));
  //     }
  //
  //     print(e);
  //   }
  // }

  dispose() {
    _dataController.close();
    _dataControllerSocial.close();
    _dataControllerAffiliate.close();
  }

  void saveDataWIthOutContext(LoginResponse data) {
    var model = data.data!;

    if (model.token!.isNotEmpty) {
      // print("save=== token!Context" + model.token);

      Preference.setString(user_token, model.token);
      Preference.setString(token, model.token);
      Preference.setString(user_id, model.userId);
      Preference.setString(first_name, model.firstName);
      Preference.setString(last_name, model.lastName);
      Preference.setString(user_email, model.email);
      Preference.setString(phone_number, model.phoneNumber);
      Preference.setString(role, model.role);
      Preference.setInt(validity, model.validity!);
      // print("save=== token2" + model.token);
    }
  }

  void saveData(LoginResponse data, BuildContext context) {
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

  // StreamController _dataControllerAffiliate =
  //     BehaviorSubject<Response<AffiliateResponse>>();
  //
  // StreamSink<Response<AffiliateResponse>> get settingDataSinkAffiliate =>
  //     _dataControllerAffiliate.sink as StreamSink<Response<AffiliateResponse>>;
  //
  // Stream<Response<AffiliateResponse>> get settingDataStreamSocial =>
  //     _dataControllerAffiliate.stream as Stream<Response<AffiliateResponse>>;
  //
  // fetchAffiliateLogin(String? firstName, String? lastName, String? email,
  //     String? phoneNumber, String? id) async {
  //   // settingDataSink.add(Response.loading('Getting a Data!'));
  //
  //   var t = await Preference.getString(fcm_token);
  //   var fcm = Common.checkNullOrNot(t);
  //
  //   var request = AffiliationRequest(
  //     firstName: firstName,
  //     lastName: lastName,
  //     email: email,
  //     fcmToken: fcm,
  //   );
  //
  //   try {
  //     AffiliateResponse response =
  //         await _myNetworkClient.fetchAffiliateRegistration(request);
  //
  //     WebEngagePlugin.userLogin(response.data!.userId!);
  //
  //     if (response.data!.email != null &&
  //         !response.data!.email!.contains("@mero.school")) {
  //       WebEngagePlugin.setUserEmail(response.data!.email!);
  //     }
  //
  //     WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD, provider);
  //     WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD_ID, id);
  //
  //     if (response.data!.firstName!.isNotEmpty) {
  //       WebEngagePlugin.setUserFirstName(response.data!.firstName!);
  //     }
  //
  //     if (response.data!.lastName!.isNotEmpty) {
  //       WebEngagePlugin.setUserLastName(response.data!.lastName!);
  //     }
  //
  //     // print("isFirstLogin: ${response.data.isFirstLogin}");
  //     if (response.data!.isFirstLogin != null && response.data!.isFirstLogin!) {
  //       WebEngagePlugin.trackEvent(TAG_SIGN_UP, <String, String>{
  //         'Sign Up Method': provider,
  //         'Sign Up Mode': 'app'
  //       });
  //     }
  //
  //     settingDataSinkSocial.add(Response.completed(response));
  //   } catch (e) {
  //     if (!_dataControllerSocial.isClosed) {
  //       settingDataSinkSocial.add(Response.error(e.toString()));
  //     }
  //
  //     print(e);
  //   }
  // }

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

  //affiliate login
  StreamController _dataControllerAffiliate =
      BehaviorSubject<Response<AffiliateResponse>>();

  StreamSink<Response<AffiliateResponse>> get settingDataSinkAffiliate =>
      _dataControllerAffiliate.sink as StreamSink<Response<AffiliateResponse>>;

  Stream<Response<AffiliateResponse>> get settingDataStreamAffiliate =>
      _dataControllerAffiliate.stream as Stream<Response<AffiliateResponse>>;

  // fetchAffiliateLogin(
  //   String? firstName,
  //   String? email,
  //   String? lastName,
  //   String? phoneNumber,
  //   String? youtube,
  //   String? website,
  //   String? promoteReason,
  //   String? password,
  //   String? id,
  //   String? provider,
  //   String? userFrom,
  //   String? authToken,
  // ) async {
  //   var request = AffiliateRequest(
  //     firstName: firstName,
  //     lastName: lastName,
  //     email: email,
  //     phoneNumber: phoneNumber,
  //     youtubeChannel: youtube,
  //     website: website,
  //     promoteReason: promoteReason,
  //     password: password,
  //     confirmPassword: password,
  //     authToken: authToken,
  //     // id: id,
  //     // provider: provider,
  //     userFrom: userFrom,
  //   );
  //
  //   try {
  //     AffiliateResponse response =
  //         await _myNetworkClient.affiliateLogin(request);
  //
  //     WebEngagePlugin.userLogin(response.data!.id!);
  //
  //     if (response.data!.email != null &&
  //         !response.data!.email!.contains("@mero.school")) {
  //       WebEngagePlugin.setUserEmail(response.data!.email!);
  //     }
  //
  //     WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD, provider);
  //     WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD_ID, id);
  //
  //     if (response.data!.firstName!.isNotEmpty) {
  //       WebEngagePlugin.setUserFirstName(response.data!.firstName!);
  //     }
  //
  //     if (response.data!.lastName!.isNotEmpty) {
  //       WebEngagePlugin.setUserLastName(response.data!.lastName!);
  //     }
  //
  //     // print("isFirstLogin: ${response.data.isFirstLogin}");
  //     // if (response.data!.isFirstLogin != null && response.data!.isFirstLogin!) {
  //     //   WebEngagePlugin.trackEvent(TAG_SIGN_UP, <String, String>{
  //     //     'Sign Up Method': provider,
  //     //     'Sign Up Mode': 'app'
  //     //   });
  //     // }
  //
  //     settingDataSinkAffiliate.add(Response.completed(response));
  //   } catch (e) {
  //     if (!_dataControllerAffiliate.isClosed) {
  //       settingDataSinkAffiliate.add(
  //         Response.error(
  //           e.toString(),
  //         ),
  //       );
  //     }
  //     print(e);
  //   }
  // }

  //social Login
  StreamController _dataControllerSocial =
      BehaviorSubject<Response<SocialLoginResponse>>();

  StreamSink<Response<SocialLoginResponse>> get settingDataSinkSocial =>
      _dataControllerSocial.sink as StreamSink<Response<SocialLoginResponse>>;

  Stream<Response<SocialLoginResponse>> get settingDataStreamSocial =>
      _dataControllerSocial.stream as Stream<Response<SocialLoginResponse>>;

  fetchSocialLogin(String? displayName, String? email, String? familyName,
      String? id, String provider) async {
    // settingDataSink.add(Response.loading('Getting a Data!'));

    var t = await Preference.getString(fcm_token);
    var fcm = Common.checkNullOrNot(t);

    var request = SocialLoginRequest(
      displayName: displayName,
      email: email,
      familyName: familyName,
      fcmToken: fcm,
      id: id,
      provider: provider,
    );

    try {
      SocialLoginResponse response =
          await _myNetworkClient.socialLogin(request);

      WebEngagePlugin.userLogin(response.data!.userId!);

      if (response.data!.email != null &&
          !response.data!.email!.contains("@mero.school")) {
        WebEngagePlugin.setUserEmail(response.data!.email!);
      }

      WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD, provider);
      WebEngagePlugin.setUserAttribute(TAG_USER_LOGIN_METHOD_ID, id);

      if (response.data!.firstName!.isNotEmpty) {
        WebEngagePlugin.setUserFirstName(response.data!.firstName!);
      }

      if (response.data!.lastName!.isNotEmpty) {
        WebEngagePlugin.setUserLastName(response.data!.lastName!);
      }

      // print("isFirstLogin: ${response.data.isFirstLogin}");
      if (response.data!.isFirstLogin != null && response.data!.isFirstLogin!) {
        WebEngagePlugin.trackEvent(TAG_SIGN_UP, <String, String>{
          'Sign Up Method': provider,
          'Sign Up Mode': 'app'
        });
      }

      settingDataSinkSocial.add(Response.completed(response));
    } catch (e) {
      if (!_dataControllerSocial.isClosed) {
        settingDataSinkSocial.add(Response.error(e.toString()));
      }

      print(e);
    }
  }

  fetchLogout(String id) async {
    try {
      LogoutResponse response =
          await _myNetworkClient.fetchLogoutEveryWhere(id);

      print(response.status.toString() + " " + response.message!);

      if (!_dataController.isClosed) {
        WebEngagePlugin.userLogout();

        settingDataSink.add(Response.success(response.message));
      }
    } catch (e) {
      var msg = "Logout Failed";

      if (!_dataController.isClosed) {
        settingDataSink.add(Response.error("Logout Failed"));
      }

      print(e);
    }
  }
}
