import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Widgets/FullImageWidget.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {

  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  Chat({
    Key key, @required this.receiverAvatar,
    @required this.receiverId,
    @required this.receiverName
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: CachedNetworkImageProvider(receiverAvatar),
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          receiverName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(receiverId : receiverId,receiverAvatar: receiverAvatar ),
    );


  }
}

class ChatScreen extends StatefulWidget {

  final String receiverId;
  final String receiverAvatar;

  ChatScreen({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar
  }) : super(key:key);

  @override
  State createState() => ChatScreenState(receiverId: receiverId,receiverAvatar: receiverAvatar);
}




class ChatScreenState extends State<ChatScreen> {

  final String receiverId;
  final String receiverAvatar;

  ChatScreenState({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar
  });

  final TextEditingController textEditingController = new TextEditingController();
  final FocusNode focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              createListOfMessages(),
              // Input contollers
              createInput(),
            ],
          )
        ],
      ),
    );
  }

  createListOfMessages() {
    return Flexible(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),),
      ),
    );
  }

  createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Image button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image, color: Colors.lightBlue),
                onPressed: () => print("Clicked image."),
              ),
            ),
            color: Colors.white,
          ),

          // Emoji button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.face, color: Colors.lightBlue),
                onPressed: () => print("Clicked emoji."),
              ),
            ),
            color: Colors.white,
          ),

          // Text field
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Send button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.lightBlue,
                onPressed: ()=>print("Clicked send."),
              ),
            ),
            color: Colors.white,
          )
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}

















