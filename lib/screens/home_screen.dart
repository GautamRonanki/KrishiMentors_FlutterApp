import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/course_grid.dart';
import '../widgets/category_list_item.dart';
import '../providers/categories.dart';
import '../providers/courses.dart';
import '../constants.dart';
import '../screens/courses_screen.dart';
import '../models/common_functions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var catData = [];
  var topCourses = [];

  @override
  void initState() {
    super.initState();
  }

  Color getBackgroundColor(int index) {
    if (index % 3 == 0) {
      return kDeepBlueColor;
    } else if (index % 3 == 1) {
      return kRedColor;
    } else {
      return kGreenColor;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Categories>(context).fetchCategories().then((_) {
        setState(() {
          _isLoading = false;
          catData = Provider.of<Categories>(context, listen: false).items;
        });
      });

      Provider.of<Courses>(context).fetchTopCourses().then((_) {
        setState(() {
          _isLoading = false;
          topCourses = Provider.of<Courses>(context, listen: false).topItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<Null> refreshList() async {
    try {
      await Provider.of<Categories>(context, listen: false).fetchCategories();
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();

      setState(() {
        catData = Provider.of<Categories>(context, listen: false).items;
        topCourses = Provider.of<Courses>(context, listen: false).topItems;
      });
    } catch (error) {
      print(error);
      const errorMsg = 'Could not refresh!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // final catData = Provider.of<Categories>(context, listen: false).items;
    // final topCourses = Provider.of<Courses>(context, listen: false).topItems;
    // print(topCourses.length);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: refreshList,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Top Course',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CoursesScreen.routeName,
                              arguments: {
                                'category_id': null,
                                'seacrh_query': null,
                                'type': CoursesPageData.All,
                              },
                            );
                          },
                          child: Text('All courses>'),
                          padding: EdgeInsets.all(0),
                          textColor: Colors.blue,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0.0),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 224.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return CoureGrid(
                          id: topCourses[index].id,
                          title: topCourses[index].title,
                          thumbnail: topCourses[index].thumbnail,
                          rating: topCourses[index].rating,
                          price: topCourses[index].price,
                        );
                      },
                      itemCount: topCourses.length,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CoursesScreen.routeName,
                              arguments: {
                                'category_id': null,
                                'seacrh_query': null,
                                'type': CoursesPageData.All,
                              },
                            );
                          },
                          child: Text('All courses>'),
                          padding: EdgeInsets.all(0),
                          textColor: Colors.blue,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return CategoryListItem(
                          id: catData[index].id,
                          title: catData[index].title,
                          thumbnail: catData[index].thumbnail,
                          numberOfCourses: catData[index].numberOfCourses,
                          backgroundColor: getBackgroundColor(index),
                        );
                      },
                      itemCount: catData.length,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
