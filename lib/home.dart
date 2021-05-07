import 'package:flutter/material.dart';
import 'package:flutter_apprtc/src/app_controller.dart';
import 'package:flutter_apprtc/src/utils/random_string.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _room_id = "";
  AppController _appController = AppController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppRTC Demo'),
      ),
      backgroundColor: Color(0xff333333),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 0,
                bottom: 10,
              ),
              child: Text(
                'Please enter a room name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: SizedBox(
                width: 250,
                child: TextField(
                  controller: TextEditingController(
                    text: '$_room_id',
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        _appController.createCall(_room_id);
                      },
                      child: Text('JOIN'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _room_id = randomNumeric(9);
                        });
                      },
                      child: Text('RANDOM'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
