import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: AndroidView(viewType: 'MyMap'),
        ),
      );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}