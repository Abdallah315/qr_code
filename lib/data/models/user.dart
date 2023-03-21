class User {
  String? id;
  String? email;
  String? userName;

  User({required this.email, required this.id, required this.userName});
  factory User.fromJson(Map<String, dynamic> json) =>
      User(email: json['email'], id: json['id'], userName: json['username']);
}
