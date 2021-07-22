import 'package:academy_app/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses.dart';
import '../constants.dart';
import '../screens/course_detail_screen.dart';
import '../models/course.dart';
import '../widgets/custom_text.dart';
import '../models/common_functions.dart';

class WishlistGrid extends StatelessWidget {
  final Course course;

  WishlistGrid({
    @required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: course.id);
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
                      image: course.thumbnail,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      height: 42,
                      child: Customtext(
                        text: course.title.length < 38
                            ? course.title
                            : course.title.substring(0, 37),
                        fontSize: 14,
                        colors: kTextLightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PopupMenuButton(
                        onSelected: (int courseId) {
                          // Provider.of<Courses>(context, listen: false)
                          //     .toggleWishlist(courseId, true)
                          //     .then((_) => CommonFunctions.showSuccessToast(
                          //         'Removed from wishlist.'));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => buildPopupDialog(context, courseId),
                          );
                        },
                        icon: Icon(
                          Icons.more_horiz,
                        ),
                        itemBuilder: (_) => [
                              PopupMenuItem(
                                child: Text('Remove from wishlist'),
                                value: course.id,
                              ),
                            ]),
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
