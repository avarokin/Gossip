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
        backgroundColor: Colors.deepOrange,
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
  bool isDisplaySticker;
  bool isLoading;

  File imageFile;
  String imageUrl;

  String chatID;
  SharedPreferences preferences;
  String id;
  var listMessage;

  ChatScreenState({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar
  });

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode.addListener(onFocusChange);

    this.isDisplaySticker = false;
    this.isLoading = false;
    chatID = "";
    readLocalStorage();
  }

  readLocalStorage() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.get("id") ?? "";
    if (id.hashCode <= receiverId.hashCode) {
      chatID = '$id-$receiverId';
    } else {
      chatID = '$receiverId-$id';
    }
    Firestore.instance.collection("users").document(id).updateData({'chattingWith' : receiverId});
    setState(() {});
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        this.isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              createListOfMessages(),
              // Input contollers

              // Show emoji pane
              (isDisplaySticker ? createStickers() : Container()),
              // Input controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPush,
    );
  }

  Future<bool> onBackPush() {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      // TODO
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  createLoading() {
    return Positioned(
      child: isLoading? circularProgress() : Container(),
    );
  }

  createStickers() {
    return Container(
      child: Column(
        children: <Widget>[

          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage("mimi1",2),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi2",2),
                child: Image.asset(
                  "images/mimi2.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi3",2),
                child: Image.asset(
                  "images/mimi3.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),

          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage("mimi4",2),
                child: Image.asset(
                  "images/mimi4.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi5",2),
                child: Image.asset(
                  "images/mimi5.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi6",2),
                child: Image.asset(
                  "images/mimi6.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),

          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage("mimi7",2),
                child: Image.asset(
                  "images/mimi7.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi8",2),
                child: Image.asset(
                  "images/mimi8.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi9",2),
                child: Image.asset(
                  "images/mimi9.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),


        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),

      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey,width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5),
      height: 180,
    );
  }

  createListOfMessages() {
    return Flexible(

      child: chatID == "" ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),),
      )
          : StreamBuilder(
       stream: Firestore.instance.collection("messages").document(chatID).collection(chatID)
        .orderBy("timeStamp", descending: true).limit(20).snapshots(),

        builder: (context, snapshot) {
         if (!snapshot.hasData) {
           return Center(
             child: CircularProgressIndicator(
               valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),),
           );
         } else {
           {
             listMessage = snapshot.data.documents;
             return ListView.builder(
               padding: EdgeInsets.all(10),
               itemBuilder: (context,index) => createItem(index,snapshot.data.documents[index]),
               itemCount: snapshot.data.documents.length,
               reverse: true,
               controller: listScrollController,
             );
           }
         }
        },
      ),

//
    );
  }

  Widget createItem(int index, DocumentSnapshot doc) {

    if (doc["idFrom"] == id) {
      // Right side of display
      return Row(
        children: <Widget>[
          ( doc["type"] == 0) ?
            // Text message
            Container(
              child: Text(
                doc["content"],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.only(bottom: isLastMessageR(index) ? 20 : 10, right: 10),
            )
          : ( doc["type"] == 1) ?
            // Image
            Container(
              child: FlatButton(
                child: Material(

                  child: CachedNetworkImage(
                    placeholder: (context,url) => Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent,),
                      ),
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(70),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    errorWidget: (context, url, error) => Material(
                      child: Image.asset("images/img_not_available;jpeg", width: 200, height: 200, fit: BoxFit.cover,),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: doc["content"],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FullPhoto(url : doc["content"])
                  ));
                },
              ),
              margin: EdgeInsets.only(bottom: isLastMessageR(index) ? 20 : 10, right: 10),
            )
          :
            // Emoticon
            Container(
              child: Image.asset(
                "images/${doc['content']}.gif",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              margin: EdgeInsets.only(bottom: isLastMessageR(index) ? 20 : 10, right: 10),
            ),
        ],
        mainAxisAlignment:  MainAxisAlignment.end,
      );

    } else {
      // Left side of display
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageL(index) ?
                    Material(
                      // Profile picture
                      child: CachedNetworkImage(
                        placeholder: (context,url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent,),
                          ),
                          width: 35,
                          height: 35,
                          padding: EdgeInsets.all(10),
                        ),
                        imageUrl: receiverAvatar,
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      clipBehavior: Clip.hardEdge,
                    )
                : Container(width: 35,),
                // Messages
                  ( doc["type"] == 0) ?
                  // Text message
                  Container(
                    child: Text(
                      doc["content"],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: EdgeInsets.only(left: 10),
                  )

                  : ( doc["type"] == 1) ?
                  // Image
                  Container(
                    child: FlatButton(
                      child: Material(

                        child: CachedNetworkImage(
                          placeholder: (context,url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent,),
                            ),
                            width: 200,
                            height: 200,
                            padding: EdgeInsets.all(70),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset("images/img_not_available;jpeg", width: 200, height: 200, fit: BoxFit.cover,),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: doc["content"],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => FullPhoto(url : doc["content"])
                        ));
                      },
                    ),
                    margin: EdgeInsets.only(left: 10),
                  )

                  :
                  // Emoticon
                  Container(
                    child: Image.asset(
                      "images/${doc['content']}.gif",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    margin: EdgeInsets.only(left: 10),
                  ),

              ],
            ),

            // Display timestamp
            isLastMessageL(index) ?
              Container(
                child: Text(
                  DateFormat("dd MMM, YYYY - kk:mm")
                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(doc["timeStamp"]))),
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(left: 50, top: 50, bottom: 5),
              )
            : Container(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10),
      );
    } // endif
  } // end cre

  bool isLastMessageR(int index) {
    if ( (index > 0 && listMessage != null && listMessage[index-1]["idFrom"] != id)
        || (index == 0) ) {
      return true;
    }
    return false;
  }// ateIt

  bool isLastMessageL(int index) {
    if ( (index > 0 && listMessage != null && listMessage[index-1]["idFrom"] == id)
        || (index == 0) ) {
      return true;
    }
    return false;
  }// ate// em()


  createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Image button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image, color: Colors.deepOrange),
                onPressed: getImage,
              ),
            ),
            color: Colors.white,
          ),

          // Emoji button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.face, color: Colors.deepOrange),
                onPressed: getSticker,
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
                color: Colors.deepOrange,
                onPressed: () => onSendMessage(textEditingController.text, 0),
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

  void onSendMessage(String content, int type) {

    if (content == "" || content == null) {
      return;
    }

    textEditingController.clear();

    var docRef = Firestore.instance.collection("messages").document(chatID)
        .collection(chatID).document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(docRef, {
        "idFrom" : id,
        "idTo" : receiverId,
        "timeStamp" : DateTime.now().millisecondsSinceEpoch.toString(),
        "content" : content,
        "type" : type,
      },);
    });

    listScrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
    }
    uploadImage();
  }

  Future uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then( (downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(msg: error);
      });
    });
  }

}

















