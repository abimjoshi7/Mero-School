import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/image_error.dart';

class CustomNotificationAlertDialog extends StatelessWidget {
  String? title;
  String? notifyTime;
  String? description;
  String? icon;

  CustomNotificationAlertDialog(
      this.title, this.notifyTime, this.description, this.icon);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Entypo.cross)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .apply(color: Colors.black87, fontWeightDelta: 1),
                ),
                SizedBox(
                  height: 8,
                ),

                icon != null && icon != empty
                    ? Image.network(
                        icon!,
                        fit: BoxFit.fill,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        errorBuilder: (_, __, ___) {
                          return ImageErrorBg();
                        },
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                      ),

                // FadeInImage.assetNetwork(
                //   placeholder: logo,
                //   image: icon!=null && icon != empty ? icon: logo,
                //   height: 200,
                //   width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.fill,
                //   imageErrorBuilder: (_,__,___){
                //     return ImageErrorLogo();
                //   },
                // ),

                SizedBox(
                  height: 8,
                ),
                Text(
                  description!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .apply(color: Colors.black87),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(notifyTime!)
          ],
        ),
      ),
    );
  }
}
