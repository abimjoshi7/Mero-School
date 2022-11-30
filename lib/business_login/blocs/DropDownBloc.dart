import 'package:flutter/cupertino.dart';
import 'package:mero_school/data/models/response/all_plans_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class AppPlanNotifier extends ChangeNotifier {
  AppPlanData? appPlanData;

  void fetch(String planId, AppPlanData ap) async {
    if (appPlanData != null) {
      appPlanData = ap;
      // print('NotifyListnerDefalut ');

      notifyListeners();
    } else {
      var _myNetworkClient = MyNetworkClient();

      var t = await Preference.getString(token);

      PlanDetailResponse response = await _myNetworkClient.getPlanDetail(
          Common.checkNullOrNot(t), planId);

      appPlanData = response.data;
      // print('NotifyListner');
      notifyListeners();
    }
  }
}
