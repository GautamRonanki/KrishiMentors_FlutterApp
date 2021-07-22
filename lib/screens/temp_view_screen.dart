import 'package:flutter/material.dart';
import '../widgets/video_player_widget.dart';
import '../constants.dart';

class TempViewScreen extends StatelessWidget {
  static const routeName = '/temp-view';

  @override
  Widget build(BuildContext context) {
    final videoUrl = ModalRoute.of(context).settings.arguments as String;

    return WillPopScope(
      // onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
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
                  child: VideoPlayerWidget(
                    videoUrl: videoUrl,
                    newKey: UniqueKey(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
