import 'dart:convert';

DashList userLoginFromJsonss(String str) => DashList.fromJson(json.decode(str));
class DashList {
  final String status;
  final String message;
  final List<output> outputs;

  DashList({required this.status, required this.message, required this.outputs});

  factory DashList.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['outputs'] as List;
    print(list.runtimeType);
    List<output> imagesList = list.map((i) => output.fromJson(i)).toList();


    return DashList(
      status: parsedJson['status'],
      message: parsedJson['message'],
      outputs: imagesList

    );
  }
}

class output {
  final String userId;
  final String lable;
  final String updatedAt;
  final String createdAt;


  output({required this.userId, required this.lable, required this.createdAt, required this.updatedAt});

  factory output.fromJson(Map<String, dynamic> parsedJson){
   return output(
     userId:parsedJson['userId'],
     lable:parsedJson['lable'],
     createdAt:parsedJson['createdAt'],
     updatedAt:parsedJson['updatedAt']
   );
  }
}