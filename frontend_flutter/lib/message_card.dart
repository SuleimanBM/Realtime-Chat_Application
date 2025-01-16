import 'package:flutter/material.dart';


class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.sender, required this.message});
  final sender;
  final message;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            sender == "me" ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              //height: 200,
              //width: 350,
               constraints: const BoxConstraints(
                minWidth: 50,
                maxWidth: 350, // Set the maximum width
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
              margin: const EdgeInsets.only(left: 5, bottom: 10, right: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 216, 216),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message["message"] as String,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(message["timestamp"] as String,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]);
  }
}
