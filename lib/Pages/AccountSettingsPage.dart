import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:telegramchatapp/Widgets/ProgressWidget.dart';
import 'package:telegramchatapp/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}


class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}



class SettingsScreenState extends State<SettingsScreen> {

  TextEditingController nicknameTextEditingController;
  TextEditingController aboutMeTextEditingController;

  SharedPreferences preferences;
  String id = "";
  String nickname = "";
  String aboutMe = "";
  String photoUrl = "";

  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();

  File imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    readDataFromLocal();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.get("id");
    nickname = preferences.get("nickname");
    aboutMe = preferences.get("aboutMe");
    photoUrl = preferences.get("photoUrl");

    nicknameTextEditingController = TextEditingController(text: nickname);
    aboutMeTextEditingController = TextEditingController(text: aboutMe);

    setState(() {});  // Force refresh
  }

  Future getImage() async {
    File newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      setState(() {
        this.imageFile = newImage;
        isLoading = true;
      });
    }

    //uploadImageToFierstoreAndStorage();
  }



  @override
  Widget build(BuildContext context) {
    return Stack (
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Profile image
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imageFile == null) ? (photoUrl != "") ?
                          Material(
                            // Display existing image
                            child: CachedNetworkImage(
                              placeholder: (context,url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                                ),
                                width: 250,
                                height: 250,
                                padding: EdgeInsets.all(20),
                              ),
                              imageUrl: photoUrl,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(125)),
                            clipBehavior: Clip.hardEdge,
                          ) : Icon(Icons.account_circle, size: 100,color: Colors.grey,)
                          : Material(
                        // Display new image
                        child: Image.file(
                            imageFile,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(125)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 100,
                          color: Colors.white54.withOpacity(0),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20),
              ),
              Column (
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(1), child: isLoading ? circularProgress() : Container(),),

                  Container(
                    child: Text(
                        "Profile Name: ",
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                    ),
                    margin: EdgeInsets.only(left: 10,bottom: 5, top: 10),
                  ),

                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlue),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Your name here",
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: nicknameTextEditingController,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: nicknameFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),


                  Container(
                    child: Text(
                      "About Me: ",
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                    ),
                    margin: EdgeInsets.only(left: 10,bottom: 5, top: 10),
                  ),

                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlue),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "A fun fact about yourself",
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: aboutMeTextEditingController,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: aboutMeFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),



                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Add buttons
              Container(
                child: FlatButton(
                  onPressed: ()=>print("clicked"),
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Colors.lightBlueAccent,
                  highlightColor: Colors.grey,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                ),
                margin: EdgeInsets.only(top: 50, bottom: 1)
              ),

              // Logout button
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: RaisedButton(
                  color: Colors.red,
                  onPressed: logoutUser,
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )

            ],
          ),
          padding: EdgeInsets.only(left: 15,right: 15),
        ),
      ],
    );
  }



  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    
    this.setState(() {isLoading = false;});
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }
}
