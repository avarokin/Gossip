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

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
                    child: circularProgress(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
