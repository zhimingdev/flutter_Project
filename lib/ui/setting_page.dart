import 'dart:io';
import 'dart:ui';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/res/colors.dart';
import 'package:flutter_app/utils/customdialog_page.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();

}

class _SettingPageState extends State<SettingPage> {
  String appversion ="";
  String _cacheSizeStr ='0';
  static const MethodChannel _platform =
  const MethodChannel('com.example.flutter_app.NumberViewRegistrant');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
    loadCache();
    getCache();
  }

  void getCache() async{
    var result = await _platform.invokeMethod('number',_cacheSizeStr);
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      setState(() {
        appversion = version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10,bottom: 10),
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text("设置",style: TextStyle(color: Colors.black,fontSize: 16,decoration: TextDecoration.none)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      child: Image.asset("assets/images/ic_back_black.png",width: 20,height: 20),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
            version(),
            Container(height: 0.8,width: double.infinity,child: Divider()),
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child:
               Row(
                 children: <Widget>[
                   Container(
                     alignment: Alignment.centerLeft,
                     child: Image.asset("assets/images/setting/ic_cache.png",height: 24,width: 24),
                   ),
                   Expanded(
                     child: Container(
                       margin: EdgeInsets.only(left: 8),
                       child: Text('清除缓存',style: TextStyle(color: Colors.black,fontSize: 16), strutStyle: StrutStyle(height: 0,leading: 0)),
                     ),
                     flex: 9,
                   ),
                   Expanded(
                     child: Container(
                       alignment: Alignment.centerLeft,
                       child: AndroidView(viewType: 'numberview'),
                     ),
                     flex: 1,
                   ),
                 ],
               )
            ),
            contentView(),
          ],
        ),
      ),
    );
  }

  Widget version() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Image.asset("assets/images/setting/ic_version.png",height: 24,width: 24),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Text("版本号",style: TextStyle(color: Colors.black,fontSize: 16,decoration: TextDecoration.none)),
            ),
            flex: 1,
          ),
          Text('V $appversion',style: TextStyles.textDarkGray14,)
        ],
      ),
    );
  }

  Widget contentView() {
    return GestureDetector(
      child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 80),
          height: 45,
          width: double.infinity,
          color: Colors.white,
          child: Text("退出登录",style: TextStyle(color: Colors.black,fontSize: 14,decoration: TextDecoration.none))
      ),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomDialog(
              content: '您确定要退出登录吗!',
              confirmTextColor: Colors.red,
              confirmCallback: () {
                User.singleton.clearUserInfor();
                Application.eventBus.fire(new LoginEvent(0));
                Navigator.of(context).pop();
                Routers.router.navigateTo(context, Routers.login,transition: TransitionType.inFromRight);
              },
            );
          }
        );
      },
    );
  }

  ///加载缓存
  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    print('临时目录大小: ' + value.toString());
    setState(() {
      _cacheSizeStr = _renderSize(value);  // _cacheSizeStr用来存储大小的值
    });
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

}