import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telegramchatapp/Pages/ChattingPage.dart';
import 'package:telegramchatapp/main.dart';
import 'package:telegramchatapp/models/user.dart';
import 'package:telegramchatapp/Pages/AccountSettingsPage.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomeScreen extends StatefulWidget {

  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  TextEditingController searchTextEditingController = TextEditingController();

  homePageHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, size: 30, color: Colors.white,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
          },
    ),
    ],
      backgroundColor: Colors.lightBlue,
      title: Container(
        margin: new EdgeInsets.only(bottom: 5),
        child: TextFormField(
          style: TextStyle(fontSize: 20, color: Colors.white),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Search for users...",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            filled: true,
            prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30,),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white,),
              onPressed: emptyTextFormField,
            )
          ),
        ),
      ),
    );
    }

    emptyTextFormField() {
      searchTextEditingController.clear();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: homePageHeader(),
      body :  RaisedButton.icon(onPressed: logoutUser,
        icon: Icon(Icons.close), label: Text("Sign out"))
    );
  }


  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }
}



class UserResult extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

  }
}
