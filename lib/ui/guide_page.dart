import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/constans/constans_page.dart';
import 'package:flutter_app/router/Routers.dart';

class GuidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidePageState();

}

class _GuidePageState extends State<GuidePage> {
  var list = new List();

  @override
  void initState() {
    list.add("images/c.png");
    list.add("images/b.png");
    list.add("images/a.png");
  }

  //存储bool值
  void saveBool() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constans.GUIDE_SHOW, true);
  }

  //跳转主页
  void gotoMain() {
    Routers.router.navigateTo(context, Routers.home,clearStack: true,transition: TransitionType.inFromRight);
  }

  Widget _getPageView() {

    //控制器
    PageController _pageController = PageController();
    return PageView.builder(
      itemBuilder: ((context,index) {
        return GestureDetector(
          child: Image.asset(
            list[index],
            fit: BoxFit.fill,
          ),
          onTap: () {
            if(index == (list.length-1)) {
              saveBool();
              gotoMain();
            }
          },
        );
      }),
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _getPageView(),
    );
  }

}



