import 'package:flutter/material.dart';
import '../models/section.dart';
import '../constants.dart';
import './custom_text.dart';
import './lesson_list_item.dart';

class SectionListItem extends StatelessWidget {
  final Section section;

  SectionListItem({@required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Customtext(
                  text: section.title,
                  colors: kDarkGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Customtext(
                    text: section.totalDuration,
                    fontSize: 16,
                    colors: kDarkGreyColor,
                  ),
                ),
              )
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return LessonListItem(
              lesson: section.mLesson[index],
            );
            // return Text(section.mLesson[index].title);
          },
          itemCount: section.mLesson.length,
        ),
      ],
    );
  }
}
