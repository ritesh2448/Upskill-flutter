import 'package:blog_app/app/create_new_post_page.dart';
import 'package:blog_app/app/post_view_card.dart';
import 'package:blog_app/app/profile_page.dart';
import 'package:blog_app/app/search.dart';
import 'package:blog_app/authentication/auth.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:blog_app/signin/register.dart';
import 'package:blog_app/widgets/page_view_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final database = Provider.of<DatabaseServices>(context, listen: false);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Upskill',
          style: TextStyle(
            color: Colors.green,
            fontFamily: '',
            fontSize: 35,
          ),
        ),
        actions: <Widget>[
          StreamBuilder<User>(
              stream: auth.onAuthStateChanged,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User user = snapshot.data;
                  if (user == null) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register.create(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Icon(
                              Icons.person,
                              color: Colors.green,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  User userData;
                  database.getUserData(user.uid).then((value) => user = value);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(auth: auth, uid: user.uid, database: database,),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Your Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Icon(
                            Icons.person,
                            color: Colors.green,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Icon(
                        Icons.person,
                        color: Colors.green,
                        size: 30,
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
      body: StreamBuilder<List<Post>>(
          stream: database.getAllPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var posts = snapshot.data;
              if (posts.isEmpty) {
                return Center(
                  child: Text(
                    'No Posts yet',
                    style: TextStyle(color: Colors.green, fontSize: 30),
                  ),
                );
              }
              posts.sort((a, b) {
                var adate =
                    a.datetime; //before -> var adate = a.expiry;
                var bdate = b.datetime; //var bdate = b.expiry;
                return -adate.compareTo(bdate);
              });
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/15,
                  color: Color.fromARGB(255, 21, 35, 55),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5,5,5,5),
                    child: FlatButton.icon(
                      color: Colors.white,
                      icon: Icon(Icons.search,
                        color: Colors.grey,
                      ),
                      label: Text("Search for clases",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SearchPost(),
                        ));
                      },
                    ),
                  ),
                ),
                        Container(
                          width: screenWidth,
                          height: screenWidth * 9 / 16,
                          child: PageViewCard(post: posts),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'All Posts',
                                style: TextStyle(color: Colors.green, fontSize: 35),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                                size: 40,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: listViewBuilder(posts: posts),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          }),
      floatingActionButton: StreamBuilder<User>(
          stream: auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User user = snapshot.data;
              if (user == null) {
                return FloatingActionButton(
                  tooltip: 'Create A Post',
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register.create(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 35,
                    color: Colors.green.withOpacity(0.7),
                  ),
                );
              }
              return FloatingActionButton(
                tooltip: 'Create A Post',
                backgroundColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateNewPostPage.create(uid: user.uid),
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.green.withOpacity(0.7),
                ),
              );
            }
            return FloatingActionButton(
              tooltip: 'Create A Post',
              backgroundColor: Colors.black,
              onPressed: () {},
              child: Icon(
                Icons.add,
                size: 35,
                color: Colors.green.withOpacity(0.7),
              ),
            );
          }),
    );
  }

  Widget listViewBuilder({List<Post> posts}) {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostViewCard(post: posts[index]);
        },
      ),
    );
  }
}
