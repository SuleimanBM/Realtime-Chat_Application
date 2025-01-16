// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_flutter/message_card.dart';
import 'package:intl/intl.dart';


class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _controller = TextEditingController();
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedTime = DateFormat('HH:mm').format(now);
  }

  final List<Map<String, dynamic>> messages = [
    {
      "timestamp": "",
      "message": "Hello, there!",
      "sender": "me"
    },
    {
      "timestamp": "",
      "message": "Hello, how can I help you?",
      "sender": "bot"
    },
  ];

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({
          "timestamp": formattedTime,
          "message": _controller.text,
          "sender": "bot"
        });
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index];
            var sender = message["sender"];
            return MessageCard(sender: sender,message: message);
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 2),
            margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              border: Border.all(width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                FloatingActionButton(
                  mini: true,
                  onPressed: sendMessage,
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
