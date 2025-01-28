// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend_flutter/message_card.dart';
import 'package:frontend_flutter/provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
    this.otherUserId,
  });
  final otherUserId;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  late String formattedTime;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedTime = DateFormat('HH:mm').format(now);

    // Initialize the socket connection with the token from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myProvider = context.read<MyProvider>(); // Get provider after build context is available
      final token = myProvider.token;

      // Initialize the socket with the token
      socket = IO.io(
          'http://192.168.128.5:3000',
          IO.OptionBuilder()
              .setTransports(['websocket']) // Specify transport method
              .setQuery({"token": token}) // Pass the token here
              .disableAutoConnect() // Disable auto-connect for manual control
              .build());

      print("Token of sender: $token");

      // Connect to the server
      socket.connect();

      // Listen for incoming messages
      socket.on('receivePrivateMessage', (data) {
        print("Received message: $data");
        setState(() {
          messages.add({
            'timestamp': data['timestamp'],
            'message': data['message'],
            'sender': data['sender']
          });
        });
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
        "sender": "bot",
        "receiver": widget.otherUserId,
        "message": _controller.text.trim(),
        "timestamp": formattedTime,
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
