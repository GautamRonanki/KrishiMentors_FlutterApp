import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_text.dart';
import '../models/lesson.dart';
import '../screens/webview_screen.dart';
import '../screens/webview_screen_iframe.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../models/common_functions.dart';
import '../widgets/youtube_player_widget.dart';
import 'dart:io';

class MyCourseHeader extends StatelessWidget {
  final Lesson lesson;

  MyCourseHeader({@required this.lesson});

  Future<void> downloadFile(String downloadUrl, String filename) async {
    Dio dio = Dio();
    print(downloadUrl);

    try {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);

      dio.download(downloadUrl, "${dir.path}/$filename",
          onReceiveProgress: (rec, total) {
        print(rec.toString());
      });
      CommonFunctions.showSuccessToast("Download completed");
    } catch (e) {
      print(e.getMessage());
      CommonFunctions.showSuccessToast("Download Error");
    }
    print("Download completed");
  }

  void _showYoutubeModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return YoutubePlayerWidget(
          videoUrl: lesson.videoUrlWeb,
          newKey: UniqueKey(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: kDarkButtonBg,
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.3,
          child: RaisedButton.icon(
            onPressed: () {
              if (lesson.lessonType == 'video') {
                _showYoutubeModal(context);
              } else if (lesson.lessonType == 'quiz') {
                final _url =
                    BASE_URL + '/home/quiz_mobile_web_view/${lesson.id}';
                Navigator.of(context)
                    .pushNamed(WebviewScreen.routeName, arguments: _url);
              } else {
                if (lesson.attachmentType == 'iframe') {
                  final _url = lesson.attachment;
                  Navigator.of(context).pushNamed(WebviewScreenIframe.routeName,
                      arguments: _url);
                } else {
                  downloadFile(
                    lesson.attachmentUrl,
                    lesson.attachment,
                  );
                }
              }
            },
            color: kBlueColor,
            icon: Icon(
              lesson.lessonType == 'video'
                  ? Icons.play_arrow
                  : lesson.lessonType == 'quiz'
                      ? Icons.help_outline
                      : Icons.attach_file,
              color: Colors.white,
            ),
            label: Customtext(
              text: lesson.lessonType == 'video'
                  ? 'Play on Youtube'
                  : lesson.lessonType == 'quiz'
                      ? 'Start Quiz'
                      : lesson.attachmentType == 'iframe'
                          ? 'View Iframe'
                          : 'Download Attachment',
              fontSize: 14,
              colors: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
              // side: BorderSide(color: kBlueColor),
            ),
          ),
        ),
      ),
    );
  }
}
