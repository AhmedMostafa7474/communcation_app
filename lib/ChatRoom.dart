import 'package:communcation_app/PushNotifcation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communcation_app/ConverstionModel1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';

import 'WelcomeScreen.dart';
class chatroom extends StatefulWidget {
  Conversmodel product;
  chatroom(this.product);
  @override
  _chatroomState createState() => _chatroomState(product);
}

class _chatroomState extends State<chatroom> {


  String messageTitle = "Empty";
  String notificationAlert = "alert";

  final ImagePicker _picker = ImagePicker();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Conversmodel product;
  var Message=TextEditingController();
  _chatroomState(this.product);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    loggedinuser=auth.currentUser!;
    var Mobwidth = MediaQuery
        .of(context)
        .size
        .width;
    pr = new ProgressDialog(context);
    return StreamBuilder(
        stream: firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc(product.id).collection("Messages").snapshots(),
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
            final messeges = snapshot.data!.docs;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF73AEF5),
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(product.imgUrl),
                      maxRadius: 20.0,
                    ),
                    SizedBox(width: 5.0,),
                    Text("${product.Username}", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                leading: IconButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> welcomescreen()));
                }, icon: Icon(Icons.arrow_back)),
                titleSpacing: 2.0,
              ),
              body: Stack(
                children: [
                  ListView.builder(
                      itemCount:messeges.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 14),
                          child: Align(
                            alignment:messeges[index]["messageType"] == "receiver"?Alignment.topLeft:Alignment.topRight,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color:messeges[index]["messageType"]  == "receiver"?Colors.grey.shade200:Colors.blue[200]
                                ),
                                padding: EdgeInsets.all(16.0),
                                child:messeges[index]["type"]  == "img"? Container(
                                  height:250 ,
                                  width:250 ,
                                  child: Image(image: NetworkImage(
                                      messeges[index]["messageContent"]),
                                    fit: BoxFit.cover,
                                  ),
                                ):Text(messeges[index]["messageContent"],
                                    style: TextStyle(fontSize: 15))
                          ),
                        ),);
                      }),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10.0, bottom: 10.0, right: 10.0),
                      height: 60.0,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                              var img= File(image!.path);
                              String  time=DateTime.now().toString();
                              //final String path = "assets";
                              //var fileName = basename(image!.path);
                              //final File localImage = await img.copy('$path/$fileName');
                              var storageRef = await FirebaseStorage.instance.ref(loggedinuser.uid +time+ '/Messages');
                              var task = await storageRef.putFile(img);
                              // final ref = FirebaseStorage.instance.ref(loggedinuser.uid + '/profilePicture').child("profilePicture");
                              var url = await FirebaseStorage.instance.ref(loggedinuser.uid+time).child("/Messages").getDownloadURL();
                              setState(() {
                                print("Url : " + url);
                              });
                              await firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc(product.id).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": url.toString(),
                                    "messageType" :"receiver",
                                    "time":DateTime.now(),
                                    "type":"img"
                                  }
                              );
                              await firestore.collection("Users").doc(product.id).collection("Converstions").doc(loggedinuser.uid).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": url.toString(),
                                    "messageType" :"sender",
                                    "time":DateTime.now(),
                                    "type":"img"
                                  }
                              );

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              height: 30,
                              width: 30,
                              child: Icon(
                                  Icons.add
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: Message,
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          FloatingActionButton(
                            onPressed: () {
                              firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc(product.id).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": Message.text,
                                    "messageType" :"receiver",
                                    "time":DateTime.now(),
                                    "type":""
                                  }
                              );
                              firestore.collection("Users").doc(product.id).collection("Converstions").doc(loggedinuser.uid).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": Message.text,
                                    "messageType" :"sender",
                                    "time":DateTime.now(),
                                    "type":""
                                  }
                              );
                              Message.clear();
                            },
                            child: Icon(Icons.send, color: Colors.white,
                              size: 18,),
                            backgroundColor: Colors.blue,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }
    );
  }
}