import 'package:flutter/material.dart';
import '../models/section.dart';
import '../widgets/custom_text.dart';
import '../constants.dart';

class MyCourseSectionListItem extends StatelessWidget {
  final Section section;
  final int index;

  MyCourseSectionListItem({@required this.section, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            color: kSectionTileColor,
            boxShadow: [kDefaultShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Customtext(
                text: 'Section ${index + 1}',
                fontSize: 12,
              ),
              Customtext(
                text: section.title,
                fontSize: 14,
                colors: kTextColor,
                fontWeight: FontWeight.bold,
              ),
              Customtext(
                text: '${section.mLesson.length} Lessons',
                fontSize: 12,
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            // return LessonListItem(
            //   lesson: section.mLesson[index],
            // );
            final lesson = section.mLesson[index];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Customtext(
                        text: '2',
                        fontSize: 16,
                      )),
                  Expanded(
                      flex: 8,
                      child: Customtext(
                        text: '8',
                        fontSize: 16,
                      )),
                  Expanded(
                      flex: 2,
                      child: Customtext(
                        text: '2',
                        fontSize: 16,
                      )),
                ],
              ),
            );
            // return Text(section.mLesson[index].title);
          },
          itemCount: section.mLesson.length,
        )
      ],
    );
  }
}
