
import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/extension_utils.dart';

bool _isShowing = false;
bool _barrierDismissible = true, _showLogs = false;

class LogOutEveryWhereDialog {
  late BuildContext _context, _dismissingContext;

  String title = app_name;
  String? content;
  // Function continueCallBack;
  // BuildContext _context,    _dismissingContext;

  LogOutEveryWhereDialog(BuildContext context) {
    _context = context;
  }

  TextStyle textStyle = TextStyle(color: Colors.black);

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> show(String msg, String uid, Function callback) async {
    try {
      if (!_isShowing) {
        showDialog<dynamic>(
          context: _context,

          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            _dismissingContext = context;

            return AlertDialog(
              title: new Text(
                title,
                style: textStyle,
              ),
              content: new Text(
                msg,
                style: textStyle,
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text(
                    "Logout From everywhere",
                    style: TextStyle(color: HexColor.fromHex(colorAccent)),
                  ),
                  onPressed: () {
                    callback();
                  },
                ),
              ],
            );
          },
        );

        await Future.delayed(Duration(milliseconds: 200));

        _isShowing = true;

        return true;
      } else {
        return false;
      }
    } catch (err) {
      _isShowing = false;

      debugPrint(err.toString());
      return false;
    }
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }
}
