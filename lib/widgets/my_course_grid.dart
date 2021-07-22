import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';
import '../screens/my_course_detail_screen.dart';
import '../models/my_course.dart';
import '../widgets/custom_text.dart';

class MyCoureGrid extends StatelessWidget {
  final MyCourse myCourse;

  MyCoureGrid({
    @required this.myCourse,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MyCourseDetailScreen.routeName, arguments: myCourse.id);
      },
      child: Container(
        width: double.infinity,
        // height: 400,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading_animated.gif',
                      image: myCourse.thumbnail,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5, right: 8, left: 8, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 42,
                      child: Customtext(
                        text: myCourse.title.length < 38
                            ? myCourse.title
                            : myCourse.title.substring(0, 37),
                        fontSize: 14,
                        colors: kTextLightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: myCourse.courseCompletion / 100,
                        progressColor: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Customtext(
                      text: '${myCourse.courseCompletion}% Completed',
                      fontSize: 12,
                      colors: kTextLightColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: StarDisplayWidget(
                        value: myCourse.rating,
                        filledStar: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 15,
                        ),
                        unfilledStar: Icon(
                          Icons.star,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
