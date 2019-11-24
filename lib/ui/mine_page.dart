import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/router/Routers.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.registerLoginEvent();
    getUserInfo();
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
    });
  }

  //异步
  changeUI() async {
    setState(() {
      username = User.singleton.userName;
      path = User.singleton.headImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          _topView(),
          _account(),
          settingView(),
        ],
      ),
    );
  }

  Widget settingView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(top: 20),
      height: 50,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.settings),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("设置",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
              onTap: gotoSetting,
            ),
            flex: 1,
          ),
          Container(
            child:
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black26),
          )
        ],
      ),
    );
  }

  Widget _topView() {
    return Stack(
      children: <Widget>[
        new Container(
          height: 150,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.white,
//          image: DecorationImage(
//              image: AssetImage("images/borrow_top_bg.png"), fit: BoxFit.fill),
          ),
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
                      child: isLogin ? FadeInImage.assetNetwork(image: path,placeholder: defaultImage,)
                          :Image.asset(defaultImage),
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

  Widget _account() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10,top: 15),
            child:  Text("账户",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600)),
          ),
          // Flexible不强制铺满
          Flexible(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                crossAxisCount: menuTitle.length
              ),
              itemBuilder: (context,index) {
                return Column(
                );
              },
            )
          )
        ],
      ),
    );
  }

  void gotoSetting() {
    Routers.router.navigateTo(context, Routers.setting,transition: TransitionType.inFromRight);
  }

}

