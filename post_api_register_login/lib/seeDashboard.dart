import 'package:flutter/material.dart';
import 'package:post_api_register_login/dashList_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:post_api_register_login/login_page.dart';
import 'package:post_api_register_login/register_page.dart';
import 'package:post_api_register_login/secret_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:post_api_register_login/SecretPage.dart';

class see_dashboard extends StatefulWidget {
  const see_dashboard({ Key? key }) : super(key: key);

  @override
  _see_dashboardState createState() => _see_dashboardState();
}

class _see_dashboardState extends State<see_dashboard> {
  DashList? _dashList;
  bool _isLoading = false;
  bool hidePassword = true;
  var errorMsg;
  var succMsg;
  var succMsg1;
  var succMsg2;
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
              controller: userIdController,
              decoration: new InputDecoration(
                hintText: "user ID",
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
                final DashList user  = await dashboardList(userIdController.text);
                print("fetching details pressed");
                print(user);
                setState(() {
                  _dashList = user;
                  //_isLoading = true;
                });
                dashboardList(userIdController.text);
              },
              child: Text("get the dashboard list ", style: TextStyle(color: Colors.black)),
            ),
            errorMsg == null ? Container() : Text(
              "The error is ${errorMsg}",
            ),
            _dashList == null ? Container() : Text(
              "the user name is ${_dashList!.message}",
            ),
          ],
        ),
      ),
    );
  }

  Future<DashList> dashboardList(userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'userId': userId
    };
    //SignupJson data = SignupJson(userName, password);
    var url = 'http://10.0.2.2:8000/getUsersSecret';
    var jsonResponse = null;
    var response = await http.post(Uri.parse(url),body: data);
    if(response.statusCode == 201) {
      final String responseString = response.body;
      //jsonResponse = json.decode(response.body);
      jsonResponse = json.decode(responseString);
      succMsg = jsonResponse["output"];

      print(jsonResponse);
      //return jsonResponse;
      Navigator.push(context,MaterialPageRoute(builder: (context) => secretFetchedScreen(guestMsg: succMsg)),);
      return userLoginFromJsonss(responseString);
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
            Text('The output is ......: $guestMsg'),
          ],
          
        ),
      ),
      
    );

  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
