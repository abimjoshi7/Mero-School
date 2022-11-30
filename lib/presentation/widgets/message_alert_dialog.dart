import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class MessageAlertDialog extends StatelessWidget {
  String content;
  VoidCallback continueCallBack;
  String action;

  MessageAlertDialog(this.content, this.action, this.continueCallBack);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new Icon(
                    Entypo.cross,
                    color: HexColor.fromHex(bottomNavigationIdealState),
                  ),
                ],
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Text(
                content,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .apply(color: Colors.black87),
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  continueCallBack();
                },
                child: Text(action),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      HexColor.fromHex(colorBlue)),
                ),
              )
            ],
          ),
        ));
  }
}
