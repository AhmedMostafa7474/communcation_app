import 'package:communcation_app/Drawer.dart';
import 'package:communcation_app/EditProfile1.dart';
import 'package:communcation_app/HomeScreen1.dart';
import 'package:communcation_app/Settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class welcomescreen extends StatefulWidget {
  @override
  _welcomescreenState createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  int _page = 0;
  late Widget currentpage;
  late Widget currenticon;
  late String currentTitle;
  GlobalKey _bottomNavigationKey = GlobalKey();
  List<Widget> Pages=[
    homescreen()
    ,
    editprofile(),
  ];
  List<String> title=[
    "Home"
    ,
    "Settings"
  ];
 List<Widget> items1= [
  Icon(Icons.home,),
  Icon(Icons.settings,),
  ];
  @override
  Widget build(BuildContext context) {
    currentpage=Pages[_page];
    currentTitle=title[_page];
    currenticon=items1[_page];
    return Scaffold(
    drawer: drawer(context),
      appBar: AppBar(
        backgroundColor:const Color(0xFF00796B),
        title: Text(currentTitle),
        leading: currenticon,
        titleSpacing: 2.0,
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
        ),
          currentpage
      ],
    ),
      bottomNavigationBar: CurvedNavigationBar(
         key: _bottomNavigationKey,
        index: 0,
        height: 50,
        items: [
          Icon(Icons.home, size: 30,),
          Icon(Icons.settings, size: 30,),
        ],
        color: Colors.white,
        backgroundColor: Colors.white,
        buttonBackgroundColor: const Color(0xFF00796B),
        animationCurve: Curves.easeOut,
        animationDuration: Duration(milliseconds: 600),
        letIndexChange: (index)=>true,
        onTap: (index){
           setState(() {
             _page=index;
             currentpage=Pages[index];
           });
        },
      ),
    );
  }
}
