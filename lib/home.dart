import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppRTC Demo'),
      ),
      backgroundColor: Color(0xff333333),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 25,
                bottom: 5,
              ),
              child: Text(
                'Please enter a room name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
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
                    onPressed: () {},
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
                    onPressed: () {},
                    child: Text('RANDOM'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
