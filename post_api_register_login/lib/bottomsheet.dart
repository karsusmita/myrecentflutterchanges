import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/register_page.dart';
import 'package:post_api_register_login/signupJson.dart';
import 'package:post_api_register_login/userCreateSecret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:post_api_register_login/SecretPage.dart';
import 'package:post_api_register_login/login_page.dart';

import 'main.dart';

class bottom_sheet extends StatefulWidget {

  @override
  _bottom_sheetState createState() => _bottom_sheetState();
}

class _bottom_sheetState extends State<bottom_sheet> {
  bool _isLoading = false;
  bool hidePassword = true;
  var errorMsg;
  final TextEditingController userIdController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController tokenController = new TextEditingController();
  final TextEditingController labelController = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Secret Screen'),
      ),
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            TextFormField(
              controller: tokenController,
              decoration: new InputDecoration(
                hintText: "token",
                fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: labelController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "Lable",
                fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: usernameController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "User name",
                fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "Password",
                fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: userIdController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "User ID",
                fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
              ),
            ),
            FlatButton(
              onPressed: () {
                print("Submit pressed");
                setState(() {
                  _isLoading = true;
                });
                createSecret(tokenController.text, labelController.text, usernameController.text, passwordController.text, userIdController.text);
              },
              child: Text(" Submit ", style: TextStyle(color: Colors.black)),
            ),
            errorMsg == null? Container(): Text(
              "${errorMsg}",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String> createSecret(String token, lable, UserName, password, userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //UserCreateSecret data = UserCreateSecret(token: token, lable: lable, key: );
    var url = 'http://10.0.2.2:8000/createSecret';
    //String body = jsonEncode(data); 
    //Map bodyMap = jsonDecode(body);  
    //Map bodyData = { 
      //"token" : token,
      //"lable" : lable,      // where var store <String, dynamic> data as your demand
      //"key" : bodyMap,
      //"userId": userId
//};
    Map data = {
      'token': token,
      'lable': lable,
      'key': {
        'UserName': UserName,
        'password': password
      },
      'userId': userId
    };
    //print(bodyData);
    //var bodyDatas = null;
    //print(data);
    String bodyDatas = json.encode(data);
    String bodydataa = bodyDatas;
    //print(bodyDatas);
    print(bodyDatas);

    var jsonResponse = null;
    var response = await http.post(Uri.parse(url),body: data);
    if(response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        //sharedPreferences.setString("token", jsonResponse['data']['token']);
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
        //Navigator.push(context,MaterialPageRoute(builder: (context) => DashboardScreen()),);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      return errorMsg;
      print("The error message is: ${response.body}");
    }
  }

}



