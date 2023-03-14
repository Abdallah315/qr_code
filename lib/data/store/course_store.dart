import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_qr_code/presentation/widgets/app_popup.dart';
import 'package:http/http.dart';

import '../models/course.dart';

class CourseStore with ChangeNotifier {
  List<Course> _studentCourses = [];

  List<Course> get studentCourses {
    return _studentCourses;
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
}
