import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Second extends StatefulWidget {

  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  bool _isLoading = false;
  var succMsg;
  var errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              errorMsg == null ? Container() : Text(
              "${errorMsg}",
            ),
              succMsg == null ? Container() : Text(
              "${succMsg}",
            ),
              Text("You have successfully registered"),
              SizedBox(height: 50,),
              OutlinedButton.icon(onPressed: () {}, icon: Icon(Icons.exit_to_app, size: 18,), label: Text("Logout")),
            ],
          ),
        )),
      
    );
  }
  SecondCheck(String email, userid, pass, confpass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'userId': userid,
      'password': pass,
      'confirmPassword': confpass
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/register"), body: data);
    if(response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        succMsg = response.body;
        //print("correct: ${succMsg}");
        sharedPreferences.setString("token", jsonResponse['token']);
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("successfully registered")));
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      print("The error message is: ${response.body}");
    }
  }
}