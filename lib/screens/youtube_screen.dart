import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants.dart';

class YoutubeScreen extends StatefulWidget {
  static const routeName = '/youtube';
  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  String videoURL = "https://www.youtube.com/watch?v=n8X9_MgEdCg";

  YoutubePlayerController _controller;

  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoURL));

    super.initState();
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body: Container(
              color: Colors.black,
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: kSecondaryColor, //change your color here
              ),
              title: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              backgroundColor: kBackgroundColor,
            ),
            body: Container(
              color: Colors.black,
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       iconTheme: IconThemeData(
  //         color: kSecondaryColor, //change your color here
  //       ),
  //       title: Image.asset(
  //         'assets/images/logo.png',
  //         fit: BoxFit.contain,
  //         height: 32,
  //       ),
  //       backgroundColor: kBackgroundColor,
  //     ),
  //     body: Container(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: <Widget>[
  //             YoutubePlayer(
  //               controller: _controller,
  //               showVideoProgressIndicator: true,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
