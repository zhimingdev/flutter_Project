import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/res/colors.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/module/mine_integral_entity.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  String username = "未登录";
  String path = "";
  String defaultImage = "assets/images/img_mine.png";
  bool isLogin = false;
  var menuImage = ["zhls", "zjgl", "txzh"];
  var menuTitle = ["账户流水", "资金管理", "提现账号"];
  int integral = 0;
  String userId ='';
  MineIntegralData data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.registerLoginEvent();
    getUserInfo();
    getUserIntergnal();
  }

  void getUserIntergnal() {
    ApiService().mineIntegral((MineIntegralEntity mineIntegralEntity){
      if(mineIntegralEntity != null && mineIntegralEntity.errorCode == 0) {
        setState(() {
          data = mineIntegralEntity.data;
          integral = mineIntegralEntity.data.coinCount;
        });
      }else {
        Fluttertoast.showToast(msg: mineIntegralEntity.errorMsg);
      }
    });
  }

  void getUserInfo() {
    if (null != User.singleton.userName) {
      username = User.singleton.userName;
      isLogin = true;
    }
    if (null != User.singleton.headImage) {
      path = User.singleton.headImage;
    }
  }

  void registerLoginEvent() {
    Application.eventBus.on<LoginEvent>().listen((event) {
      getUserInfo();
      changeUI();
      getUserIntergnal();
    });
  }

  //异步
  changeUI() async {
    setState(() {
      username = User.singleton.userName;
      path = User.singleton.headImage;
      userId = User.singleton.userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colours.material_bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _topView(),
          Container(
              height: 0.6,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16.0),
              child: Divider()),
          SizedBox(height: 12.0),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              "账户",
              style: TextStyles.textBold18,
            ),
          ),
          Flexible(
              child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 12.0),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                        "assets/images/shop/" + menuImage[index] + ".png",
                        width: 32.0,
                        height: 32.0),
                    const SizedBox(height: 4.0),
                    Text(menuTitle[index], style: TextStyles.textSize12)
                  ],
                ),
                onTap: () {
                  if (index == 0) {
                    Routers.router
                        .navigateTo(context, Routers.accountRecordListPage);
                  }
                },
              );
            },
            itemCount: menuTitle.length,
          )),
          Container(height: 0.6, width: double.infinity, child: Divider()),
          jifen(),
          Container(height: 0.6, width: double.infinity, child: Divider()),
          settingView(),
          Container(height: 0.6, width: double.infinity, child: Divider()),
        ],
      ),
    );
  }


  Widget jifen() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Image.asset("assets/images/setting/ic_fen.png",height: 24,width: 24),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: Text("我的积分",style: TextStyle(color: Colors.black,fontSize: 16)),
              ),
              flex: 1,
            ),
            Text('$integral',style: TextStyles.textDarkGray14),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.arrow_forward_ios,size: 15, color: Colors.black26)
            )
          ],
        ),
      ),
      onTap: () {
        Routers.router.navigateTo(context, '${Routers.integralrank}?data=${Uri.encodeComponent(json.encode(data))}');
      },
    );
  }

  Widget settingView() {
    return Container(
        padding: EdgeInsets.all(15),
        height: 50,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Image.asset("assets/images/setting/ic_set.png",width: 24,height: 24),
            Expanded(
              child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: Text("系统设置",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
                onTap: gotoSetting,
              ),
              flex: 1,
            ),
            Container(
              child: Icon(Icons.arrow_forward_ios,
                  size: 15, color: Colors.black26),
            )
          ],
        ));
  }

  Widget _topView() {
    return Stack(
      children: <Widget>[
        new Container(
          height: 150,
          alignment: Alignment.bottomCenter,
//          decoration: BoxDecoration(
//            color: Colors.white,
////          image: DecorationImage(
////              image: AssetImage("images/borrow_top_bg.png"), fit: BoxFit.fill),
//          ),
          child: Container(
            alignment: Alignment.topLeft,
            height: 60,
            margin: EdgeInsets.only(bottom: 20),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: isLogin
                          ? FadeInImage.assetNetwork(
                              image: path,
                              placeholder: defaultImage,
                            )
                          : Image.asset(defaultImage),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            username,
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "这个人很懒,没写哦",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black26),
                          ),
                        )
                      ],
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Image.asset(
                            "assets/images/icon_mine_massage.png",
                            width: 20,
                            height: 20,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Fluttertoast.showToast(msg: "点击消息");
                          },
                        )
                      ],
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void gotoSetting() {
    Routers.router.navigateTo(context, Routers.setting,
        transition: TransitionType.inFromRight);
  }
}
