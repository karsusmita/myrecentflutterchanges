import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/login_page.dart';
import 'package:post_api_register_login/register_page.dart';
import 'package:post_api_register_login/secret_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:post_api_register_login/SecretPage.dart';

class dashboard_sheet extends StatefulWidget {

  @override
  _dashboard_sheetState createState() => _dashboard_sheetState();
}

class _dashboard_sheetState extends State<dashboard_sheet> {
  SecretBody? _secretBody;
  bool _isLoading = false;
  bool hidePassword = true;
  var errorMsg;
  var succMsg;
  var succMsg1;
  var succMsg2;
  final TextEditingController tokenController = new TextEditingController();
  final TextEditingController lableController = new TextEditingController();
  final TextEditingController userIdController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Secret Screen'),
      ),
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            TextFormField(
              controller: tokenController,
              decoration: new InputDecoration(
                hintText: "Token",
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
              controller: lableController,
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
              controller: userIdController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "UserId",
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
              onPressed: () async {
                final SecretBody user  = await fetchSecret(tokenController.text, lableController.text, userIdController.text);
                print("fetching details pressed");
                print(user);
                setState(() {
                  _secretBody = user;
                  //_isLoading = true;
                });
                fetchSecret(tokenController.text, lableController.text, userIdController.text);
              },
              child: Text("Fetch Secret", style: TextStyle(color: Colors.black)),
            ),
            errorMsg == null ? Container() : Text(
              "The error is ${errorMsg}",
            ),
            _secretBody == null ? Container() : Text(
              "the user name is ${_secretBody!.secret.UserName}. password is : ${_secretBody!.secret.password}. ${_secretBody!.message}",
            ),
          ],
        ),
      ),
    );
  }

  Future<SecretBody> fetchSecret(token, lable,userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'token': token,
      'lable': lable,
      'userId': userId
    };
    //SignupJson data = SignupJson(userName, password);
    var url = 'http://10.0.2.2:8000/getSecret';
    var jsonResponse = null;
    var response = await http.post(Uri.parse(url),body: data);
    if(response.statusCode == 201) {
      final String responseString = response.body;
      //jsonResponse = json.decode(response.body);
      jsonResponse = json.decode(responseString);
      succMsg1 = jsonResponse["message"];
      succMsg = jsonResponse["secret"];
      succMsg2 = jsonResponse["createdTime"];

      print(jsonResponse);
      //return jsonResponse;
      Navigator.push(context,MaterialPageRoute(builder: (context) => secretFetchedScreen(guestMsg: succMsg, guestMsg1: succMsg1, guestMsg2: succMsg2,)),);
      return userLoginFromJsons(responseString);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        //sharedPreferences.setString("token", jsonResponse['data']['token']);
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
        
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

class secretFetchedScreen extends StatelessWidget {

  final guestMsg;
  final guestMsg1;
  final guestMsg2;
  secretFetchedScreen({@required this.guestMsg, @required this.guestMsg1, @required this.guestMsg2});
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success'),),
      body: Center(
        child: Column(
          children:[
            Text('The Secret is ......: $guestMsg'),
            SizedBox(height: 4.0),
            Text('Created date is......: $guestMsg2'),
            SizedBox(height: 4.0),
            Text('Message......: $guestMsg1'),
            SizedBox(height: 4.0),
          ],
          
        ),
      ),
      
    );

  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
