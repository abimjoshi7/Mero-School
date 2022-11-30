import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/widgets/loading/mydivider.dart';

import 'extension_utils.dart';

class MoreMenu extends StatelessWidget {
  String title;
  IconData icon;
  Function? callback;

  MoreMenu(
      {Key? key,
      required this.title,
      required this.icon,
      this.callback,
      this.isLast = false})
      : super(key: key);

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    Widget widget = MyDivider();

    if (isLast) {
      widget = SizedBox();
    }

    return InkWell(
      onTap: () {
        callback!.call();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      icon,
                      color: HexColor.fromHex(colorBlue),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(title,
                          softWrap: true,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 17)),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black12,
                    )
                  ],
                ),
              ),
            ),
          ),
          widget
        ],
      ),
    );
  }
}
