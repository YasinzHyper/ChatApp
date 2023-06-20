import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  //const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Center(
            child: Text('Loading...'),
          ),
        ],
      ),
    );
  }
}