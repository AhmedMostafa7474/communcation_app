import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'LoginScreen1.dart';

class registerscreen extends StatefulWidget {
  @override
  _registerscreenState createState() => _registerscreenState();
}

class _registerscreenState extends State<registerscreen> {

  final emailcontrol = TextEditingController();
  final usernamecontrol = TextEditingController();
  final passwordcontrol = TextEditingController();
  final namecontrol = TextEditingController();
    String email = "",
      password = "",
      username = "",
      name ="";
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
  final _scaffoldkey= GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void getcurrenUser() async
  {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  Future alertDialog(String text, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Register'),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> loginScreen()));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    pr=new ProgressDialog(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Container(
              alignment: Alignment.topLeft,
              child:  IconButton(
                icon: Icon(Icons.arrow_back,size: 30.0,),
                color: Colors.black,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 166),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(100),topRight: Radius.circular(100)),
                  color: Colors.white
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 120.0
                    , horizontal: 40.0
                ),
                child: Form(key: formkey,
                  child: Column
                    (

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                          Text("Signup ", style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                              ,
                              fontFamily: "OpenSans"
                              ,
                              letterSpacing: 1.5
                              ,
                              color: Colors.blue)),
                      Name(),
                      Username(),
                      EmailBox(),
                      PassBox(),
                      Signup1()
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

Column Name() {
  return Column(
    children: <Widget>[
      Container
        (alignment: Alignment.topLeft
          , child: Text("Name",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
                ,
                fontFamily: "OpenSans"
                ,
                letterSpacing: 1.5,
                color: Colors.white60),)
      )
      , SizedBox(height: 10.0,),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: Colors.white54),
        height: 60.0,
        child: TextFormField(
          controller: namecontrol,
          onSaved: (input) => name = input!,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(Icons.supervised_user_circle, color: Colors.blue
            ),
            hintText: "Enter your Fullname",
          ),
        ),
      )
    ],
  );
}

Column Username() {
  return Column(
    children: <Widget>[
      Container
        (alignment: Alignment.topLeft
          , child: Text("Username",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
                ,
                fontFamily: "OpenSans"
                ,
                letterSpacing: 1.5,
                color: Colors.white60),)
      )
      , SizedBox(height: 10.0,),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: Colors.white54),
        height: 60.0,
        child: TextFormField(
          controller: usernamecontrol ,
          onSaved: (input) => username = input!,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(Icons.verified_user, color: Colors.blue
            ),
            hintText: "Enter your Username",
          ),
        ),
      )
    ],
  );
}

Column EmailBox() {
  return Column(
    children: <Widget>[
      Container
        (alignment: Alignment.topLeft
          , child: Text("Email",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
                ,
                fontFamily: "OpenSans"
                ,
                letterSpacing: 1.5,
                color: Colors.white60),)
      )
      , SizedBox(height: 10.0,),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: Colors.white54),
        height: 60.0,
        child: TextFormField(
          controller: emailcontrol,
          onSaved: (input) => email = input!,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(Icons.email, color: Colors.blue
            ),
            hintText: "Enter your email address",
          ),

        ),
      )
    ],
  );
}

Column PassBox() {
  return Column(
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Password",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
              ,
              fontFamily: "OpenSans"
              ,
              letterSpacing: 1.5,
              color: Colors.white60),),
      )
      , SizedBox(height: 10.0,),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: Colors.white54),
        height: 60.0,
        child: TextFormField(
          controller: passwordcontrol,
          onSaved: (input) => password = input!,
          obscureText: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(Icons.lock, color: Colors.blue
            ),
            hintText: "Enter your Password",
          ),
        ),
      )
    ],
  );
}
  Container Signup1() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child:
      RaisedButton(
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
        ),
        color: Colors.blue
        ,
        onPressed: () async {
          setState(() {
            print("pressed");
            print(emailcontrol.text + " " + usernamecontrol.text +
                passwordcontrol.text + namecontrol.text);
          });
          if (emailcontrol.text.isEmpty || usernamecontrol.text.isEmpty ||
              passwordcontrol.text.isEmpty || namecontrol.text.isEmpty) {
            pr.hide();
            // ignore: deprecated_member_use
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black,
                  content: Text("Error Sign in Try Again",
                    style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                  ),
                )
            );
          }
          else {
            final newUser = await auth.createUserWithEmailAndPassword(
                email: emailcontrol.text.trim(),
                password: passwordcontrol.text);
            if (newUser != null) {
              getcurrenUser();
              firestore.collection("Users").doc(newUser.user!.uid).set({
                'id': newUser.user!.uid,
                'name': namecontrol.text,
                'username': usernamecontrol.text,
                'email': emailcontrol.text,
                'password': passwordcontrol.text,
                'PhotoUrl': "",
                'timeCreation': DateTime.now(),
              }).whenComplete(() {
                print("Document add");
                pr.hide();
              });
              firestore.collection("Users").doc(newUser.user!.uid).collection("FriendsRequests").doc("empty").set(
                {

                }
              );
              firestore.collection("Users").doc(newUser.user!.uid).collection("Converstions").doc("empty").set(
                  {

                  }
              );
              await newUser.user!.updateDisplayName(namecontrol.text);
              await newUser.user!.updateEmail(emailcontrol.text);
              await alertDialog("Registration Successfully ! ", context);
            }
          }
        },
        child: Text("Signup", style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
            ,
            fontFamily: "OpenSans"
            ,
            letterSpacing: 1.5
            ,
            color: Colors.black)),),
    );
  }

}