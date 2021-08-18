
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communcation_app/ConverstionModel1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'WelcomeScreen.dart';


class friendsSearch extends StatefulWidget {
  List<String>ids;
  friendsSearch(this.ids);

  @override
  _friendsSearchState createState() => _friendsSearchState(ids);
}

class _friendsSearchState extends State<friendsSearch> {
  Future alertDialog(String text, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Done'),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
 static var docc=false;
  List<String> ids;
  _friendsSearchState(this.ids);

  @override
  Widget build(BuildContext context) {
    loggedinuser=auth.currentUser!;
    var Mobwidth = MediaQuery
        .of(context)
        .size
        .width;
    pr = new ProgressDialog(context);
    return StreamBuilder(
      stream: firestore.collection("Users").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitCircle(
              color: Colors.white,
              size: 100.0,
            ),
          );
        }
        else {
          final users = snapshot.data!.docs;
          List<Conversmodel>Coverstions = [];
          for (var user in users) {
            bool flag=true;
            final String id=user["id"];
            final String PhotoUrl =user["PhotoUrl"];
            final String name = user["name"];
            final String about = "pp";
            var C = Conversmodel(PhotoUrl, name, id, about);
            if(user["id"]!=loggedinuser.uid&&!ids.contains(user["id"])) {
              Coverstions.add(C);
            }
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor:Color(0xFF73AEF5),
              title: Text("Search Friends"),
              leading: Icon(Icons.search),
              titleSpacing: 2.0,
            ),
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.home ,color: Colors.blue,),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> welcomescreen()));
                });
              },
            ),
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 0.9,
                  childAspectRatio: 1.38
              ), itemCount: Coverstions.length
              , itemBuilder: (context, index) =>
                GestureDetector(
                    child: Card(context, Coverstions[index])),
            ),
          );
        }
      },
    );
  }

  Container Card(BuildContext context, products) {
    final Conversmodel product1 = products;
    bool _isButtonDisabled =false;

    //var Mobwidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage("${product1.imgUrl}"),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                SizedBox(width: 12.0,),
                Text("${product1.Username}", style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Segoe UI'
                ),),
                SizedBox(width: 19.0,),
          SizedBox(
            height: 50.0,
            width: 150.0,
            child: TextButton(onPressed: ()async{
              _isButtonDisabled ? null : await firestore.collection("Users").doc(product1.id).collection("FriendsRequests").doc(loggedinuser.uid).set(
                  {
                    'id': loggedinuser.uid,
                    'name': loggedinuser.displayName,
                    'PhotoUrl': loggedinuser.photoURL,
                  }
              );
              await alertDialog("Request is Sent !", context);
              setState(() {
               // _isButtonDisabled=true;
                ids.add(product1.id);
              });

            }
            ,
            child: Text(_isButtonDisabled ? "Request Sent" :"Add Friend",style: TextStyle(
                color: Colors.white
            ),),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue
            ),),
          )
          ,
        ],
      ),
    );
  }
}