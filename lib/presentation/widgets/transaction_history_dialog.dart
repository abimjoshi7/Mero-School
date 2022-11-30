import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class TransactionHistoryDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  TransactionHistoryDialog(this.title, this.content, this.continueCallBack);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            title,
            style: textStyle,
          ),
          content: new Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            new TextButton(
              child: Text("Cancel",
                  style: TextStyle(color: HexColor.fromHex(colorAccent))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(
                "Buy",
                style: TextStyle(color: HexColor.fromHex(colorAccent)),
              ),
              onPressed: () {
                continueCallBack();
              },
            ),
          ],
        ));
  }
}
