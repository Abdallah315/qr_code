import 'package:flutter_qr_code/data/models/course_info.dart';

class Course {
  String? courseId;
  CourseInfo courseInfo;

  Course({required this.courseInfo, required this.courseId});
  factory Course.fromJson(Map<String, dynamic> json) => Course(
      courseInfo: CourseInfo.fromJson(json['course_info']),
      courseId: json['course_id']);
}
