import 'package:flutter/material.dart';
import 'package:flutter_apprtc/home.dart';

void main() => runApp(AppRTC());

class AppRTC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}
