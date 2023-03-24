class Doctors {
  String? userName;
  String? userType;
  Doctors({required this.userName, required this.userType});
  factory Doctors.fromJson(Map<String, dynamic> json) =>
      Doctors(userName: json['username'], userType: json['usertype']);
}
