// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_flutter/message_card.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  late String formattedTime;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedTime = DateFormat('HH:mm').format(now);

    // Initialize the socket connection
    socket = IO.io(
        'http://10.132.163.127:3000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // Specify transport method
            .disableAutoConnect() // Disable auto-connect for manual control
            .build());

    // Connect to the server
    socket.connect();
    

    // Listen for incoming messages
    socket.on('receivePrivateMessage', (data) {
      print("Received message: $data");
      setState(() {
        messages
            .add({'timestamp': data['timestamp'], 'message': data['message'], 'sender': data['sender']});
      });
    });
  }

  @override
  void dispose() {
    // Disconnect the socket when the widget is disposed
    socket.disconnect();
    super.dispose();
  }

  void sendMessage() {

    if (_controller.text.trim() != '') {
      socket.emit('sendPrivateMessage', {
        "timestamp": formattedTime,
        "message": _controller.text.trim(),
        "sender": "bot"
      });
      // setState(() {
      //   messages.add({
      //     "timestamp": formattedTime,
      //     "message": _controller.text,
      //     "sender": "bot"
      //   });
      // }
      // );

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
            return MessageCard(sender: sender, message: message);
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
