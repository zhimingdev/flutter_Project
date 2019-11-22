import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/ui/data_page.dart';
import 'package:flutter_app/ui/hall_page.dart';
import 'package:flutter_app/ui/mine_page.dart';
import 'package:flutter_app/ui/welfare_page.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/application.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/constans/colors_page.dart';
import 'package:flutter_app/utils/customdialog_page.dart';

class HomePage extends StatefulWidget {
  //  final String message;
//
//  const HomePage(this.message);

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<HomePage> {
  int _selectedIndex = 0; //当前选中项的索引
  bool isLogin = false;

  final appBarTitles = ['首页', '资料', '福利', '我的'];
  final icons = [
    Icons.home,
    Icons.assignment,
    Icons.cake,
    Icons.account_circle
  ];
  var page = <Widget>[HallPage(), DataPage(), WelfarePage(), MinePage()];

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  IconData getTabIcon(int curIndex) {
    if (curIndex == _selectedIndex) {
      return icons[curIndex];
    }
    return icons[curIndex];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginInfo();
    this.registerLoginEvent();
  }

  Future<Null> getLoginInfo() async {
    User.singleton.getUserInfo();
    String name = User.singleton.userName;
    isLogin = (null != name)? true : false;
  }

  void registerLoginEvent() {
    Application.eventBus.on<LoginEvent>().listen((event) {
      getLoginInfo();
      _onItemTapped(event.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //  WillPopScope=>双击返回与界面退出提示
        onWillPop: _onWillPop,
        child: Scaffold(
          body: new IndexedStack(
            children: page,
            index: _selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: CommonColors.theme_color,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(getTabIcon(0)),
                  activeIcon: Icon(getTabIcon(0)),
                  title: Text(appBarTitles[0])),
              BottomNavigationBarItem(
                  icon: Icon(getTabIcon(1)),
                  activeIcon: Icon(getTabIcon(1)),
                  title: Text(appBarTitles[1])),
              BottomNavigationBarItem(
                  icon: Icon(getTabIcon(2)),
                  activeIcon: Icon(getTabIcon(2)),
                  title: Text(appBarTitles[2])),
              BottomNavigationBarItem(
                  icon: Icon(getTabIcon(3)),
                  activeIcon: Icon(getTabIcon(3)),
                  title: Text(appBarTitles[3]))
            ],
            type: BottomNavigationBarType.fixed,
            //设置显示的模式
            currentIndex: _selectedIndex,
            //当前选中项的索引
            onTap: _onItemTapped, //选择按下处理
          ),
        ));
  }

  //选择按下处理 设置当前索引为index值
  void _onItemTapped(int index) {
    setState(() {
      if (index == (page.length - 1)) {
        if (!isLogin) {
          Routers.router.navigateTo(context, Routers.login,
              transition: TransitionType.inFromRight);
          return;
        }
      }
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) => new CustomDialog(
              title: "提示",
              content:'确定退出应用吗？',
              cancelContent: '再看一会',
              confirmContent: '残忍退出',
              confirmTextColor: CommonColors.theme_color,
              confirmCallback: () {
                SystemNavigator.pop();
              }
            ));
  }
}
