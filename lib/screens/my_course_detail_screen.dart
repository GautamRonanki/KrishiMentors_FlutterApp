import 'dart:convert';
import 'package:academy_app/providers/auth.dart';
import 'package:academy_app/screens/my_course_download_screen.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:academy_app/widgets/vimeo_player_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import '../providers/my_courses.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/my_course_header.dart';
import '../widgets/custom_text.dart';
import '../models/lesson.dart';
import '../constants.dart';
import '../models/common_functions.dart';
import '../screens/course_detail_screen.dart';
import '../widgets/youtube_player_widget.dart';
import '../screens/webview_screen.dart';
import '../screens/webview_screen_iframe.dart';
import '../screens/temp_view_screen.dart';

class MyCourseDetailScreen extends StatefulWidget {
  static const routeName = '/my-course-details';
  @override
  _MyCourseDetailScreenState createState() => _MyCourseDetailScreenState();
}

class _MyCourseDetailScreenState extends State<MyCourseDetailScreen> {
  var _isInit = true;
  var _isAuth = false;
  var _isLoading = false;
  var userId;
  Lesson _activeLesson = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        userId = Provider.of<Auth>(context, listen: false).userId;
      });
      final myCourseId = ModalRoute.of(context).settings.arguments as int;

      Provider.of<MyCourses>(context, listen: false)
          .fetchCourseSections(myCourseId)
          .then((_) {
        final activeSections =
            Provider.of<MyCourses>(context, listen: false).sectionitems;
        setState(() {
          _isLoading = false;
          _activeLesson = activeSections.first.mLesson.first;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget setPageheader(Lesson activelesson) {
    if (activelesson.lessonType == 'video') {
      if (activelesson.videoTypeWeb == 'system' ||
          activelesson.videoTypeWeb == 'html5') {
        return VideoPlayerWidget(
            videoUrl: activelesson.videoUrlWeb, newKey: UniqueKey());
      } else {
        return MyCourseHeader(lesson: activelesson);
        // return CourseYoutubePlayerWidget(
        // videoUrl: activelesson.videoUrlWeb, newKey: UniqueKey());
      }
    } else {
      return MyCourseHeader(lesson: activelesson);
    }
  }

  void _showYoutubeModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return YoutubePlayerWidget(
          videoUrl: _activeLesson.videoUrlWeb,
          newKey: UniqueKey(),
        );
      },
    );
  }

  void _showVimeoModal(BuildContext ctx, String vimeoVideoId) {
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

  void _showVideoModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return VideoPlayerWidget(
          videoUrl: _activeLesson.videoUrlWeb,
          newKey: UniqueKey(),
        );
      },
    );
  }

  void lessonAction(Lesson lesson) {
    if (lesson.lessonType == 'video') {
      if (lesson.videoTypeWeb == 'system' || lesson.videoTypeWeb == 'html5' || lesson.videoTypeWeb == 'amazon') {
        // _showVideoModal(context);
        Navigator.of(context)
            .pushNamed(TempViewScreen.routeName, arguments: lesson.videoUrlWeb);
      } else if (lesson.videoTypeWeb == 'Vimeo') {
        String vimeoVideoId = lesson.videoUrlWeb.split('/').last;
        print(lesson.vimeoVideoId);
        _showVimeoModal(context, vimeoVideoId);
      } else {
        _showYoutubeModal(context);
      }
    } else if (lesson.lessonType == 'quiz') {
      print(lesson.id);
      final _url = BASE_URL + '/home/quiz_mobile_web_view/${lesson.id}';
      print(_url);
      Navigator.of(context).pushNamed(WebviewScreen.routeName, arguments: _url);
    } else {
      if (lesson.attachmentType == 'iframe') {
        final _url = lesson.attachment;
        Navigator.of(context)
            .pushNamed(WebviewScreenIframe.routeName, arguments: _url);
      } else {
        final _url = lesson.attachmentUrl;
        // final _name = lesson.title;
        // Navigator.of(context)
        //     .pushNamed(MyCourseDownloadScreen.routeName, arguments: {'_url': _url, '_name': _name});
        Navigator.of(context)
            .pushNamed(MyCourseDownloadScreen.routeName, arguments: _url);
        // final _url = lesson.attachmentUrl;
        // Navigator.of(context)
        //     .pushNamed(WebviewScreen.routeName, arguments: _url);
      }
    }
  }

  Widget getLessonSubtitle(Lesson lesson) {
    if (lesson.lessonType == 'video') {
      return Customtext(
        text: lesson.duration,
        fontSize: 12,
      );
    } else if (lesson.lessonType == 'quiz') {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.event_note,
                size: 12,
                color: kSecondaryColor,
              ),
            ),
            TextSpan(
                text: 'Quiz',
                style: TextStyle(fontSize: 12, color: kSecondaryColor)),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.attach_file,
                size: 12,
                color: kSecondaryColor,
              ),
            ),
            TextSpan(
                text: 'Attachment',
                style: TextStyle(fontSize: 12, color: kSecondaryColor)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myCourseId = ModalRoute.of(context).settings.arguments as int;
    final myLoadedCourse =
        Provider.of<MyCourses>(context, listen: false).findById(myCourseId);
    final sections =
        Provider.of<MyCourses>(context, listen: false).sectionitems;
    var lessonCount = 0;
    return Scaffold(
      appBar: CustomAppBarTwo(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                // _activeLesson != null
                //     ? setPageheader(_activeLesson)
                //     : Container(
                //         child: Text('No Lesson Found'),
                //       ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 4.5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: myLoadedCourse.title,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.dstATop),
                        image: new NetworkImage(
                          myLoadedCourse.thumbnail,
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            children: [
                              Container(
                                child: LinearPercentIndicator(
                                  lineHeight: 8.0,
                                  percent:
                                      myLoadedCourse.courseCompletion / 100,
                                  progressColor: Colors.blue,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Customtext(
                                  text:
                                      '${myLoadedCourse.totalNumberOfCompletedLessons}/${myLoadedCourse.totalNumberOfLessons} Lessons are Completed',
                                  fontSize: 14,
                                  colors: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'details') {
                                Navigator.of(context).pushNamed(
                                    CourseDetailScreen.routeName,
                                    arguments: myLoadedCourse.id);
                              } else {
                                Share.share(myLoadedCourse.shareableLink);
                              }
                            },
                            icon: Icon(
                              Icons.more_vert,
                            ),
                            itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text('Course Details'),
                                    value: 'details',
                                  ),
                                  PopupMenuItem(
                                    child: Text('Share this Course'),
                                    value: 'share',
                                  ),
                                ]),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        // return Text(sections[index].title);
                        final section = sections[index];

                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
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
                                lessonCount += 1;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _activeLesson = lesson;
                                    });
                                    lessonAction(lesson);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 30),
                                        width: double.infinity,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                flex: 2,
                                                child: Customtext(
                                                  text: lessonCount.toString(),
                                                  fontSize: 16,
                                                )),
                                            Expanded(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Customtext(
                                                      text: lesson.title,
                                                      fontSize: 14,
                                                      colors: kTextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    getLessonSubtitle(lesson),
                                                  ],
                                                )),
                                            Expanded(
                                              flex: 2,
                                              child: Checkbox(
                                                  value:
                                                      lesson.isCompleted == '1'
                                                          ? true
                                                          : false,
                                                  onChanged: (bool value) {
                                                    print(value);

                                                    setState(() {
                                                      lesson.isCompleted =
                                                          value ? '1' : '0';
                                                      if (value) {
                                                        myLoadedCourse
                                                            .totalNumberOfCompletedLessons += 1;
                                                      } else {
                                                        myLoadedCourse
                                                            .totalNumberOfCompletedLessons -= 1;
                                                      }
                                                      var completePerc = (myLoadedCourse
                                                                  .totalNumberOfCompletedLessons /
                                                              myLoadedCourse
                                                                  .totalNumberOfLessons) *
                                                          100;
                                                      myLoadedCourse
                                                              .courseCompletion =
                                                          completePerc.round();
                                                    });
                                                    Provider.of<MyCourses>(
                                                            context,
                                                            listen: false)
                                                        .toggleLessonCompleted(
                                                            lesson.id,
                                                            value ? 1 : 0)
                                                        .then((_) => CommonFunctions
                                                            .showSuccessToast(
                                                                'Course Progress Updated'));
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                                // return Text(section.mLesson[index].title);
                              },
                              itemCount: section.mLesson.length,
                            )
                          ],
                        );
                      },
                      itemCount: sections.length,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
