import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_menu/floating_menu.dart';
import 'package:flutter_floating_menu/floating_menu_callback.dart';
import 'package:flutter_floating_menu/floating_menu_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sharesdk_plugin/sharesdk_defines.dart';
import 'package:sharesdk_plugin/sharesdk_interface.dart';
import 'package:sharesdk_plugin/sharesdk_map.dart';

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
  SSDKMap params2;
  String title = '失败';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    params2 = SSDKMap()
      ..setGeneral(
        'ShareSdk_Flutter分享',
        '娱乐学习',
        null,
        widget.imageurl,
        null,
        'http://www.mob.com',
        widget.imageurl,
        "http://www.mob.com",
        null,
        null,
        SSDKContentTypes.image,
      );
  }

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
        authToWechat(context);
        break;
      case 2:
        share();
        break;
      case 3:
        shareWeChart();
        break;
    }
  }

  ///微信授权
  void authToWechat(BuildContext context) {
    SharesdkPlugin.auth(
        ShareSDKPlatforms.wechatSession, null, (SSDKResponseState state, Map user, SSDKError error) {
          if(user != null) {
            getUserInfoToWechat(context);
          }else{
            showAlert(title,context,null);
          }
    });
  }

  void showAlert(String title,BuildContext context,Map content) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        CupertinoAlertDialog(
          title: Text(title),
          content: new Text(content != null ? content.toString() : ""),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }


  ///微信授权并获取用户信息
  void getUserInfoToWechat(BuildContext context) {
    SharesdkPlugin.getUserInfo(
        ShareSDKPlatforms.wechatSession, (SSDKResponseState state,
        Map user, SSDKError error) {
        if(user != null) {
          title = '成功';
          showAlert(title, context, user);
        }else{
          showAlert(title,context,null);
        }
    });
  }
  ///分享好友
  void share() {
    SharesdkPlugin.share(
      ShareSDKPlatforms.wechatSession, params2, (SSDKResponseState state, Map userdata,
      Map contentEntity, SSDKError error) {
      Fluttertoast.showToast(msg: userdata == null?error.rawData.toString():userdata.toString());
    });
  }

  ///分享微信朋友圈
  void shareWeChart() {
    SharesdkPlugin.share(
        ShareSDKPlatforms.wechatTimeline, params2, (SSDKResponseState state, Map userdata,
        Map contentEntity, SSDKError error) {
      Fluttertoast.showToast(msg: userdata == null?error.rawData.toString():userdata.toString());
    });
  }
}
