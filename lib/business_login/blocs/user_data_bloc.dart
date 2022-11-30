import 'dart:async';

import 'package:mero_school/app_database.dart';
import 'package:mero_school/data/models/response/logout_response.dart';
import 'package:mero_school/data/models/response/user_data_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class UserDataBloc {
  late MyNetworkClient _myNetworkClient;
  StreamController? _dataController;
  late bool _isStreaming;

  StreamSink<Response<UserDataResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<UserDataResponse>>;
  Stream<Response<UserDataResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<UserDataResponse>>;

  initBloc() {
    _dataController = BehaviorSubject<Response<UserDataResponse>>();
    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    fetchData();
  }

  fetchData() async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);
      UserDataResponse response =
          await _myNetworkClient.fetchUserData(Common.checkNullOrNot(t));

      print("response: ${response.data?.toJson()}");

      if (_isStreaming) dataSink.add(Response.completed(response));
    } catch (e) {
      if (_isStreaming) dataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  void deleteData() async {
    // var pref = await Preference.load();

    // print("save=== delete data called");
    Preference.remove(affiliate_status);
    Preference.remove(affiliate_message);
    Preference.remove(user_id);
    Preference.remove(first_name);
    Preference.remove(last_name);
    Preference.remove(user_email);
    Preference.remove(role);
    Preference.remove(validity);
    Preference.remove(token);
    Preference.remove(user_token);
    Preference.remove(phone_number);
    Preference.remove(profile_completed_status);

    var db = AppDatabase.instance;
    db.delete(db.myCartModel).go();

    db.delete(db.notificationModel).go();

    // await locator<AppDatabase>().deleteAllNotificationData();

    // await Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
  }

  void saveData(UserDataResponse response) async {
    var model = response.data!;

    Preference.setString(affiliate_status, model.affiliateStatus);
    Preference.setString(affiliate_message, model.affiliateMessage);
    Preference.setString(first_name, model.firstName);
    Preference.setString(last_name, model.lastName);
    Preference.setString(user_email, model.email);
    Preference.setString(biography, model.biography);
    Preference.setString(twitter, model.twitter);
    Preference.setString(facebook, model.facebook);
    Preference.setString(linkedin, model.linkedin);
    Preference.setString(login_via, model.loginVia);
    Preference.setString(phone_number, model.phoneNumber);
    Preference.setString(
        profile_completed_status, model.profileCompletedStatus);
    if (model.image != null && model.image!.isNotEmpty) {
      Preference.setString(image_profile, model.image);
    }
    if (model.firstName!.isNotEmpty) {
      WebEngagePlugin.setUserFirstName(model.firstName!);
    }
    if (model.lastName!.isNotEmpty) {
      WebEngagePlugin.setUserLastName(model.lastName!);
    }
    if (model.email!.isNotEmpty) {
      WebEngagePlugin.setUserEmail(model.email!);
    }
    if (model.phoneNumber!.isNotEmpty) {
      WebEngagePlugin.setUserPhone(model.phoneNumber!);
    }

    if (model.firstName!.isNotEmpty &&
        model.lastName!.isNotEmpty &&
        model.email!.isNotEmpty &&
        model.phoneNumber!.isNotEmpty) {
      WebEngagePlugin.trackEvent(
        "user-update",
      );
    }

    // if(model.biography!=null && model.biography.isNotEmpty){
    //   WebEngagePlugin.setUserAttribute(TAG_USER_BIO,model.biography);
    // }
    //
    // if(model.twitter.isNotEmpty){
    //   WebEngagePlugin.setUserAttribute(TAG_USER_TWITTER_LINK,model.twitter);
    // }
    //
    // if(model.facebook.isNotEmpty){
    //   WebEngagePlugin.setUserAttribute(TAG_USER_FACEBOOK_LINK,model.facebook);
    // }
    //
    // if(model.linkedin.isNotEmpty){
    //   WebEngagePlugin.setUserAttribute(TAG_USER_LINKEDIN_LINK, model.linkedin);
    // }
  }

  fetchLogoutSingle(String id) async {
    try {
      LogoutResponse response = await _myNetworkClient.fetchLogout(id);

      print(response.status.toString() + " " + response.message!);

      if (!_dataController!.isClosed) {
        dataSink.add(Response.logout(response.message));
      }
    } catch (e) {
      var msg = "Logout Failed";

      if (!_dataController!.isClosed) {
        dataSink.add(Response.error("Logout Failed"));
      }

      print(e);
    }
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
  }
}
