import '../screens/youtube_screen.dart';

import '../widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';
import '../models/course.dart';
import '../widgets/youtube_player_widget.dart';

class CourseDetailHeader extends StatelessWidget {
  final Course loadedCourse;
  CourseDetailHeader({@required this.loadedCourse});

  void _showYoutubeModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return YoutubePlayerWidget(
          videoUrl: loadedCourse.courseOverviewUrl,
          newKey: UniqueKey(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: loadedCourse.title,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      flexibleSpace: FadeInImage.assetNetwork(
        placeholder: 'assets/images/loading_animated.gif',
        image: loadedCourse.thumbnail,
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: 80,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      bottom: -30,
                      right: 50,
                      child: ClipOval(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage('assets/images/play.png'),
                                fit: BoxFit.contain),
                            boxShadow: [kDefaultShadow],
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              _showYoutubeModal(context);
                              // Navigator.of(context).pushNamed(
                              //     YoutubeScreen.routeName,
                              //     arguments: loadedCourse.id);
                            },
                            child: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.school,
                            color: Colors.white,
                          ),
                        ),
                        Customtext(
                          text: loadedCourse.numberOfEnrollment.toString(),
                          fontSize: 16,
                          colors: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: StarDisplayWidget(
                            value: loadedCourse.rating,
                            filledStar: Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 15,
                            ),
                            unfilledStar: Icon(
                              Icons.star,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(
                            '${loadedCourse.rating}.0',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Customtext(
                          text: '( ${loadedCourse.totalNumberRating} )',
                          fontSize: 16,
                          colors: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
