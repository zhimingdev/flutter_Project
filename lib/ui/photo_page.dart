import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhototImagePage extends StatefulWidget {
  final String imageurl;

  PhototImagePage(this.imageurl);

  @override
  State<StatefulWidget> createState() => _PhotoImage();

}

class _PhotoImage extends State<PhototImagePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageurl),
        ),
      ),
    );
  }

}
