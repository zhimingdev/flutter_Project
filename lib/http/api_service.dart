import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/http/dio_manager.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/module/user_module_entity.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/module/home_banner_entity.dart';
import 'package:flutter_app/module/home_data_entity.dart';
import 'package:flutter_app/module/welfare_entity.dart';
import 'package:flutter_app/module/video_entity.dart';

class ApiService {

  /// 登录
  void login(String _username, String _password,Function callback) async {
    FormData formData =
    new FormData.from({"username": _username, "password": _password});
    DioManager.getInstance(null,null).dio
        .post(Api.USER_LOGIN, data: formData, options: _getOptions())
        .then((response) {
      callback(UserModuleEntity(response.data), response);
    });
  }

  /// 注册
  void register(String _username, String _password,Function callback) async {
    FormData formData = new FormData.from({
      "username": _username,
      "password": _password,
      "repassword": _password
    });
    DioManager.getInstance(null,null).dio
        .post(Api.USER_REGISTER, data: formData, options: null)
        .then((response) {
      print(response.toString());
      callback(UserModuleEntity(response.data));
    });
  }

  ///获取积分信息
  void userRank() async{

  }

  ///首页banner
  void banner(Function callback) async{
    DioManager.getInstance(null,null).dio
        .get(Api.HOME_BANNER)
        .then((response) {
        callback(HomeBannerEntity(response.data));
    });
  }

  ///首页文章列表
  void homedata(String page,Function callback) async {
    DioManager.getInstance(null,null).dio
        .get(Api.HOME_DATA+page+'/json')
        .then((response) {
        callback(HomeDataEntity(response.data));
    });
  }

  ///福利养眼
  void welfare(int page,Function callback) async {
    DioManager.getInstance(Api.GANHUO_BASEURL,null).dio
        .get(Api.WELFARE+page.toString())
        .then((response) {
          callback(WelfareEntity(response.data));
    });
  }

  ///福利-休息视频
  void video(String type,Function callback) async {
    DioManager.getInstance(Api.KAIYAN_BASEURL,httpHeaders).dio
        .get(Api.VIDEO+type)
        .then((response) {
      callback(VideoEntity.fromJson(json.decode(response.toString())));
    });
  }

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }

}