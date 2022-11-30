import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';

class AdVideoPlayer extends StatefulWidget {
  String? icon;
  Function? onTimerDone;

  AdVideoPlayer({Key? key, this.icon, this.onTimerDone}) : super(key: key);

  @override
  _AdVideoPlayerState createState() {
    return _AdVideoPlayerState();
  }
}

class _AdVideoPlayerState extends State<AdVideoPlayer> {
  late VideoPlayerController videoPlayerController;

  String duration = "Please wait..";
  bool called = false;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.network('${widget.icon}',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));

    videoPlayerController.setLooping(false);

    videoPlayerController
        .initialize()
        .then((value) => {videoPlayerController.play()});

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.hasError) {
        print("==print error: ${videoPlayerController.value.hasError}");

        if (!called) {
          called = true;
          Navigator.pop(context);
          widget.onTimerDone!.call();
        }

        print(videoPlayerController.value.errorDescription);
      }

      if (!videoPlayerController.value.isPlaying &&
          videoPlayerController.value.isInitialized &&
          (videoPlayerController.value.position ==
              videoPlayerController.value.duration)) {
        if (!called) {
          called = true;
          Navigator.pop(context);
          widget.onTimerDone!.call();
        }
      }
    });

    // videoPlayerController.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(videoPlayerController),
                VideoProgressIndicator(
                  videoPlayerController,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                      backgroundColor: Colors.black12,
                      bufferedColor: Colors.redAccent,
                      playedColor: Colors.white),
                )
              ],
            ),
          )),
    );
  }

  Duration get totalVideoLength {
    return videoPlayerController.value.duration;
  }

  String get totalVideoLengthString {
    return _printDuration(totalVideoLength);
  }

  Duration get timeRemaining {
    Duration current = videoPlayerController.value.position;
    int millis = totalVideoLength.inMilliseconds - current.inMilliseconds;
    return Duration(milliseconds: millis);
  }

  String get timeRemainingString {
    return _printDuration(timeRemaining);
  }

  TextStyle textStyle = TextStyle(color: Colors.black);
}

String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
