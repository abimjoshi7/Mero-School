import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/preference.dart';

class VideoPreview extends StatefulWidget {
  final String url;
  final String token;

  const VideoPreview({Key? key, required this.url, required this.token})
      : super(key: key);

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  BetterPlayerConfiguration? _betterPlayerConfiguration;

  BetterPlayerController? _betterPlayerController;

  BetterPlayerDataSource? _betterPlayerDataSource;

  @override
  void initState() {
    // betterPlayerInitialized();

    super.initState();
  }

  Future<bool> betterPlayerInitialized() async {
    var byPassCacheValue = false;

    var serverValue = await Preference.getString(bypass);

    //Platform.isIOS &&

    if (Platform.isIOS && serverValue == "true") {
      byPassCacheValue = true;
    }

    _betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: false,
      aspectRatio: 16 / 9,
      fit: BoxFit.fill,
      placeholderOnTop: true,
      showPlaceholderUntilPlay: true,
      handleLifecycle: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      byPassCache: byPassCacheValue,
      controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePip: false,
          enableMute: false,
          enableProgressText: false,
          enableQualities: true),
    );

    print("previewurl: ${widget.url}");

    _betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.url,
        headers: {"Authorization": widget.token.trim()});

    _betterPlayerController =
        BetterPlayerController(_betterPlayerConfiguration!);
    _betterPlayerController?.setupDataSource(_betterPlayerDataSource!);

    return true;
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          margin: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Preview",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .apply(color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.play_arrow_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // MyDivider(),

                // Text(widget.url, softWrap: true,),

                (widget.url.isNotEmpty == true)
                    ? FutureBuilder(
                        future: betterPlayerInitialized(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return BetterPlayer(
                                controller: _betterPlayerController!);
                          }
                          return Container();
                        })
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("No preview Available"),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
