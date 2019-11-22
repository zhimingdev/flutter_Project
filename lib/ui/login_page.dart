import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/bubble_indication_painter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/module/user_module_entity.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //控制器
  PageController _pageController;

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  Color left = Colors.black;
  Color right = Colors.white;

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: new SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
//                topBg(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height >= 775.0
                      ? MediaQuery.of(context).size.height
                      : 775.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFffffff), Color(0xFFffffff)],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 120.0),
                        child: _buildMenuBar(context),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            if (index == 0) {
                              setState(() {
                                right = Colors.white;
                                left = Colors.black;
                              });
                            } else {
                              setState(() {
                                right = Colors.black;
                                left = Colors.white;
                              });
                            }
                          },
                          children: <Widget>[
                            loginView(context),
                            registView(context)
                          ],
                        ),
                        flex: 2,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Text("登录", style: TextStyle(color: left, fontSize: 16)),
                onPressed: _onSignInButtonPress,
              ),
              flex: 1,
            ),
            Expanded(
              //flatbutton 无背景按钮
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Text("注册", style: TextStyle(color: right, fontSize: 16)),
                onPressed: _onSignUpButtonPress,
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget loginView(BuildContext context) {
    Future<Null> _login() async {
      String username = loginEmailController.text;
      String pwd = loginPasswordController.text;
      if(null != username && pwd != null) {
        ApiService().login(username, pwd, (UserModuleEntity userModuleEntity,Response response) {
          if(userModuleEntity != null) {
            User().saveUserInfo(userModuleEntity, response);
            if(userModuleEntity.errorCode == 0) {
              Application.eventBus.fire(new LoginEvent(3));
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "登录成功！");
            }else{
              Fluttertoast.showToast(msg: userModuleEntity.errorMsg);
            }
          }
        });
      }else {
        Fluttertoast.showToast(msg: "用户名或者密码不能为空");
      }
    }

    return Container(
        padding: EdgeInsets.all(23.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            controller: loginEmailController,
                            focusNode: myFocusNodeEmailLogin,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '用户名',
                                hintStyle: TextStyle(fontSize: 17.0),
                                icon: Icon(FontAwesomeIcons.user,
                                    color: Colors.black, size: 18.0))),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            focusNode: myFocusNodePasswordLogin,
                            decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.lock,
                                    color: Colors.black, size: 22.0),
                                border: InputBorder.none,
                                hintText: '密码',
                                hintStyle: TextStyle(fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleLogin,
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ))),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 155),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Text("忘记密码",
                        style: TextStyle(
                            color: const Color(0xFF5394ff), fontSize: 12)),
                    onTap: () {
                      Fluttertoast.showToast(msg: "跳转忘记密码");
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 240.0),
                  child: MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 60.0),
                      color: const Color(0xFF5394ff),
                      textColor: Colors.white,
                      child: Text("登录",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                      //按钮样式
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      onPressed: _login),
                )
              ],
            )
          ],
        ));
  }

  Widget registView(BuildContext context) {

    Future<Null> _register() async {
      String registName = signupNameController.text;
      String registPwd = signupPasswordController.text;
      String registConfirmPwd = signupConfirmPasswordController.text;

      if ((null != registName && registName.trim().length > 0) &&
          (null != registPwd && registPwd.trim().length > 0) &&
          (null != registConfirmPwd && registConfirmPwd.trim().length > 0)) {
        if (registPwd != registConfirmPwd) {
          Fluttertoast.showToast(msg: "两次密码输入不一致！");
        } else {
          ApiService().register(registName, registPwd,
              (UserModuleEntity userModuleEntity) {
            if (userModuleEntity != null) {
              if (userModuleEntity.errorCode == 0) {
                Fluttertoast.showToast(msg: "注册成功！");
              } else {
                Fluttertoast.showToast(msg: userModuleEntity.errorMsg);
              }
            }
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "用户名或者密码不能为空",
        );
      }
    }

    return Container(
        padding: EdgeInsets.all(23.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            controller: signupNameController,
                            focusNode: myFocusNodeEmailLogin,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '用户名',
                                hintStyle: TextStyle(fontSize: 17.0),
                                icon: Icon(FontAwesomeIcons.user,
                                    color: Colors.black, size: 18.0))),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            focusNode: myFocusNodePasswordLogin,
                            decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.lock,
                                    color: Colors.black, size: 22.0),
                                border: InputBorder.none,
                                hintText: '密码',
                                hintStyle: TextStyle(fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignup,
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ))),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.lock,
                                    color: Colors.black, size: 22.0),
                                border: InputBorder.none,
                                hintText: '确认密码',
                                hintStyle: TextStyle(fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignupConfirm,
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ))),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 260.0),
                  child: MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 60.0),
                      color: const Color(0xFF5394ff),
                      textColor: Colors.white,
                      child: Text("注册",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      onPressed: _register
                  ),
                )
              ],
            )
          ],
        ));
  }

  //登录密码安全开关
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  //切换到登录
  void _onSignInButtonPress() {
    //curve 加速类型
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  //切换到注册
  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  //注册密码安全开关
  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

//注册确认密码安全开关
  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

}

Widget topBg() {
  return Container(
    color: const Color(0xFF5394ff),
    //状态栏高度
    height: MediaQueryData.fromWindow(window).padding.top,
  );
}
