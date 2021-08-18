import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communcation_app/ChatRoom.dart';
import 'package:communcation_app/ConverstionModel1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'FriendsSearch.dart';
import 'WelcomeScreen.dart';


class homescreen extends StatefulWidget {
  @override
  _homescreenState createState() => _homescreenState();
}
class _homescreenState extends State<homescreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    loggedinuser=auth.currentUser!;
   // initState();
    var Mobwidth = MediaQuery
        .of(context)
        .size
        .width;
    pr = new ProgressDialog(context);
    return StreamBuilder(
      stream: firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").snapshots(),
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
          firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc("empty").delete();
          String id="0";
          final users = snapshot.data!.docs;
          List<Conversmodel>Coverstions = [];
          List<String>Ids=[];
          for (var user in users) {
            id=user["id"];
            final String imgUrl = user["PhotoUrl"];
            final String Username = user["name"];
            final String about ="" ;
            var C = Conversmodel(imgUrl, Username, id, about);
            Coverstions.add(C);
            Ids.add(id);
          }
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add ,color: Colors.blue,),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> friendsSearch(Ids)));
                });
              },
            ),
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                childAspectRatio: 4.5,
                mainAxisSpacing: 0.7
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

  InkWell Card(BuildContext context, products) {
    final Conversmodel product1 = products;
    //var Mobwidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>chatroom(product1)));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("${product1.Username}", style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Segoe UI'
                  ),),
                  SizedBox(width: 5.0,),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage("${product1.imgUrl}"??""),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ]
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text("${product1.about} ", style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Segoe UI'
              ),),
            )
            ,
          ],
        ),
      ),
    );
  }
}