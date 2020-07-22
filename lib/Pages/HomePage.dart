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
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreen> {

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  final String currentUserId;

  HomeScreenState({Key key, @required this.currentUserId});


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
          onFieldSubmitted: searching,
        ),
      ),
    );
    }

    emptyTextFormField() {
      searchTextEditingController.clear();
    }

    searching( String username ) {
      Future<QuerySnapshot> allFoundUsers = Firestore.instance.collection("users")
          .where('nickname', isGreaterThanOrEqualTo: username).getDocuments();

      searchResultsFuture = allFoundUsers;
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: homePageHeader(),
      body: (searchResultsFuture == null) ? noResultsScreen() : foundScreen(),

    );
  }

  noResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.lightBlue, size: 200,),
            Text(
              "Search Results",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.lightBlue, fontSize: 50, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }

  foundScreen() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context,dataSnapshot) {
        if (dataSnapshot.hasData) {
          List<UserResult> searchUserResult = [];
          dataSnapshot.data.documents.forEach((document){
            User user = User.fromDocument(document);
            UserResult userResult = UserResult(user);

            if (currentUserId != document["id"]) {
              searchUserResult.add(userResult);
            }
          });
          return ListView(children: searchUserResult,);

        } else {
          return circularProgress();
        }
      }
    );
  }

}



class UserResult extends StatelessWidget {

  final User user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
                title: Text(
                  user.nickname,
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "joined " + DateFormat("dd MMMM, yyyy - hh:mm:ss")
                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt))),
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}























