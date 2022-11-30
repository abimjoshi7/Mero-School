import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';

class UserStateViewModel with ChangeNotifier {
  String? loginToken;

  UserStateViewModel() {
    initdata();
  }

  initdata() async {
    var t = await Preference.getString(user_token);
    var tkn = Common.checkNullOrNot(t);

    // print("tkn: $tkn");
    if (tkn.isEmpty) {
      this.loginToken = "";
    } else {
      this.loginToken = tkn;
    }

    notifyListeners();
  }

  check() async {
    var t = await Preference.getString(user_token);
    var tkn = Common.checkNullOrNot(t);

    // print("tkn: $tkn");

    this.loginToken = tkn;
    notifyListeners();
  }

  void update(String? tkn) {
    this.loginToken = tkn;
    notifyListeners();
  }

  void remove() {
    this.loginToken = "";
    notifyListeners();
  }
}
