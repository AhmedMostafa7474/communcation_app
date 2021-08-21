import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communcation_app/RegisterScreen.dart';
import 'package:communcation_app/Userstatus.dart';
import 'package:communcation_app/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';


class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final emailcontrol = TextEditingController();
  final passwordcontrol = TextEditingController();
  String email = "",
      password = "",
      username = "",
      name = "";
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late ProgressDialog pr;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screensize=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            //child: Image.asset("assets/background.png"),
            decoration: BoxDecoration(
               /* gradient: LinearGradient(colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF4781E0),
                  Color(0xFF398AE5),
                ], stops: [0.3, 0.4, 0.7, 0.9]
                  ,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )*/
               color:const Color(0xFF00796B) //const Color(0xFF00796B)
            ),

          ),
          Padding(
            padding: EdgeInsets.only(top: screensize.height*0.2 ),
            child: Container(
              height: double.infinity,
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
                        Text("Sign in ", style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold
                            ,
                            fontFamily: "OpenSans"
                            ,
                            letterSpacing: 1.5
                            ,
                            color: const Color(0xFF00796B))),
                        EmailBox(),
                        PassBox(),
                       // ForgetBox(),
                        LoginBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween
                          ,
                          children: [
                            SignupBox(),
                            // Row(
                            //     children: [
                            //       Facebox(),
                            //       SizedBox(width: 10.0)
                            //       ,
                            //       Googlebox()
                            //     ]
                            //)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Container LoginBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child:
      RaisedButton(onPressed: ()async{
        if(emailcontrol.text.isEmpty||passwordcontrol.text.isEmpty)
        {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Check info"),
                action: SnackBarAction(
                  label: "UNDO", onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
                )
                ,)
          );
        }
        else
        {
          try{
            final newuser = await auth.signInWithEmailAndPassword(email: emailcontrol.text, password: passwordcontrol.text);
            if(newuser!=null)
            {
              loginStatues().writeStatus(true);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> welcomescreen()));
            }
          }catch(e)
          {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black,
                  content: Text("Error Sign in Try Again",
                    style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                  ),
                )
            );
          }
        }
      },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
        ),
        color: const Color(0xFF00796B)
        ,
        child: Text("Login", style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
            ,
            fontFamily: "OpenSans"
            ,
            letterSpacing: 1.5
            ,
            color: Colors.white)),),
    );
  }

  Container SignupBox() {
    return Container(
      alignment: Alignment.centerLeft,
      child:
      FlatButton(onPressed: () =>
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => registerscreen())),
          child: Text(
              "Sign up ?", style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
              ,
              fontFamily: "OpenSans"
              ,
              letterSpacing: 1.5
              ,
              color: const Color(0xFF00796B))
          )),
    );
  }

  Container ForgetBox() {
    return Container(
      alignment: Alignment.centerRight,
      child:
      FlatButton(onPressed: () => print("Forget Password?"), child: Text(
          "Forget Password?", style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold
          ,
          fontFamily: "OpenSans"
          ,
          letterSpacing: 1.5
          ,
          color: Colors.black87)
      )),
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
              prefixIcon: Icon(Icons.email, color: const Color(0xFF00796B)
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
          decoration: BoxDecoration(
              color: Colors.white54
          ),
          height: 60.0,
          child: TextFormField(
            controller: passwordcontrol,
            onSaved: (input) => password = input!,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: const Color(0xFF00796B)),
              hintText: "Enter your Password",
            ),
          ),
        )
      ],
    );
  }
  InkWell Facebox() {
    return InkWell(
      child: Container(
        height:50.0,
        width: 50.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle
            ,color: const Color(0xFF00796B)
            ,boxShadow:[ BoxShadow(
            blurRadius: 6.0
            ,color: Colors.black,
            offset: Offset(0, 2)
        )
        ]
            ,image: DecorationImage(fit: BoxFit.cover,
            image: AssetImage("assets/social-facebook-icon.png")
        )
        ),
      ),
    );
  }

  InkWell Googlebox() {
    return InkWell(
        onTap:() async {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          final GoogleSignInAccount? googleSignInAccount = await googleSignIn
              .signIn();

          if (googleSignInAccount != null) {
            final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
                .authentication;

            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );
            try {
              final UserCredential userCredential =
              await auth.signInWithCredential(credential);

              loggedinuser = userCredential.user!;
            } catch (e) {

            }
          }
        },
        child:Container(
      height:50.0,
      width: 50.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle
          ,color: Colors.white
          ,boxShadow:[ BoxShadow(
          blurRadius: 6.0
          ,color: Colors.black,
          offset: Offset(0, 2)
      )
      ]
          ,image: DecorationImage( fit :BoxFit.cover ,
          image: AssetImage("assets/Google-1320568266385361674_512.png")
      )
      ),
    )
    );
}
}
