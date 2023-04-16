class StudentReport {
  int lectureCount;
  int sectionCount;
  double lecturePercent;
  double sectionPercent;
  StudentReport(
      {required this.lectureCount,
      required this.lecturePercent,
      required this.sectionCount,
      required this.sectionPercent});

  factory StudentReport.fromJson(Map<String, dynamic> json) => StudentReport(
      lectureCount: json['lectures_count'],
      lecturePercent: json['lectures_percent'],
      sectionCount: json['sections_count'],
      sectionPercent: json['sections_percent']);
}
