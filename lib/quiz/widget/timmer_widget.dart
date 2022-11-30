import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/utils/extension_utils.dart';

class TimmerWidget extends StatefulWidget {
  int? time;

  bool? isPlaying;

  Function? onTimerDone;

  TimmerWidget({Key? key, this.time, this.isPlaying, this.onTimerDone})
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
    // _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _timer.cancel();
    // _controller.dispose();
    super.dispose();
  }

  // AnimationController _controller;

  late Timer _timer;
  int? _start;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.isPlaying!) {
          if (_start == 0) {
            widget.onTimerDone!();

            setState(() {
              widget.isPlaying = false;
              timer.cancel();
            });
          } else {
            setState(() {
              // _start--;
              _start = _start! - 1;
            });
          }
        }
      },
    );
  }

  format(Duration d) => d.toString().substring(2, 7);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 32.0,
          child: Lottie.asset(
            'assets/timer.json',
            animate: widget.isPlaying,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            "${format(Duration(seconds: _start!))}",
            style: TextStyle(color: HexColor.fromHex(colorBlue)),
          ),
        ),
      ],
    );
  }

  @override
  void didInitState() {
    startTimer();
  }
}
