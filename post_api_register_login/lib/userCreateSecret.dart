class UserCreateSecret {
  String? token;
  String? lable;
  Key? key;
  String? userId;

  UserCreateSecret({required this.token, required this.lable, required this.key, required this.userId});

   UserCreateSecret.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    lable = json['lable'];
    key = (json['key'] != null ? new Key.fromJson(json['key']) : null)!;
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['lable'] = this.lable;
    if (this.key != null) {
      data['key'] = this.key!.toJson();
    }
    data['userId'] = this.userId;
    return data;
  }
}

class Key {
  String? userName;
  String? password;

  Key({required this.userName, required this.password});

  Key.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['password'] = this.password;
    return data;
  }
}