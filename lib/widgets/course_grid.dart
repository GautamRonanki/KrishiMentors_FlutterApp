import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../widgets/star_display_widget.dart';
import '../screens/course_detail_screen.dart';

class CoureGrid extends StatelessWidget {
  final int id;
  final String title;
  final String thumbnail;
  final int rating;
  final String price;

  CoureGrid({
    @required this.id,
    @required this.title,
    @required this.thumbnail,
    @required this.rating,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: id);
      },
      child: Container(
        width: 200,
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
                      image: thumbnail,
                      height: 130,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5, right: 8, left: 8, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: Text(
                        title.length < 41 ? title : title.substring(0, 40),
                        style: TextStyle(fontSize: 14, color: kTextLightColor),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StarDisplayWidget(
                          value: rating,
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
                        Text(
                          price,
                          style:
                              TextStyle(fontSize: 14, color: kTextLightColor),
                        ),
                      ],
                    )
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
