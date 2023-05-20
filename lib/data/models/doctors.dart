class Doctors {
  String userName;
  Doctors({required this.userName});
  factory Doctors.fromJson(Map<String, dynamic> json) =>
      Doctors(userName: json['username']);
}
