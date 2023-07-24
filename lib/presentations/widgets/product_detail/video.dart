import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// ignore: must_be_immutable
class YoutubeVideoWidget extends StatelessWidget {
  YoutubePlayerController controller;
  YoutubeVideoWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: controller,
      child: YoutubePlayerIFrame(
        aspectRatio: 16 / 9,
      ),
    );
  }
}
