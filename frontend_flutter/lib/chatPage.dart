// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            //height: 200,
            width: 300,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              "Chat",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 2),
              decoration: BoxDecoration(
                border: Border.all(width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  FloatingActionButton(mini: true,onPressed: (){}, child: Container(child: Icon(Icons.send)),)
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
