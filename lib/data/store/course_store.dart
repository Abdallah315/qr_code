import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/models/all_courses.dart';
import 'package:flutter_qr_code/data/models/all_lectures.dart';
import 'package:flutter_qr_code/presentation/widgets/app_popup.dart';
import 'package:http/http.dart';

import '../models/course.dart';

class CourseStore with ChangeNotifier {
  List<Course> _studentCourses = [];
  List<AllCourses> _allCourses = [];
  List<AllLectures> _allLectures = [];

  List<Course> get studentCourses {
    return _studentCourses;
  }

  List<AllCourses> get allCourses {
    return _allCourses;
  }

  List<AllLectures> get allLectures {
    return _allLectures;
  }

  Future<void> getStudentCourses(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://10.0.2.2:8000/api/v1/courses/current_student_courses/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'JWT $token'
          });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _studentCourses = List<Course>.from(
          responseData['student_courses'].map(
            (item) => Course.fromJson(item),
          ),
        );
      } else {
        AppPopup.showMyDialog(context, response.body.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllCourses(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://10.0.2.2:8000/api/v1/courses/course/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _allCourses = List<AllCourses>.from(
          responseData['Courses']['results'].map(
            (item) => AllCourses.fromJson(item),
          ),
        );
        print('$_allCourses  store');
      } else {
        AppPopup.showMyDialog(context, response.body.toString());
      }
    } catch (e) {
      print('$e from getting all courses');
    }
  }

  Future<void> getAllLectures(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://10.0.2.2:8000/api/v1/lectures/all/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _allLectures = List<AllLectures>.from(
          responseData['results'].map(
            (item) => AllLectures.fromJson(item),
          ),
        );
        print('$_allLectures  store');
      } else {
        AppPopup.showMyDialog(context, response.body.toString());
      }
    } catch (e) {
      print('$e from getting all lectures');
    }
  }

  Future<String> createAttendanceRequest(BuildContext context, String token,
      String courseId, String lectureId, int period) async {
    try {
      Response response = await post(
          Uri.parse(
            'http://10.0.2.2:8000/api/v1/lectures/create/attendancerequest/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'JWT $token'
          },
          body: json.encode({
            "lecture": lectureId,
            "course": courseId,
            "period": period,
          }));
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        String imagePath = responseData['cur_qrcode'][0]['qrcode'];
        print('$imagePath  image path');
        return imagePath;
      } else {
        AppPopup.showMyDialog(context, response.body.toString());
        return 'no image path';
      }
    } catch (e) {
      print('$e from creating attendance req');
      return 'no image path';
    }
  }
}
