import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/router/Routers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/constans/constans_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashPage> {
  //定义变量
  Timer _timer;
  //倒计时数值
  var countdownTime = 6;

  void initState() {
    startCountdown();
  }

  void getState() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isShow = sharedPreferences.getBool(Constans.GUIDE_SHOW);
    if(isShow != null && isShow) {
      gotoHome();
    }else {
      gotoGuide();
    }
  }

  //倒计时方法
  startCountdown() {
    final call = (timer) {
      setState(() {
        if (countdownTime <= 1) {
          cancleTime();
          getState();
          return;
        }
        countdownTime--;
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  //跳转主页
  gotoHome() {
    Routers.router.navigateTo(context, Routers.home,
        clearStack: true, transition: TransitionType.inFromRight);
  }

  //跳转引导页
  gotoGuide() {
    Routers.router.navigateTo(context, Routers.guide,
        clearStack: true, transition: TransitionType.inFromRight);
  }

  //取消倒计时
  cancleTime() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Image.asset("assets/images/splash.png",
            fit: BoxFit.fill, width: double.infinity, height: double.infinity),
        //安全区===>状态栏以下
        new SafeArea(
          child: new GestureDetector(
            child: Align(
              alignment: Alignment.topRight,
              child: new Container(
                alignment: Alignment.center,
                height: 20,
                width: 50,
                margin: EdgeInsets.only(right: 15, top: 15),
                child: Text(
                  handleCodeText(),
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                      decoration: TextDecoration.none),
                ),
                decoration: new BoxDecoration(
                  color: Color(0xffEDEDED),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
            ),
            onTap: () {
              cancleTime();
              getState();
            },
          ),
        ),
      ],
    );
  }

  // ignore: missing_return
  String handleCodeText() {
    if (countdownTime > 0) {
      return "跳过 $countdownTime";
    } else
      return "0";
  }
}
