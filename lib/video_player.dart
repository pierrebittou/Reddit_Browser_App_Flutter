import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoPlayer extends StatefulWidget {
  final dynamic redditPost;

  const VideoPlayer({Key? key, required this.redditPost}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isMounted = false;
  late Widget videoPlayer;

  Future<Widget> getVideos(dynamic response) async {
    VideoPlayerController videoPlayerController;

    if (response["url_overridden_by_dest"].toString().contains(".gifv")) {
      videoPlayerController = VideoPlayerController.network(
          response["preview"]["reddit_video_preview"]["fallback_url"]);
      await videoPlayerController.initialize();
      var chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );

      var playerWidget = FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          height: videoPlayerController.value.size.height,
          width: videoPlayerController.value.size.width + 100,
          child: Chewie(controller: chewieController),
        ),
      );
      return playerWidget;
    }

    if (response["domain"] == "gfycat.com") {
      if (response["secure_media"]["oembed"]["thumbnail_url"]
              .toString()
              .contains(".gif") ==
          true) {
        return Image.network(
            response["secure_media"]["oembed"]["thumbnail_url"]);
      }
      videoPlayerController = VideoPlayerController.network(
          response["secure_media"]["oembed"]["thumbnail_url"]);
      await videoPlayerController.initialize();
      var chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );

      var playerWidget = FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          height: videoPlayerController.value.size.height,
          width: videoPlayerController.value.size.width + 100,
          child: Chewie(controller: chewieController),
        ),
      );

      return playerWidget;
    }
    if (response["post_hint"] == "rich:video") {
      videoPlayerController = VideoPlayerController.network(
          response["media"]["reddit_video_preview"]["hls_url"]);
      await videoPlayerController.initialize();
    } else {
      videoPlayerController = VideoPlayerController.network(
          response["media"]["reddit_video"]["hls_url"]);
      await videoPlayerController.initialize();
    }

    var chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );

    var playerWidget = FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        height: videoPlayerController.value.size.height,
        width: videoPlayerController.value.size.width + 150,
        child: Chewie(controller: chewieController),
      ),
    );

    return playerWidget;
  }

  @override
  void initState() {
    super.initState();
    getVideos(widget.redditPost).then(
      (Widget playerWidget) {
        if (mounted == false) {
          return;
        }
        setState(
          () {
            videoPlayer = playerWidget;
            isMounted = true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMounted == false ? const Text("LOADING") : videoPlayer;
  }
}
