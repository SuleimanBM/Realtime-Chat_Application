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
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //height: 200,
                  width: 300,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 216, 216),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    "Chatchatchatchatchatchatchatchatchatchatchatchat",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 2),
            margin: EdgeInsets.only(bottom: 5,left: 5, right: 5),
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
                FloatingActionButton(
                  mini: true,
                  onPressed: () {},
                  child: Container(child: Icon(Icons.send)),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
