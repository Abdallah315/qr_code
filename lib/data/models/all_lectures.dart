class AllLectures {
  String? title;
  String? description;
  String? floor;
  int? lectureNum;
  String? id;

  AllLectures(
      {required this.description,
      required this.title,
      required this.floor,
      required this.lectureNum,
      required this.id});
  factory AllLectures.fromJson(Map<String, dynamic> json) => AllLectures(
      description: json['description'],
      title: json['title'],
      id: json['id'],
      floor: json['floor'],
      lectureNum: json['lecture_no']);
}
