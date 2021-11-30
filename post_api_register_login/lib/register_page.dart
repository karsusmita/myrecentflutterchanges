import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/login_page.dart';
import 'package:post_api_register_login/main.dart';
import 'package:post_api_register_login/second.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:post_api_register_login/userLogin.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserLogin? _user;

  bool _isLoading = false;
  var errorMsg;
  var succMsg;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController userIdController = new TextEditingController();
  final TextEditingController confPasswordController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Screen'),
      ),
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
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
            SizedBox(height: 30.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
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
            SizedBox(height: 30.0,),
            TextFormField(
              controller: confPasswordController,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
              ),
            ),
            SizedBox(height: 30.0,),
            RaisedButton(
              onPressed: () async{
                final UserLogin user  = await register(emailController.text, userIdController.text, passwordController.text,  confPasswordController.text);
                print(user);
                setState(() {
                  _user = user;
                });
                register(emailController.text, userIdController.text, passwordController.text,  confPasswordController.text);
              },
              color: Colors.purple,
              child: Text("Register Yourself", style: TextStyle(color: Colors.white70)),
            ),
            errorMsg == null ? Container() : Text(
              "${errorMsg}",
            ),
            _user == null ? Container() : Text(
              ": ${_user!.Email}",
            ),
          ],
        ),
      ),
    );
  }

  Future<UserLogin> register(email, userid, pass, confpass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'userId': userid,
      'password': pass,
      'confirmPassword': confpass
    };
    var jsonResponse = null;
    var decodedJson = null;
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/register"), body: data);
    if(response.statusCode == 201) {
      final String responseString = response.body;
      decodedJson = json.decode(responseString);
      succMsg = decodedJson["Email"];
      Navigator.push(context,MaterialPageRoute(builder: (context) => ScreenWelcome(guestMsg: succMsg)),);
      return userLoginFromJson(responseString);
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
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Second()), (Route<dynamic> route) => false);
        Navigator.push(context,MaterialPageRoute(builder: (context) => ScreenWelcome(guestMsg: succMsg)),);
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

class ScreenWelcome extends StatelessWidget {

  final guestMsg;
  ScreenWelcome({@required this.guestMsg});
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success'),),
      body: Column(
        children:[
          Text('$guestMsg'),
          SizedBox(height: 4.0),
          IconButton(onPressed: (){
            Clipboard.setData(ClipboardData(text: guestMsg));
          }, 
          icon: Icon(
            Icons.content_copy,
            color: Colors.blue,
            
          ),),
          RaisedButton(
          child: Text(
            'Navigate to Login Page',
            style: TextStyle(fontSize: 24.0),
          ),
          onPressed: () {
            _navigateToNextScreen(context);
          },
        ),
        ],
        
      ),
      
    );

  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}


