import 'package:academy_app/screens/webview_purchase_screen.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:academy_app/widgets/util.dart';
import 'package:academy_app/widgets/vimeo_player_widget.dart';
import 'package:http/http.dart' as http;
import 'package:academy_app/screens/temp_view_screen.dart';
import 'package:academy_app/widgets/star_display_widget.dart';
import 'package:academy_app/widgets/youtube_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../constants.dart';
import '../providers/courses.dart';
import '../providers/auth.dart';
import '../widgets/section_list_item.dart';
import '../widgets/tab_view_details.dart';
import '../widgets/custom_text.dart';
import '../models/common_functions.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = '/course-details';

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _isInit = true;
  var _isAuth = false;
  var _authToken = '';

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isAuth = Provider.of<Auth>(context, listen: false).isAuth;
        _authToken = Provider.of<Auth>(context, listen: false).token;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context).settings.arguments as int;
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);

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
    void _showVimeoModal(BuildContext ctx, vimeoVideoId) {
      // print(loadedCourse.vimeoVideoId);
      showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return VimeoPlayerWidget(
            videoId: vimeoVideoId,
            newKey: UniqueKey(),
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBarTwo(),
      body: FutureBuilder(
        future: Provider.of<Courses>(context, listen: false)
            .fetchCourseDetailById(courseId),
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 3.3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                text: loadedCourse.title,
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                image: new NetworkImage(
                                  loadedCourse.thumbnail,
                                ),
                              )
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 20/100,
                            ),
                            Row(
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
                                          left: 20,
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
                                                  if (loadedCourse.courseOverviewProvider ==
                                                      'vimeo') {
                                                    String vimeoVideoId = loadedCourse.courseOverviewUrl.split('/').last;
                                                    _showVimeoModal(context, vimeoVideoId);
                                                  } else if (loadedCourse.courseOverviewProvider ==
                                                      'html5') {
                                                    Navigator.of(context).pushNamed(
                                                        TempViewScreen.routeName,
                                                        arguments: loadedCourse.courseOverviewUrl);
                                                  } else {
                                                    if(loadedCourse.courseOverviewProvider.isEmpty) {
                                                      CommonFunctions.showSuccessToast('Video url not provided');
                                                    } else {
                                                      _showYoutubeModal(context);
                                                    }
                                                  }
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
                                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
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
                                        padding: EdgeInsets.only(top: 2, bottom: 2, right: 25, left: 10),
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
                          ],
                        ),
                      ],
                    ),
                    Consumer<Courses>(
                      builder: (context, courses, child) {
                        final loadedCourseDetail = courses.getCourseDetail;
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerRight,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    right: 25, left: 20, top: 10, bottom: 5),
                                child: Customtext(
                                  text: loadedCourse.price,
                                  fontSize: 24,
                                  colors: kTextColor,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, top: 0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        color: kSecondaryColor,
                                      ),
                                      tooltip: 'Share',
                                      onPressed: () {
                                        Share.share(loadedCourse.shareableLink);
                                        // Share.share(
                                        // 'check out my website https://example.com');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        loadedCourseDetail.isWishlisted
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: loadedCourseDetail.isWishlisted
                                            ? kDeepBlueColor
                                            : kSecondaryColor,
                                      ),
                                      tooltip: 'Wishlist',
                                      onPressed: () {
                                        if (_isAuth) {
                                          var msg = loadedCourseDetail.isWishlisted;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => buildPopupDialogWishList(context, courses, loadedCourseDetail.isWishlisted, loadedCourse.id, msg),
                                          );
                                        } else {
                                          CommonFunctions.showSuccessToast(
                                              'Please login first');
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: RaisedButton(
                                        onPressed: () {
                                          if (!loadedCourseDetail.isPurchased) {
                                            final _url = BASE_URL +
                                                '/home/course_purchase/$_authToken/$courseId';
                                            Navigator.of(context).pushNamed(
                                                WebviewPurchaseScreen.routeName,
                                                arguments: _url);
                                          }
                                        },
                                        child: Text(
                                          loadedCourseDetail.isPurchased
                                              ? 'Purchased'
                                              : 'Buy Now',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        color: loadedCourseDetail.isPurchased
                                            ? kGreenColor
                                            : kBlueColor,
                                        textColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        splashColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7.0),
                                          // side: BorderSide(color: kBlueColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: kTabBarBg,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    right: 0, left: 0, top: 0, bottom: 0),
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorColor: kBlueColor,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(color: kBlueColor),
                                  unselectedLabelColor: kBlueColor,
                                  labelColor: Colors.white,
                                  tabs: <Widget>[
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Includes",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Outcomes",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Requirements",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 300,
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, top: 10, bottom: 10),
                                child: Card(
                                  elevation: 4,
                                  color: kBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      TabViewDetails(
                                        titleText: 'What is Included',
                                        listText: loadedCourseDetail.courseIncludes,
                                        icon: Icons.present_to_all,
                                      ),
                                      TabViewDetails(
                                        titleText: 'What you will learn',
                                        listText: loadedCourseDetail.courseOutcomes,
                                        icon: Icons.check,
                                      ),
                                      TabViewDetails(
                                        titleText: 'Course Requirements',
                                        listText:
                                        loadedCourseDetail.courseRequirements,
                                        icon: Icons.description,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Customtext(
                                      text: 'Course Curriculam',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      colors: kDarkGreyColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Icon(
                                      Icons.book,
                                      color: kSecondaryColor,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, top: 10, bottom: 10),
                                child: Card(
                                  elevation: 4,
                                  color: kBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, index) {
                                      return SectionListItem(
                                        section: loadedCourseDetail.mSection[index],
                                      );
                                    },
                                    itemCount: loadedCourseDetail.mSection.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
