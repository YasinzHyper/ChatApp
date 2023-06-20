import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  //const MessageBubble({Key key}) : super(key: key);
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String imageUrl;

  MessageBubble(
    this.message,
    this.isMe,
    this.userName,
    this.imageUrl, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(15) : Radius.zero,
                  topRight: !isMe ? Radius.circular(15) : Radius.zero,
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: isMe
                    ? Theme.of(context).accentColor
                    : Color.fromARGB(191, 85, 133,
                        157), /* Color.fromARGB(163, 5, 186, 168) */
              ),
              width: 180,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: -6,
          left: !isMe ? 168 : null,
          right: isMe ? 168 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
      ],
    );
  }
}
