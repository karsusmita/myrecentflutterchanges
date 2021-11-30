import 'dart:convert';

SecretBody userLoginFromJsons(String str) => SecretBody.fromJson(json.decode(str));


class SecretBody{
  String status;
  Secret secret;
  String createdTime;
  String message;

  SecretBody({
    required this.status,
    required this.secret,
    required this.createdTime,
    required this.message
});

  factory SecretBody.fromJson(Map<String, dynamic> parsedJson){
    return SecretBody(
      status: parsedJson['shape_name'],
      secret: Secret.fromJson(parsedJson['secret'],), 
      createdTime: parsedJson['createdTime'], 
      message: parsedJson['message']
    );
  }
}

class Secret{
  String password;
  String UserName;

  Secret({
    required this.password,
    required this.UserName
});

  factory Secret.fromJson(Map<String, dynamic> json){
    return Secret(
      password: json['password'],
      UserName: json['UserName']
    );
  }
}