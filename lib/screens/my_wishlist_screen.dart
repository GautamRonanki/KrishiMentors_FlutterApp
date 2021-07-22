import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants.dart';
import '../providers/courses.dart';
import '../widgets/wishlist_grid.dart';

class MyWishlistScreen extends StatelessWidget {
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
                  'My Wishlist',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future:
                Provider.of<Courses>(context, listen: false).fetchMyWishlist(),
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
                  return Consumer<Courses>(
                    builder: (context, courseData, child) =>
                        StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      itemCount: courseData.items.length,
                      itemBuilder: (ctx, index) {
                        return WishlistGrid(
                          course: courseData.items[index],
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
