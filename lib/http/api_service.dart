import 'package:dio/dio.dart';
import 'package:flutter_app/http/dio_manager.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/module/user_module_entity.dart';
import 'package:flutter_app/module/user_module.dart';
import 'package:flutter_app/module/home_banner_entity.dart';

class ApiService {

  /// 登录
  void login(String _username, String _password,Function callback) async {
    FormData formData =
    new FormData.from({"username": _username, "password": _password});
    DioManager.getInstance().dio
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
    DioManager.getInstance().dio
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
    DioManager.getInstance().dio
        .get(Api.HOME_BANNER)
        .then((response) {
        callback(HomeBannerEntity(response.data));
    });
  }

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }

}