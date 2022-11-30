import 'package:flutter/cupertino.dart';

class CurrentPlayingNotifier extends ChangeNotifier {
  String url = "";

  void update(String tkn) {
    try {
      this.url = tkn;
      // print("update-=----- $tkn");

      if (tkn.isNotEmpty) {
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
