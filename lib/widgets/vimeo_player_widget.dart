import 'package:academy_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:vimeoplayer/vimeoplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VimeoPlayerWidget extends StatefulWidget {
  final String videoId;
  final UniqueKey newKey;
  VimeoPlayerWidget({@required this.videoId, this.newKey});
  @override
  _VimeoPlayerWidgetState createState() => _VimeoPlayerWidgetState();
}

class _VimeoPlayerWidgetState extends State<VimeoPlayerWidget> {
  // String videoURL = "https://www.youtube.com/watch?v=n8X9_MgEdCg";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      // do something
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VimeoPlayer(
                      id: widget.videoId,
                      autoPlay: true,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
