import 'dart:async';
import 'dart:convert';

import 'package:mero_school/data/models/response/plan_category_response.dart';
import 'package:mero_school/data/models/response/system_settings_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBloc {
  bool? _isStreaming;
  late MyNetworkClient _myNetworkClient;
  StreamController? _systemSettingsDataController;

  StreamSink<Response<SystemSettingsResponse>> get settingDataSink =>
      _systemSettingsDataController!.sink
          as StreamSink<Response<SystemSettingsResponse>>;

  Stream<Response<SystemSettingsResponse>> get settingDataStream =>
      _systemSettingsDataController!.stream
          as Stream<Response<SystemSettingsResponse>>;

  StreamController? _selectedPlanCategoryDataController;

  StreamSink<CategoryData> get selectedPlanCategoryDataSink =>
      _selectedPlanCategoryDataController!.sink as StreamSink<CategoryData>;

  Stream<CategoryData> get selectedPlanCategoryDataStream =>
      _selectedPlanCategoryDataController!.stream as Stream<CategoryData>;

  StreamController? _selectedPackageCategoryDataController;

  StreamSink<CategoryData> get selectedPakageCategoryDataSink =>
      _selectedPackageCategoryDataController!.sink as StreamSink<CategoryData>;

  Stream<CategoryData> get selectedPackageCategoryDataStream =>
      _selectedPackageCategoryDataController!.stream as Stream<CategoryData>;

  StreamController? _planCategoryDataController;

  StreamSink<Response<PlanCategoryResponse>> get planCategoryDataSink =>
      _planCategoryDataController!.sink
          as StreamSink<Response<PlanCategoryResponse>>;

  Stream<Response<PlanCategoryResponse>> get planCategoryDataStream =>
      _planCategoryDataController!.stream
          as Stream<Response<PlanCategoryResponse>>;

  systemSettingsBloc() {
    _systemSettingsDataController =
        StreamController<Response<SystemSettingsResponse>>();

    _planCategoryDataController =
        StreamController<Response<PlanCategoryResponse>>();

    _selectedPlanCategoryDataController = StreamController<CategoryData>();

    _selectedPackageCategoryDataController = StreamController<CategoryData>();

    _myNetworkClient = MyNetworkClient();
    _isStreaming = true;
    // fetchSystemSettings();
  }

  updateSystemSetting(SystemSettingsResponse? systemSettings) {
    settingDataSink.add(Response.completed(systemSettings));
  }

  fetchSystemSettings() async {
    print('Fetching system setting!!');
    settingDataSink.add(Response.loading('Getting a Data!'));
    try {
      SystemSettingsResponse systemSettings =
          await _myNetworkClient.fetchSystemSettings();

      saveData(systemSettings).then((value) {
        print("saved system preference ----");
      });
      settingDataSink.add(Response.completed(systemSettings));
    } catch (e) {
      settingDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  fetchSystemSettingSilent() async {
    var pref = await SharedPreferences.getInstance();

    if (!pref.containsKey("systemSettings")) {
      SystemSettingsResponse systemSettings =
          await _myNetworkClient.fetchSystemSettings();
      saveData(systemSettings).then((value) {});
    }
  }

  fetchSystemSettingsWithSplash() async {
    settingDataSink.add(Response.loading('Getting a Data!'));
    try {
      var pref = await SharedPreferences.getInstance();

      if (pref.containsKey("systemSettings")) {
        String? response = pref.getString("systemSettings");

        var saved = SystemSettingsResponse.fromJson(jsonDecode(response!));

        settingDataSink.add(Response.completed(saved));
      }

      SystemSettingsResponse systemSettings =
          await _myNetworkClient.fetchSystemSettings();

      saveData(systemSettings).then((value) {
        print("saved system preference ----");
      });
      settingDataSink.add(Response.completed(systemSettings));
    } catch (e) {
      // settingDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  Future<bool> saveData(SystemSettingsResponse data) async {
    var model = data.data!;

    // var pref = await Preference.load();
    print('SetPaymentMethod ${model.paymentMethod}');

    Preference.setString("systemSettings", jsonEncode(data));

    Preference.setString(language, model.language);
    Preference.setString(systemName, model.systemName);
    Preference.setString(systemTitle, model.systemTitle);
    Preference.setString(systemEmail, model.systemEmail);
    Preference.setString(address, model.address);
    Preference.setString(phone, model.phone);
    Preference.setString(phone_alternate, model.alternatePhone);
    Preference.setString(youtubeApiKey, model.youtubeApiKey);
    Preference.setString(vimeoApiKey, model.vimeoApiKey);
    Preference.setString(slogan, model.slogan);
    Preference.setString(version, model.version);
    Preference.setString(thumbnail, model.thumbnail);
    Preference.setString(favicon, model.favicon);
    Preference.setString(description, model.websiteDescription);
    Preference.setString(hidePayment, model.hidePayment);
    Preference.setString(hideSGAndroid, model.hideSmartGatewayAndriod);
    Preference.setString(hideSGIos, model.hideSmartGatewayIos);
    Preference.setString(hideBankAndroid, model.hideBankDepositPaymentAndroid);
    Preference.setString(hideBankIos, model.hideBankPaymentIos);
    Preference.setString(hideNcellIos, model.hideNcellPaymentIos);
    Preference.setString(hideNcellAndroid, model.hideNcellPaymentAndroid);
    Preference.setString(hideApplePayIos, model.iosPay);
    Preference.setString(OG_URL, model.og_url);
    Preference.setString(bypass, model.byPassCache);
    Preference.setString(payment_method, model.paymentMethod);
    Preference.setString(hideAffiliate, model.hideAffiliate);
    Preference.setString(hidePayText, model.hidePayText);
    Preference.setString(youtube, model.youtube);

    ///"hide_smart_gateway": "false",
// "hide_bank_payement": "false",
// "hide_ncell_payment_ios": "false",
// "hide_smart_gateway_andriod": "false",
// "hide_bank_deposite_payment_android": "false",
// "hide_ncell_payment_android": "false",

    //

    return true;

    // await Navigator.pushNamedAndRemoveUntil(context, home_page, (route) => false);
  }

  updatePlanCategorySetting(PlanCategoryResponse? systemSettings) {
    planCategoryDataSink.add(Response.completed(systemSettings));
  }

  fetchPlanCategorySettings() async {
    planCategoryDataSink.add(Response.loading('Getting a Data!'));
    try {
      PlanCategoryResponse systemSettings =
          await _myNetworkClient.fetchPlanSettings();

      // saveData(systemSettings).then((value) {
      //   print("saved system preference ----");
      // });

      //{
      //                   "id": "0",
      //             "label": "All"
      //             }

      String objText = '{"id": "all", "label": "All"}';

      systemSettings.planCategory
          ?.insert(0, CategoryData.fromJson(jsonDecode(objText)));
      systemSettings.packageCategory
          ?.insert(0, CategoryData.fromJson(jsonDecode(objText)));

      planCategoryDataSink.add(Response.completed(systemSettings));
    } catch (e) {
      planCategoryDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  close() {
    _isStreaming = false;
    _systemSettingsDataController?.close();
    _planCategoryDataController?.close();
    _selectedPlanCategoryDataController?.close();
    _selectedPackageCategoryDataController?.close();
  }
}
