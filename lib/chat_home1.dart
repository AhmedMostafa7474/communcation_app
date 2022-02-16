import 'package:communcation_app/LoginScreen1.dart';
import 'package:communcation_app/PushNotifcation.dart';
import 'package:communcation_app/Userstatus.dart';
import 'package:communcation_app/Utils.dart';
import 'package:communcation_app/WelcomeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';
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
  String largeicon="";
  String bigpicture="";

  Future<void> load()
async {
  bigpicture= await Utils.downloadFile("https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "bigPicture");
  largeicon= await Utils.downloadFile("https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "largeIcon");
  print("pppppoooooopp"+largeicon);
  final styleinfo= BigPictureStyleInformation(
    FilePathAndroidBitmap(bigpicture),
    largeIcon:FilePathAndroidBitmap(largeicon),
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: "@mipmap/ic_launcher" ,
                styleInformation:styleinfo
            ),
          ));
    }
  });
  }
  @override
  void initState() {
    super.initState();
    load();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification ?notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
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
