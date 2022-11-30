import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/utils/extension_utils.dart';

class CongratsDialog extends StatelessWidget {
  String title;
  String content;

  CongratsDialog(this.title, this.content);

  TextStyle textStyle = TextStyle(
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
            content: SizedBox(
          height: 250,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 250,
                    child: Lottie.asset('assets/congrats.json', animate: true),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.bottomCenter,
                child: Text(
                  content.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    new Text(
                      title,
                      style: TextStyle(
                          fontSize: 20, color: HexColor.fromHex("#6A0002")),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_outlined))
                  ],
                ),
              )
            ],
          ),
        )));
  }
}
