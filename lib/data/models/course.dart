import 'package:flutter_qr_code/data/models/course_info.dart';

class Course {
  String? id;
  CourseInfo? courseInfo;

  Course({required this.courseInfo, required this.id});
  factory Course.fromJson(Map<String, dynamic> json) => Course(
      courseInfo: CourseInfo.fromJson(json['course_info']), id: json['id']);
}
