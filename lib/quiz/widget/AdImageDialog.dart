
import 'package:flutter/material.dart';
import 'package:mero_school/quiz/widget/ad_timmer_widget.dart';

class AdImageDialog extends StatelessWidget {
  String? icon;
  int? duration;

  Function onTimerDone;

  AdImageDialog(this.icon, this.duration, this.onTimerDone);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AdTimmerWidget(
              time: duration,
              isPlaying: true,
              onTimerDone: () {
                Navigator.pop(context);

                onTimerDone.call();
              },
            ),
            Image.network(
              icon!,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
