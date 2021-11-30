import 'dart:convert';

UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));

String userLoginToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
  UserLogin({
    required this.status,
    required this.message,
    required this.Email
  });

  String status;
  String message;
  String Email;

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    status: json["status"],
    message: json["message"],
    Email: json["Email"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Email": Email,
  };
}