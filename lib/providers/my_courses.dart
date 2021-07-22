import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
import '../models/my_course.dart';
import '../constants.dart';
import '../models/course_detail.dart';
import '../models/section.dart';
import '../models/lesson.dart';

class MyCourses with ChangeNotifier {
  List<MyCourse> _items = [];
  List<Section> _sectionItems = [];
  final String authToken;

  MyCourses(this.authToken, this._items);

  List<MyCourse> get items {
    return [..._items];
  }

  List<Section> get sectionitems {
    return [..._sectionItems];
  }

  int get itemCount {
    return _items.length;
  }

  MyCourse findById(int id) {
    return _items.firstWhere((myCourse) => myCourse.id == id);
  }

  Future<void> fetchMyCourses() async {
    var url = BASE_URL + '/api/my_courses?auth_token=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildMyCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  List<MyCourse> buildMyCourseList(List extractedData) {
    final List<MyCourse> loadedCourses = [];
    extractedData.forEach((courseData) {
      loadedCourses.add(MyCourse(
        id: int.parse(courseData['id']),
        title: courseData['title'],
        thumbnail: courseData['thumbnail'],
        price: courseData['price'],
        instructor: courseData['instructor_name'],
        rating: courseData['rating'],
        totalNumberRating: courseData['number_of_ratings'],
        numberOfEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
        courseOverviewUrl: courseData['video_url'],
        courseCompletion: courseData['completion'],
        totalNumberOfLessons: courseData['total_number_of_lessons'],
        totalNumberOfCompletedLessons:
            courseData['total_number_of_completed_lessons'],
      ));
      // print(catData['name']);
    });
    return loadedCourses;
  }

  Future<void> fetchCourseSections(int courseId) async {
    var url =
        BASE_URL + '/api/sections?auth_token=$authToken&course_id=$courseId';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;
      if (extractedData == null) {
        return;
      }

      final List<Section> loadedSections = [];
      extractedData.forEach((sectionData) {
        loadedSections.add(Section(
          id: int.parse(sectionData['id']),
          numberOfCompletedLessons: sectionData['completed_lesson_number'],
          title: sectionData['title'],
          totalDuration: sectionData['total_duration'],
          lessonCounterEnds: sectionData['lesson_counter_ends'],
          lessonCounterStarts: sectionData['lesson_counter_starts'],
          mLesson: buildSectionLessons(sectionData['lessons'] as List<dynamic>),
        ));
      });
      _sectionItems = loadedSections;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  List<Lesson> buildSectionLessons(List extractedLessons) {
    final List<Lesson> loadedLessons = [];

    extractedLessons.forEach((lessonData) {
      loadedLessons.add(Lesson(
        id: int.parse(lessonData['id']),
        title: lessonData['title'],
        duration: lessonData['duration'],
        lessonType: lessonData['lesson_type'],
        videoUrl: lessonData['video_url'],
        summary: lessonData['summary'],
        attachmentType: lessonData['attachment_type'],
        attachment: lessonData['attachment'],
        attachmentUrl: lessonData['attachment_url'],
        isCompleted: lessonData['is_completed'].toString(),
        videoUrlWeb: lessonData['video_url_web'],
        videoTypeWeb: lessonData['video_type_web'],
        vimeoVideoId: lessonData['vimeo_video_id'],
      ));
    });
    // print(loadedLessons.first.title);
    return loadedLessons;
  }

  Future<void> toggleLessonCompleted(int lessonId, int progress) async {
    var url = BASE_URL +
        '/api/save_course_progress?auth_token=$authToken&lesson_id=$lessonId&progress=$progress';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData['course_id'] != null) {
        final myCourse = findById(int.parse(responseData['course_id']));
        myCourse.courseCompletion = responseData['course_progress'];
        myCourse.totalNumberOfCompletedLessons =
            responseData['number_of_completed_lessons'];

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
