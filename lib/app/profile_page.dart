import 'package:blog_app/app/all_users_post.dart';
import 'package:blog_app/authentication/auth.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  AuthService auth;
  String uid;
  DatabaseServices database;
  ProfilePage({this.auth, this.uid, this.database});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    print('${widget.uid}');
    var data = await widget.database.getUserData(widget.uid);
    setState(() {
      user = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.green),
        ),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await widget.auth.logout();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.exit_to_app,color: Colors.green,),
              
              label: Text('Logout',style: TextStyle(color: Colors.green),))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Icon(Icons.person,color: Colors.white,

                    size: 45,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  user == null
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        )
                      : Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
           
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllUsersPost(database: widget.database, uid: widget.uid),
                    )
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'My Posts',
                      style:
                          TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
