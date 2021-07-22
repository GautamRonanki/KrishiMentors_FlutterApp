import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../constants.dart';

class LessonListItem extends StatelessWidget {
  final Lesson lesson;

  LessonListItem({@required this.lesson});

  IconData getLessonIcon(String lessonType) {
    print(lessonType);
    if (lessonType == 'video') {
      return Icons.play_arrow;
    } else if (lessonType == 'quiz') {
      return Icons.help_outline;
    } else {
      return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  getLessonIcon(lesson.lessonType),
                  size: 16,
                  color: kTextBlueColor,
                ),
              ),
            ),
            TextSpan(
                text: lesson.title,
                style: TextStyle(fontSize: 16, color: kTextBlueColor)),
          ],
        ),
      ),
    );
  }
}
