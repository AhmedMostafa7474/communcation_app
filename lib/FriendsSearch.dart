
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
  List<String>idds;
  friendsSearch(this.idds);

  @override
  _friendsSearchState createState() => _friendsSearchState();
}

class _friendsSearchState extends State<friendsSearch> {
  Future Ids()async
  {
    SharedPreferences s =await SharedPreferences.getInstance();
   setState(() {
     idscon=s.getStringList("Idsconv")!;
     idsreq=s.getStringList("IdsRequest")!;
   });
  }
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
  late List<String> idscon;
  List<String> idsreq=[];
int n=0;
  @override
  Widget build(BuildContext context) {
    loggedinuser=auth.currentUser!;
    var Mobwidth = MediaQuery
        .of(context)
        .size
        .width;
    pr = new ProgressDialog(context);
    while(n==0) {
      Ids();
      n++;
    }
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
          List<String> IDDs=[];
          for (var user in users) {
            bool flag=true;
            final String id=user["id"];
            final String PhotoUrl =user["PhotoUrl"];
            final String name = user["name"];
            final String about = "pp";
            var C = Conversmodel(PhotoUrl, name, id, about);
            if(user["id"]!=loggedinuser.uid&&!idscon.contains(user["id"])&&!idsreq.contains(user["id"])) {
              Coverstions.add(C);
              IDDs.add(id);
            }
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor:const Color(0xFF00796B),
              title: Text("Search Friends"),
              leading: Icon(Icons.search),
              titleSpacing: 2.0,
            ),
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.home ,color: const Color(0xFF00796B),),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> welcomescreen()));
                });
              },
            ),
            body: Stack(
              children: <Widget>[
            Container(
            height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF00897B),
                    Color(0xFF00796B),
                    Color(0xFF00694C),
                    Color(0xFF004D40),
                  ], stops: [0.3, 0.4, 0.7, 0.9]
                    ,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
              ),
            ),  IDDs.isEmpty?Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height:500,
                      width: 500,
                      child: Column(
                        children: [
                          Icon(Icons.person_add_sharp,size: 130,color: Colors.white,),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("No Suggestions Available",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 21),),
                        ],
                      ),
                    ) ): GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 0.9,
                  childAspectRatio: 1.38
              ), itemCount: Coverstions.length
              , itemBuilder: (context, index) =>
                GestureDetector(
                    child: Card(context, Coverstions[index])),
            )
            ]
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
                    color: Colors.white,
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
              SharedPreferences s=await SharedPreferences.getInstance();
              setState(() {
                idsreq.add(product1.id);
                s.setStringList("IdsRequest", idsreq);
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