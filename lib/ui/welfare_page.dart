import 'package:flutter/material.dart';

class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelfarePageState();

}

class WelfarePageState extends State<WelfarePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Text("福利"),
        alignment: Alignment.center,
      ),
    );
  }

}