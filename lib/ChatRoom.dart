
import 'dart:convert';

import 'package:http/http.dart' as http;
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
import 'package:auto_size_text/auto_size_text.dart';
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
  var FcmUrl = 'https://fcm.googleapis.com/fcm/send';
  var FcmKey="AAAArLp9z98:APA91bFwDk2pmd6Fs0lUtoxfAKqC7OyY329ZqgTVKCxKWx_hYutJUel47neNtMKGjnJWU5Ro8znfCsl1Y3u7O0wmv9QXIgjVqI-yj2e_ftDVsbG9tU7wlKqhD6wx-x77C-hTKsE8vWe8";
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Conversmodel product;
  var Message=TextEditingController();
  _chatroomState(this.product);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
  String? Token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();

  }
  void load()async
  {
    _firebaseMessaging.subscribeToTopic('all');
    final data= await firestore.collection("Users").doc(product.id).get();
    print("data2" +data.data()!["Token"]);
    Token=data.get("Token");
}
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
                backgroundColor: const Color(0xFF00796B),
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
                leading: IconButton(onPressed: () async {
                  await firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc(product.id).collection("Messages").doc(messeges[messeges.length-1].id).update(
                    {
                      "seen":"true"
                    }
                  );
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back)),
                titleSpacing: 2.0,
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: ListView.builder(
                        itemCount:messeges.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 14),
                            child: Align(
                              alignment:messeges[index]["messageType"] == "receiver"?Alignment.topLeft:Alignment.topRight,
                              child: Row(
                                mainAxisAlignment:messeges[index]["messageType"] == "receiver"?MainAxisAlignment.start:MainAxisAlignment.end,
                                children: [
                                  messeges[index]["messageType"] == "receiver"?  CircleAvatar(
                                    backgroundImage: NetworkImage(product.imgUrl),
                                    maxRadius: 20.0,
                                  ):SizedBox(width: 0.0,),
                                  SizedBox(width: 2.0,),
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              color:messeges[index]["type"]  == "img"?Colors.transparent:messeges[index]["messageType"]  == "receiver"?Colors.grey.shade200:const Color(0xFF00796B)
                                          ),
                                          padding: EdgeInsets.all(16.0),
                                          child:messeges[index]["type"]  == "img"? Container(
                                            height:250 ,
                                            width:250 ,
                                            child: Image(image: NetworkImage(
                                                messeges[index]["messageContent"]),
                                              fit: BoxFit.cover,
                                            ),
                                          ):
                                              Container(
                                                child: AutoSizeText(messeges[index]["messageContent"],
                                                              style: TextStyle(fontSize: 15,
                                                              color: messeges[index]["messageType"]  == "receiver"?Colors.black:Colors.white
                                                              ,),
                                                           maxLines: 20,
                                                           overflow: TextOverflow.ellipsis,
                                                        ),
                                              ),
                            ),
                                    ],
                                  ),
                                ],
                              ),
                          ),);
                        }),
                  ),

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
                              var storageRef = await FirebaseStorage.instance.ref(loggedinuser.uid +time+ '/Messages');
                              var task = await storageRef.putFile(img);
                              var url = await FirebaseStorage.instance.ref(loggedinuser.uid+time).child("/Messages").getDownloadURL();
                              setState(() {
                                print("Url : " + url);
                              });
                              await firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc(product.id).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": url.toString(),
                                    "messageType" :"sender",
                                    "time":DateTime.now(),
                                    "type":"img",
                                    "seen": "false"
                                  }
                              );
                              await firestore.collection("Users").doc(product.id).collection("Converstions").doc(loggedinuser.uid).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": url.toString(),
                                    "messageType" :"receiver",
                                    "time":DateTime.now(),
                                    "type":"img",
                                    "seen": "false"
                                  }
                              );
                              var response = await http.post(Uri.parse(FcmUrl),
                                  body: jsonEncode({
                                    "to": Token,
                                    "priority": "high",
                                    "notification": {"title": "${loggedinuser.displayName}", "body": "Message : Sent a Photo"}
                                  }),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'key=$FcmKey'
                                  });
                              print(response.statusCode);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF00796B),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              height: 30,
                              width: 30,
                              child: Icon(
                                  Icons.add
                                      ,color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 20,
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
                            onPressed: () async {
                              firestore.collection("Users").doc(loggedinuser.uid).collection("Converstions").doc(product.id).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": Message.text,
                                    "messageType" :"sender",
                                    "time":DateTime.now(),
                                    "type":"text",
                                   "seen": "false"
                                  }
                              );
                              firestore.collection("Users").doc(product.id).collection("Converstions").doc(loggedinuser.uid).collection("Messages").doc(DateTime.now().toString()).set(
                                  {
                                    "messageContent": Message.text,
                                    "messageType" :"receiver",
                                    "time":DateTime.now(),
                                    "type":"text",
                                    "seen": "false"
                                  }
                              );

                              var response = await http.post(Uri.parse(FcmUrl),
                                  body: jsonEncode({
                                    "to": Token,
                                    "priority": "high",
                                    "notification": {"title": "${loggedinuser.displayName}", "body":" Message : ${Message.text}"}
                                  }),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'key=$FcmKey'
                                  });
                              if (response.statusCode == 200) {
                              } else {
                                print(Token);
                                print(response.reasonPhrase);
                              }
                              Message.clear();
                            },
                            child: Icon(Icons.send, color: Colors.white,
                              size: 18,),
                            backgroundColor: const Color(0xFF00796B),
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