import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final UniqueKey newKey;
  VideoPlayerWidget({@required this.videoUrl, this.newKey})
      : super(key: newKey);
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // String videoURLTemp =
  //     "http://192.168.31.118/AcademyWeb/uploads/lesson_files/videos/8eafef080f4befb0de2c8bdeb8a80768.mp4";

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  FlickManager flickManager;

  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    // _initializeVideoPlayerFuture = _controller.initialize();
    flickManager = FlickManager(videoPlayerController: _controller);
    // _controller.setLooping(true);
    // _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataSnapshot.error != null) {
            //error
            return Center(
              child: Text('Error Occured'),
            );
          } else {
            return AspectRatio(
                aspectRatio: 16 / 9,
                child: FlickVideoPlayer(flickManager: flickManager));
          }
        }
      },
    );
  }
}
