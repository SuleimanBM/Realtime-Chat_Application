import 'package:flutter/material.dart';
import 'package:frontend_flutter/chat_page.dart';
import 'package:frontend_flutter/message_page.dart';
import 'package:frontend_flutter/signup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
  });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  late List foundUsers = [];
  Future<void> sendData() async {
    const url =
        'http://192.168.128.5:3000/chat/search-username'; // Replace with your API endpoint
    final Map<String, dynamic> payload = {
      'username': _searchController.text,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        // Success
        print('Data sent successfully: ${response.body}');

        final jsonData = json.decode(response.body);
        setState(() {
          foundUsers = jsonData["user"];
        });
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickChat'),
      ),
      body: Column(children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        width: 5, color: Color.fromARGB(255, 3, 6, 34))),
                labelText: 'Enter username to find friends',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  iconSize: 40,
                  color: Color.fromARGB(255, 3, 6, 34),
                  onPressed: sendData,
                ),
              ),
            )),
        Expanded(
          child: ListView.builder(
            itemCount: foundUsers.length,
            itemBuilder: (context, index) {
              return userCard(foundUsers[index]);
            },
          ),
        ),
      ]),
    );
  }
}

class userCard extends StatelessWidget {
  userCard(
    this.user, {
    super.key,
  });

  final Map user;
  late final String username = user["username"];
  late final String Id = user["_id"];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //print(Id);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MessagePage(
                    otherUserId: Id,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 3, 6, 34),
                )),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                '$username',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
