import 'package:flutter_qr_code/data/models/doctors.dart';

class AllCourses {
  String? title;
  String? description;
  String? bannerImage;
  String? id;
  List<Doctors>? doctors;

  AllCourses(
      {required this.bannerImage,
      required this.description,
      required this.title,
      required this.doctors,
      required this.id});
  factory AllCourses.fromJson(Map<String, dynamic> json) => AllCourses(
        bannerImage: json['banner_image'],
        description: json['description'],
        title: json['title'],
        id: json['id'],
        doctors: List<Doctors>.from(
          json['doctors'].map(
            (item) => Doctors.fromJson(item),
          ),
        ),
      );
}
