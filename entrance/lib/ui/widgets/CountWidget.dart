import 'package:entrance/ui/utils/VerticalSpace.dart';
import 'package:flutter/material.dart';


class CountWidget extends StatelessWidget {
  int count = 0;
  IconData iconData;
  String title = "";

  bool type = true;

  CountWidget(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: type
          ? Column(
              children: [
                Icon(iconData, color: Colors.teal),
                Text(
                  "$count",
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Text(
                  "$title",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )
          : Row(
              children: [
                Icon(iconData, color: Colors.grey),
                VSpace(),
                Text(
                  "$count $title",
                  style: TextStyle(),
                )
              ],
            ),
    );
  }
}
