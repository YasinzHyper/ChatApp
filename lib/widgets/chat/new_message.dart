import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class NewMessage extends StatefulWidget {
  //const NewMessage({Key key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _messageController = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['imageUrl'],
    });
    _messageController.clear();
    // _enteredMessage = '';

    //Sending notification
    //String token = await FirebaseMessaging.instance.getToken();
    //print(token);
    final url = Uri.https('fcm.googleapis.com', '/fcm/send');
    http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAA1sE23Ok:APA91bHSPcjIMt1_tpoxed7aN7ZgUxCw3NKURjcLFCevoY5y_4FSlPSk_EfDUTt_K5XWlm0iFIRsbVAD6-tbR9oV6YnlwqJjU0CBYYFRVpASv4OHADAaBy_ESnWx23VER4EhV1RtKB6t"
      },
      body: json.encode(
        {
          "to": "/topics/chat", //or 'chat'
          "notification": {
            "title": userData['username'],
            "body": _enteredMessage,
            "mutable_content": true,
            "sound": "Tri-tone"
          },
          // "data": {
          //   // "url": "<url of media image>",
          //   // "dl": "<deeplink action on tap of notification>"
          // }
        },
      ),
    );
    _enteredMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Send Message',
                prefixIcon: Icon(Icons.message_outlined),
                prefixIconColor: Theme.of(context).accentColor,
              ),
              onChanged: (value) {
                _enteredMessage = value;
              },
              onSubmitted: (value) {
                _enteredMessage = value;
                _enteredMessage.trim().isEmpty ? null : _sendMessage;
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              _enteredMessage = _messageController.text;
              print(_enteredMessage);
              _enteredMessage.trim().isEmpty ? null : _sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
