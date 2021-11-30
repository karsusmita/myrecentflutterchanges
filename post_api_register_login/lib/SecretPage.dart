import 'package:flutter/material.dart';
import 'package:post_api_register_login/seeDashboard.dart';

import 'bottomsheet.dart';
import 'dashboardsheet.dart';

class SecretPage extends StatelessWidget {
  const SecretPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
        ElevatedButton(
          onPressed: (){
            //showModalBottomSheet(context: context, builder: (context) => bottom_sheet());
            Navigator.push(context,MaterialPageRoute(builder: (context) => bottom_sheet()),);
          },
          child: Text("Create Secret"),
        ),
        ElevatedButton(
          onPressed: (){
            //showModalBottomSheet(context: context, builder: (context) => bottom_sheet());
            Navigator.push(context,MaterialPageRoute(builder: (context) => dashboard_sheet()),);
          },
          child: Text("Fetch Secret"),
        ),
        ElevatedButton(
          onPressed: (){
            //showModalBottomSheet(context: context, builder: (context) => bottom_sheet());
            Navigator.push(context,MaterialPageRoute(builder: (context) => see_dashboard()),);
          },
          child: Text("See the dashboard"),
        ),

        ],
      )
      
    );
  }
}