import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communcation_app/FriendsRequests.dart';
import 'package:communcation_app/Userstatus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'LoginScreen1.dart';

class editprofile extends StatefulWidget {
  @override
  _editprofileState createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
  final _textEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Future<void> _signOut() async {
    loginStatues().writeStatus(false);
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.clear();
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
   var screensize=MediaQuery.of(context).size;
    loggedinuser=auth.currentUser!;
    return StreamBuilder(
        stream: firestore.collection("Users").doc(loggedinuser.uid).snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(
    child: SpinKitCircle(
    color: Colors.white,
    size: 100.0,
    ),
    );
    }
    else {
    String id="0";
    String? photo=loggedinuser.photoURL;
    return  Scaffold(
     backgroundColor: Colors.transparent ,
        body: Stack(
          children: <Widget>[
        Container(
        height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.transparent
          ),
         child: Column(
           children: [
             SizedBox( height: 15.0),
             InkWell(
               child: Center(
                 child: Container(
                   width: screensize.height*0.31,
                   height: screensize.height*0.31,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     image: DecorationImage(
                         image: NetworkImage(photo??"https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                         fit: BoxFit.fill
                     ),
                   ),
                 ),
               ),
               onTap: ()async
               {
                   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                   var img= File(image!.path);
                 var storageRef = FirebaseStorage.instance.ref(loggedinuser.uid + '/profilePicture');
                 await storageRef.putFile(img);
                 var url = await FirebaseStorage.instance.ref(loggedinuser.uid).child("/profilePicture").getDownloadURL();
                  setState(() {
                    print("Url : " + url);
                  });
                   await loggedinuser.updatePhotoURL(url);
                   setState(() {
                     photo=loggedinuser.photoURL;
                   });
                   await firestore.collection('Users')
                       .doc(loggedinuser.uid)
                       .update({
                     'PhotoUrl': loggedinuser.photoURL,
                   });
               },
             )
           ],
         ),
        ),
        Padding(
        padding: EdgeInsets.only(top: screensize.height*0.36),
    child: Container(
      height: screensize.height*0.5,
    width: screensize.height*0.5,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(100),topRight: Radius.circular(100)),
    color: Colors.white
    ),
    child: SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(
    ),
     padding: EdgeInsets.symmetric(
     vertical: 60.0
     , horizontal: 40.0
     ),
      child: Column
        (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fullname",style: TextStyle(
            color: Colors.grey,
            fontSize: 15.5
          ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${loggedinuser.displayName}",style: TextStyle(
                  color: const Color(0xFF00796B),
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold
                  ,
                  fontFamily: "Helvetica"
                  ,
                  letterSpacing: 1.2
                  ,
                ),)
                ,
                InkWell(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: const Color(0xFF00796B),
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200, // height modal bottom
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.89,
                                child: TextFormField(
                                  controller: _textEditingController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color:const Color(0xFF00796B),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(0, 1),
                                          spreadRadius: -2,
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      child: Center(
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontStyle:
                                            FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        setState(() async {
                                          await loggedinuser.updateDisplayName(_textEditingController.text);
                                          await firestore.collection('Users')
                                              .doc(loggedinuser.uid)
                                              .update({
                                            'name': _textEditingController.text,
                                          });
                                          Navigator.pop(context);
                                        });

                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    child: Text(
                                      'Close  ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () =>
                                        Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),     SizedBox(height: 11.0,),

          SizedBox(height: 15.0,),
          Text("Chat Requests",style: TextStyle(
              color: Colors.grey,
              fontSize: 15.5
          ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> friendsrequests()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat Requests", style: TextStyle(
                  color: const Color(0xFF00796B),
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold
                  ,
                  fontFamily: "Helvetica"
                  ,
                  letterSpacing: 1.2
                  ,
                ),
                ),
                Icon(Icons.arrow_forward_ios,color: const Color(0xFF00796B),)
              ],
            ),
          ),
          SizedBox(height: 15.0,),
          Text("Contact US",style: TextStyle(
              color: Colors.grey,
              fontSize: 15.5
          ),
          ),
         TextButton(
           onPressed: () {

           },
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                    "Contact Us", style: TextStyle(
                    color: const Color(0xFF00796B),
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold
                    ,
                    fontFamily: "Helvetica"
                    ,
                    letterSpacing: 1.2
                    ,
                  ),
                  ),
               Icon(Icons.arrow_forward_ios,color: const Color(0xFF00796B),)
             ],
           ),
         )
          ,
          SizedBox(height: 11.0,),

          SizedBox(height: 15.0,),
          SizedBox(
            height: 50,
            width: 150,
            child: TextButton(onPressed: (){
              _signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> loginScreen()));
            }, child: Text(
              "Logout"
              , style: TextStyle(
              color: Colors.white,
              fontSize: 19.0,
              fontWeight: FontWeight.bold
              ,
              fontFamily: "Helvetica"
              ,
              letterSpacing: 1.2
              ,
            ),
            )
                ,style: TextButton.styleFrom(
                    primary: Colors.red
                        ,backgroundColor: const Color(0xFF00796B)
                    ,
                )
            ),
          )
        ],
    ),
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