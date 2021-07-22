import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseYoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;
  final UniqueKey newKey;
  CourseYoutubePlayerWidget({@required this.videoUrl, this.newKey})
      : super(key: newKey);
  @override
  _CourseYoutubePlayerWidgetState createState() =>
      _CourseYoutubePlayerWidgetState();
}

class _CourseYoutubePlayerWidgetState extends State<CourseYoutubePlayerWidget> {
  // String videoURL = "https://www.youtube.com/watch?v=n8X9_MgEdCg";

  YoutubePlayerController _controller;

  void initState() {
    // print(widget.videoUrl);
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl));

    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void deactivate() {
  //   // Pauses video while navigating to next page.
  //   _controller.pause();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          builder: (ctx, player) {
            return Column(
              children: [
                // some widgets
                Expanded(child: player),
                //some other widgets
              ],
            );
          },
        ),
      ),
    );
  }
}
