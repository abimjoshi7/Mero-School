import 'dart:async';

import 'package:entrance/main.dart';
import 'package:entrance/ui/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TimmerWidget extends StatefulWidget {
  int time;

  bool isPlaying;

  Function onTimerDone;

  TimmerWidget(
      {Key? key,
      required this.time,
      required this.isPlaying,
      required this.onTimerDone})
      : super(key: key);

  @override
  _TimmerWidgetState createState() {
    return _TimmerWidgetState();
  }
}

class _TimmerWidgetState extends State<TimmerWidget> {
  @override
  void initState() {
    super.initState();

    _start = widget.time;

    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // _controller.dispose();
    super.dispose();
  }

  // AnimationController _controller;

  Timer? _timer;
  late int _start;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.isPlaying) {
          if (_start == 0) {
            widget.onTimerDone();

            setState(() {
              widget.isPlaying = false;
              timer.cancel();
            });
          } else {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  format(Duration d) => d.toString().substring(2, 7);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 32.0,
          width: 32.0,
          child: Lottie.asset(
            'loti/timer.json',
            animate: widget.isPlaying,
            // delegates: LottieDelegates(
            //   text: (initialText) => '**$initialText',
            //   values: [
            //     ValueDelegate.color(
            //       const[
            //         "progress", 'comp_0', 'comp_1','Ellipse Path 1','progress'
            //       ],
            //       value: Colors.red
            //     )
            //   ]
            // )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            "${intToTimeLeft(_start)}",
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
