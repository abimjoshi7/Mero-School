import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    final Map _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(_arguments['video_url'])!,
      flags:
          YoutubePlayerFlags(autoPlay: true, mute: false, enableCaption: false),
    );
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
