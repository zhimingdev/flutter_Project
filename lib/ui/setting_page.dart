import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/customdialog_page.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();

}

class _SettingPageState extends State<SettingPage> {
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
      body: contentView(context),
    );
  }

  Widget contentView(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
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