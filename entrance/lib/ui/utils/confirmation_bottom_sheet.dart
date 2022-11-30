import 'package:entrance/ui/utils/VerticalSpace.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ConfirmationDialog extends StatelessWidget {
  String? title;
  String? message;
  String? action;
  VoidCallback? onConfirm;

  ConfirmationDialog(
      {Key? key, this.title, this.message, this.action, this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "$title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);

                      onConfirm?.call();

                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "$action",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            VSpace(),
            VSpace(),
            Text(
              "$message",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

}
