import 'dart:async';

import 'package:flutter/material.dart';

class AdTimmerWidget extends StatefulWidget {
  int? time;

  bool? isPlaying;

  Function? onTimerDone;

  AdTimmerWidget({Key? key, this.time, this.isPlaying, this.onTimerDone})
      : super(key: key);

  @override
  _AdTimmerWidgetState createState() {
    return _AdTimmerWidgetState();
  }
}

class _AdTimmerWidgetState extends State<AdTimmerWidget> {
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
  int? _start = 0;

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
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "${format(Duration(seconds: _start!))}",
            style: TextStyle(color: Colors.white),
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
