import 'package:flutter/material.dart';
import 'Pages/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gossip',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gossip', style: TextStyle(fontSize: 26.0, color: Colors.white, fontWeight: FontWeight.bold),),
        ),
        body: Center(
          child: Text('Welcome to Gossip', style: TextStyle(fontSize: 20.0, color: Colors.blueAccent),),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
