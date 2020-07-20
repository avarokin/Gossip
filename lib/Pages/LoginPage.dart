import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Pages/HomePage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {

  LoginScreen({Key key}) : super(key : key);  //Constructor

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedin = false;
  bool isLoading = false;

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();

    isUserLoggedin();
  }

  void isUserLoggedin() async {
    this.setState(() {isLoggedin = true;});

    preferences = await SharedPreferences.getInstance();
    isLoggedin = await googleSignIn.isSignedIn();
    if (isLoggedin) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomeScreen(
              currentUserId: preferences.getString("id"))));
    }
    
    this.setState(() {isLoading = false;});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.blueAccent]
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Gossip",
              style: TextStyle(fontSize: 90.0, color: Colors.white,
              fontFamily: 'Sans-Serif'),
            ),
            GestureDetector(
              onTap: controlSignIn,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.only(
                        top: 30.0
                    ),
                    width: 240,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/google_signin_button.png"),
                        fit: BoxFit.cover
                      ),
                    ),
                ),
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: (isLoading) ? circularProgress() : Container(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> controlSignIn() async {

    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken:
      googleAuth.idToken, accessToken: googleAuth.accessToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseUser == null) {
      Fluttertoast.showToast(msg: "Sign in failed.");
      this.setState(() {
        isLoading = false;
      });

    } else {

      // Check Firestore for user
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection("users").where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();

      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;

      if (documentSnapshots.length == 0) {
        // Save new user info in FireStore
        Firestore.instance.collection("users").document(firebaseUser.uid).setData({
          "nickname" : firebaseUser.displayName,
          "photoUrl" : firebaseUser.photoUrl,
          "id" : firebaseUser.uid,
          "aboutMe" : "Hello, world!",
          "createdAt" : DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith" : null,
        });

        // Write data to local
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("nickaname", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);

      } else {
        // Returning user
        // Write data to local
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString("nickaname", documentSnapshots[0]["nickname"]);
        await preferences.setString("photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
      }

      Fluttertoast.showToast(msg: "Welcome!");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomeScreen(currentUserId: firebaseUser.uid,)));


    }
  } // end controlSignIn()

}
