import 'package:communcation_app/LoginScreen1.dart';
import 'package:communcation_app/PushNotifcation.dart';
import 'package:communcation_app/Userstatus.dart';
import 'package:communcation_app/WelcomeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class chatapp extends StatefulWidget {
  @override
  _chatappState createState() => _chatappState();
}

class _chatappState extends State<chatapp> {
 // late final PushNotificationsManager _pushNotificationsManager;
  Future<bool> checkinlogin()async
  {
    //await _pushNotificationsManager.init();
    var status= await loginStatues().readStatus();
    return status;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkinlogin(),
        builder: (context,snapshot) {
          if(snapshot.data==true)
          {
            return  welcomescreen();
          }
          else{
            return  loginScreen();

          }
        }
    );
  }
}
