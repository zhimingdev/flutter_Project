import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/SplashPage.dart';
import 'package:flutter_app/ui/HomePage.dart';
import 'package:flutter_app/ui/guide_page.dart';
import 'package:flutter_app/ui/login_page.dart';
import 'package:flutter_app/ui/setting_page.dart';
import 'package:flutter_app/ui/common_webview_page.dart';
import 'package:flutter_app/ui/account_record_list_page.dart';
import 'package:flutter_app/ui/video_details_page.dart';
import 'package:flutter_app/ui/mine_integral_rank_page.dart';
import 'package:flutter_app/module/mine_integral_entity.dart';

class Routers {

  static Router router;
  static String splash = "/splash";
  static String home = "/home";
  static String guide = "/guide";
  static String login = "/login";
  static String setting = "/setting";
  static String webViewPage = "/webview";
  static String accountRecordListPage = "/ui/recordList";
  static String integralrank = "/ui/integralrank";
  /// 视频详情
  static const String video = "/video";

  //静态方法
  static void configureRoutes(Router router){//路由配置
    router.define(
        splash, handler: Handler(handlerFunc: (context, params) => SplashPage()));
    router.define(
        home, handler: Handler(handlerFunc: (context, params) {
//      var message = params['message']?.first;//取出传参
//      return HomePage(message);
    return HomePage();
    }));
    router.define(guide, handler: Handler(handlerFunc: (context,params) => GuidePage()));
    router.define(login, handler: Handler(handlerFunc: (context,params) => LoginPage()));
    router.define(setting, handler: Handler(handlerFunc: (context,params) => SettingPage()));
    router.define(webViewPage, handler: Handler(handlerFunc: (context,params) {
      String webtitle = params['title']?.first;
      String weburl = params['url']?.first;
      return CommonWebview(title: webtitle, url: weburl);
    }));
    router.define(accountRecordListPage, handler: Handler(handlerFunc: (_, params) => AccountRecordListPage()));
    router.define(video, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String itemJson = params['itemJson']?.first;
          return VideoDetailsPage(
            itemJson: itemJson,
          );
        }));

    ///积分排行
    router.define(integralrank, handler: Handler(handlerFunc: (_,params){
      print('====${params['data'].first}');
      MineIntegralData data = MineIntegralData.fromJson(json.decode(params['data'].first));
      return MineIntegralRank(data);
    }));
    Routers.router = router;
  }

}