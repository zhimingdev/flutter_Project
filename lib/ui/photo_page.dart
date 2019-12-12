import 'package:flutter/material.dart';
import 'package:flutter_floating_menu/floating_menu.dart';
import 'package:flutter_floating_menu/floating_menu_callback.dart';
import 'package:flutter_floating_menu/floating_menu_item.dart';
import 'package:photo_view/photo_view.dart';

class PhototImagePage extends StatefulWidget{
  final String imageurl;

  PhototImagePage(this.imageurl);

  @override
  State<StatefulWidget> createState() => _PhotoImage();

}

class _PhotoImage extends State<PhototImagePage> implements FloatingMenuCallback{

  final List<FloatingMenuItem> floatMenuList = [
    FloatingMenuItem(id: 1, icon: Icons.favorite, backgroundColor: Colors.deepOrangeAccent),
    FloatingMenuItem(id: 2, icon: Icons.share, backgroundColor: Colors.brown),
    FloatingMenuItem(id: 3, icon: Icons.camera, backgroundColor: Colors.indigo),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PhotoView(
            imageProvider: NetworkImage(widget.imageurl),
          ),
          FloatingMenu(
            menuList: floatMenuList,
            callback: this,
            btnBackgroundColor: Colors.blue,
            preMenuIcon: Icons.more_vert,
            postMenuIcon: Icons.clear,
          )
        ],
      ),
    );
  }

  @override
  void onMenuClick(FloatingMenuItem floatingMenuItem) {
    switch (floatingMenuItem.id) {
      case 1:
        break;
    }
  }
}
