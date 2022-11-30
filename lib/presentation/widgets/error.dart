import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class Error extends StatelessWidget {
  final String? errorMessage;

  final Function? onRetryPressed;

  bool? isDisplayButton = true;

  Error(
      {Key? key, this.errorMessage, this.onRetryPressed, this.isDisplayButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Visibility(
              visible: isDisplayButton == null ? true : isDisplayButton!,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          HexColor.fromHex(colorAccent))),
                  onPressed: onRetryPressed as void Function()?,
                  child: Text('Retry', style: TextStyle(color: Colors.white))))
        ],
      ),
    );
  }
}
