import 'package:blog_app/models/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FullBlogPost extends StatefulWidget {
  final Post post;

  FullBlogPost({@required this.post});
  @override
  _FullBlogPostState createState() => _FullBlogPostState();
}

class _FullBlogPostState extends State<FullBlogPost> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          '${widget.post.type}',
          style: TextStyle(color: Colors.green),
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                      Image.network('${widget.post.image}', fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      '${widget.post.title}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Fees: Rs.${widget.post.fees}",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20,color: Colors.green),
                      
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Description",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20,color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${widget.post.content}",
                      style: TextStyle(fontSize: 20,color: Colors.green),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      color: Colors.green.withOpacity(1),
                      semanticContainer: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'The Post Was Written By: ',
                              style: TextStyle(fontSize: 15,color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Name: ${widget.post.firstName} ${widget.post.lastName}',
                              style: TextStyle(fontSize: 15,color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Email: ${widget.post.email}',
                              style: TextStyle(fontSize: 15,color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
