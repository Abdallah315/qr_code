class CourseInfo {
  String? title;
  String? description;
  String? bannerImage;

  CourseInfo(
      {required this.bannerImage,
      required this.description,
      required this.title});
  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
      bannerImage: json['banner_image'],
      description: json['description'],
      title: json['title']);
}
