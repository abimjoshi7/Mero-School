
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class CoupenAlertDialog extends StatelessWidget {
  String? content;
  VoidCallback continueCallBack;
  bool? isSuccess;
  VoidCallback? callBackOnCross;

  CoupenAlertDialog(this.content, this.isSuccess, this.continueCallBack,{ this.callBackOnCross});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: InkWell(
          onTap:(){ 
            Navigator.of(context).pop();
            if (callBackOnCross!=null) {
              callBackOnCross!();
            }}
          ,
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
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      isSuccess!
                          ? AntDesign.checkcircle
                          : AntDesign.minuscircle,
                      size: 24,
                      color: isSuccess!
                          ? HexColor.fromHex(firstColor)
                          : HexColor.fromHex(secondColor),
                    ),
                  ),
                  WidgetSpan(child: Text("   ")),
                  TextSpan(
                      text: content,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .apply(color: Colors.black87)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              continueCallBack();
            },
            child: Text("Continue"),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(HexColor.fromHex(colorBlue)),
            ),
          )
        ],
      ),
    );
  }
}
