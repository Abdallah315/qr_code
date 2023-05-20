class CourseInfo {
  String id;
  String? title;
  String? description;
  String? bannerImage;

  CourseInfo(
      {required this.bannerImage,
      required this.description,
      required this.id,
      required this.title});
  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
      bannerImage: json['banner_image'],
      description: json['description'],
      id: json['id'],
      title: json['title']);
}
