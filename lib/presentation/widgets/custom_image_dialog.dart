
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class CustomImageDialog extends StatelessWidget {
  String? icon;

  CustomImageDialog(this.icon);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Entypo.cross,
                  color: Colors.white,
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                icon!,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
