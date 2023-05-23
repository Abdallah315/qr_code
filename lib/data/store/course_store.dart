import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/models/all_courses.dart';
import 'package:flutter_qr_code/data/models/all_lectures.dart';
import 'package:flutter_qr_code/data/models/student_report.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/presentation/widgets/app_popup.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';

class CourseStore with ChangeNotifier {
  List<Course> _studentCourses = [];
  StudentReport? _studentReport;
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

  StudentReport? get studentReport {
    return _studentReport;
  }

  Future<void> getStudentCourses(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://134.122.64.234/api/v1/courses/current_student_courses/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _studentCourses = List<Course>.from(
          responseData['student_courses'].map(
            (item) => Course.fromJson(item),
          ),
        );
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStudentReport(
      BuildContext context, String token, String id) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://134.122.64.234/api/v1/students-profiles/attendance_report_by_course/$id/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _studentReport = StudentReport.fromJson(responseData);
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStudentReportForDoctor(BuildContext context, String token,
      String courseId, String studentUsername) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://134.122.64.234/api/v1/students-profiles/attendance_report_by_username_and_course/$courseId/$studentUsername/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _studentReport = StudentReport.fromJson(responseData);
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> createStudentAttendance(
      BuildContext context, String token, String id) async {
    try {
      Response response = await post(
          Uri.parse(
            'http://134.122.64.234/api/v1/students-profiles/create_student_attendance/$id/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
        return false;
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendNotification(BuildContext context, String token,
      String courseId, String title, String subtitle) async {
    try {
      Response response = await post(
        Uri.parse(
          'http://134.122.64.234/api/v1/doctors-profiles/send_notifications/',
        ),
        headers: {
          "Connection": "keep-alive",
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
        },
        body: jsonEncode(
            {"title": title, "body": subtitle, "course_id": courseId}),
      );
      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
        return false;
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> getAllCourses(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://134.122.64.234/api/v1/courses/course/',
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
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
      }
    } catch (e) {
      print('$e from getting all courses');
    }
  }

  Future<void> getAllLectures(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://134.122.64.234/api/v1/lectures/all/',
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
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
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
            'http://134.122.64.234/api/v1/lectures/create/attendancerequest/',
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
        return imagePath;
      } else if (response.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).refreshToken();
        return 'no image path';
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
        return 'no image path';
      }
    } catch (e) {
      print('$e from creating attendance req');
      return 'no image path';
    }
  }
}
