import 'dart:async';
import 'dart:io';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/widgets/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateNewPostPage extends StatefulWidget {
  final String uid;
  CreateNewPostPage({this.uid});
  static Widget create({String uid}) {
    return Provider<DatabaseServices>(
      create: (_) => Database(),
      child: CreateNewPostPage(uid: uid),
    );
  }

  @override
  _CreateNewPostPageState createState() => _CreateNewPostPageState();
}

class _CreateNewPostPageState extends State<CreateNewPostPage> {
  String _chosenValue = "-----Post Type------";
  bool loading = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _feesController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _type;
  File _selectedImage;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _feesController.dispose();
    _contentController.dispose();
  }

  _uploadImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = tempImage;
    });
  }

  Future<void> _post(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });
      final database = Provider.of<DatabaseServices>(context, listen: false);
      String title = _titleController.text;
      String fees = _feesController.text;
      String content = _contentController.text;
      String type = _chosenValue;
      if (title == null || content == null ||fees == null|| type == '-----Post Type-----') {
        throw PlatformException(
          code: 'Field empty error',
          details: 'None of the field can be empty',
        );
      } else {
        User user = await database.getUserData(widget.uid);
        print(user.uid);
        print(widget.uid);
        final StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('post_images/${basename(_selectedImage.path)}');
        final StorageUploadTask task =
            firebaseStorageRef.putFile(_selectedImage);
        var link =
            await task.onComplete.then((value) => value.ref.getDownloadURL());
        String datetime = DateTime.now().toIso8601String();
        await database.createPost(
            widget.uid,
            Post(
              title: title,
              fees :fees,
              content: content,
              type: type,
              datetime: datetime,
              image: link,
              firstName: user.firstName,
              lastName: user.lastName,
              email: user.email,
            ));
        Navigator.of(context).pop();
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: backgroundColor,
            title: new Text("${e.code}"),
            content: new Text("${e.details}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'NEW POST',
                      style: TextStyle(color:Colors.green,fontSize: 30, ),

                    )
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  _titleTextField(),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: Colors.green,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.black,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.green,
                      ),
                      value: _chosenValue,
                      isExpanded: true,
                      underline: Container(),
                      items: <String>[
                        '-----Post Type------',
                        'Science',
                        'Arts',
                        'Commerce',
                        'Acedemic',
                        'Non Acedemic',
                        'Entertainment',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  _feesTextField(),
                  SizedBox(height: 15),
                  _addImageButton(),
                  SizedBox(height: 15),
                  _contentTextField(),
                  SizedBox(height: 15),
                  _postButton(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addImageButton() {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: _uploadImage,
        color: Colors.white.withOpacity(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Colors.green,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: <Widget>[
            _selectedImage != null
                ? Text(
                    '${basename(_selectedImage.path)}',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    'Pick Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _postButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.green,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () => _post(context),
        child: Center(
            child: loading
              ? CircularProgressIndicator(
            backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green),
                )
            : Text('POST',
            style: TextStyle(color: Colors.black),)
                ),
      ),
    );
  }

  Widget _contentTextField() {
    return TextFormField(
      controller: _contentController,
      cursorColor: Colors.green,
      style: TextStyle(fontSize: 18, color: Colors.white),
      autocorrect: true,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Content',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _titleTextField() {
    return TextFormField(
      controller: _titleController,
      cursorColor: Colors.green,
      style: TextStyle(fontSize: 18, color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

   Widget _feesTextField() {
    return TextFormField(
      controller: _feesController,
      cursorColor: Colors.green,
      style: TextStyle(fontSize: 18, color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Fees',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
