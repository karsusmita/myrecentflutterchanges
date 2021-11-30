   
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:post_api_register_login/SecretPage.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  bool hidePassword = true;
  var errorMsg;
  final TextEditingController userIdController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            TextFormField(
              controller: userIdController,
              decoration: new InputDecoration(
                hintText: "User ID",
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
            FlatButton(
              onPressed: () {
                print("Login pressed");
                setState(() {
                  _isLoading = true;
                });
                signIn(userIdController.text, passwordController.text);
              },
              child: Text("Sign In", style: TextStyle(color: Colors.black)),
            ),
            errorMsg == null? Container(): Text(
              "${errorMsg}",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Not have an account? Create one,,,',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => RegisterPage()), (Route<dynamic> route) => false);
              },
              elevation: 0.0,
              color: Colors.purple,
              child: Text("Register", style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  signIn(String userid, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'userId': userid,
      'password': pass
    };
    print(data);
    var jsonResponse = null;
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/login"),body: data);
    if(response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        //sharedPreferences.setString("token", jsonResponse['data']['token']);
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
        Navigator.push(context,MaterialPageRoute(builder: (context) => DashboardScreen()),);
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

class DashboardScreen extends StatelessWidget {
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboars Screen'),
        actions: <Widget>[
          RaisedButton(
            child: Text(
            'Logout',
            style: TextStyle(fontSize: 20.0),
          ),
            onPressed: () {
              _navigateBackToLogintScreen(context);

          })
        ],
      ),
      body: SecretPage(),
      //body: Text('Welcome to the Dashboard screen'),
    );
  }
  void _navigateBackToLogintScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

