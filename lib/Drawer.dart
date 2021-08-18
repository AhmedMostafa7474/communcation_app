import 'package:communcation_app/LoginScreen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'WelcomeScreen.dart';
Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
//final String? Name =FirebaseAuth.instance.currentUser!.displayName;
Drawer drawer(BuildContext context)
{
return Drawer
(

child: ListView
(
  padding: EdgeInsets.zero,children: <
  Widget>[
  DrawerHeader
  (
  decoration: BoxDecoration
  (
        color: Colors.blue,
  )
      ,
    child: Text("knknl"),
)
,
ListTile
(
title: Text('Item 1')
,
onTap: () {

},
)
,
ListTile
(
title: Text('Logout')
,
onTap: () {
  _signOut();
  Navigator.of(context).pop();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> loginScreen()));
},
),
],
),
);
}