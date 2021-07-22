import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants.dart';
import '../providers/my_courses.dart';
import '../widgets/my_course_grid.dart';

class MyCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'My Courses',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future:
                Provider.of<MyCourses>(context, listen: false).fetchMyCourses(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  //error
                  return Center(
                    child: Text('Error Occured'),
                  );
                } else {
                  return Consumer<MyCourses>(
                    builder: (context, myCourseData, child) =>
                        StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      itemCount: myCourseData.items.length,
                      itemBuilder: (ctx, index) {
                        return MyCoureGrid(
                          myCourse: myCourseData.items[index],
                        );
                        // return Text(myCourseData.items[index].title);
                      },
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
