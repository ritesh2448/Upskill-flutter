import 'package:blog_app/app/post_view_card.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class SearchPost extends StatefulWidget {


  SearchPost();
  @override
  _SearchPostState createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  String value = "";

  void onSearch(String val){
    setState(() {
      value = val;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for Clases",style: TextStyle(color: Colors.green),),
        elevation: 0.0,
        backgroundColor:  Colors.black,
      ),



      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(5,5,5,5),
            width: double.infinity,
            height: MediaQuery.of(context).size.height/15,
            color: Colors.green,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: TextFormField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
              ),
            ),
          ),
          Expanded( 
            child: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: FutureBuilder(
                  builder: (BuildContext context, snapshot){
                    if(snapshot.data==null){
                      return SizedBox();
                    }
                    List<dynamic> result = snapshot.data;
                    for(var i in result)
                    {
                      }
                    return Column(
                      children: result.map((e) {
                        if (e.runtimeType != String)
                     { return PostViewCard(post: e as Post,);}
                     else{
                       return SizedBox();
                     }
                      }).toList(),
                    );
                  },
                  future: Database().search_filter(value.trim()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}






class SearchResultCards extends StatelessWidget {


  String username;
  String userID;
  String imageURL;
  String myID;
  String otherID;

  CollectionReference category;
  SearchResultCards({this.username, this.otherID, this.imageURL});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () async{
        //var mid = await DatabaseService().user.doc(otherID).get().then((value) => value);
        Navigator.push(context, MaterialPageRoute(

          builder: (context) => SizedBox(),
        ));

      },
      child: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
            height: MediaQuery.of(context).size.height/10,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/5,
                  child: Image(image:  NetworkImage(imageURL),),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(otherID,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, thickness: 1,)
        ],
      ),
    );
  }
}