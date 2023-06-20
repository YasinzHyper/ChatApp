import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Future<void> _onBackgroundMessage(RemoteMessage msg) async {
  await Firebase.initializeApp();
 
  print("onBackgroundMessage: ${msg}");
  print("onBackgroundMessage.data: ${msg.data}");
  print("onBackgroundMessage.notification.title: ${msg.notification?.title}");
  print("onBackgroundMessage.notification.body: ${msg.notification?.body}");
}

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print(message.toString());
      return;
    });
    
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
       print(message.toMap().toString());
      return;
    });
    fbm.subscribeToTopic('chat');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp'),
        actions: [
          DropdownButton(
            underline: Container(),
            elevation: 8,
            //borderRadius: BorderRadius.zero,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  //margin: EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'Logout',
                // onTap: () {
                //   FirebaseAuth.instance.signOut();
                // },
              ),
            ],
            onChanged: (value) {
              if (value == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            //because listview inside a column will not work well
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
