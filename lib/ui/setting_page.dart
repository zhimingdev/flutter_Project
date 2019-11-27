import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/res/colors.dart';
import 'package:flutter_app/utils/customdialog_page.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();

}

class _SettingPageState extends State<SettingPage> {
  String appversion ="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
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
      appBar: AppBar(
        title: Text("设置",style: TextStyle(color: Colors.black,fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,size: 20,color: Colors.black),
            onPressed: (){
              Navigator.of(context).pop();
            })
      ),
      body: Column(
        children: <Widget>[
          version(),
          Container(height: 0.8,width: double.infinity,child: Divider()),
          contentView(),
        ],
      )
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
              child: Text("版本号",style: TextStyle(color: Colors.black,fontSize: 16)),
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
          child: Text("退出登录",style: TextStyle(color: Colors.black,fontSize: 14))
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

}