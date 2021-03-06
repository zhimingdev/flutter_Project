
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_module_entity.dart';

class User {

  static final User singleton = User._internal();

  factory User() {
    return singleton;
  }

  User._internal();

  List<String> cookie;
  String userName;
  String headImage;
  String userId;

  Future<Null> getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> cookies = sp.getStringList("cookies");
    if (cookies != null) {
      cookie = cookies;
    }

    String username = sp.getString("username");
    if(username!=null){
      userName = username;
    }

    String image = sp.getString("headimage");
    if(image!=null){
      headImage = image;
    }

    String id = sp.getString("userId");
    if(id!=null){
      userId = id;
    }
  }

  void saveUserInfo(UserModuleEntity _userModel,Response response){
    List<String> cookies = response.headers["set-cookie"];
    cookie = cookies;
    userName = _userModel.data.username;
    headImage = _userModel.data.headImage;
    userId = _userModel.data.id.toString();
    saveInfo();
  }

  saveInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList("cookies", cookie);
    sp.setString("username", userName);
    sp.setString("headimage", headImage);
    sp.setString("userId", userId);
  }

  void clearUserInfor(){
    cookie = null;
    userName = null;
    headImage = null;
    userId = null;
    clearInfo();
  }

  clearInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList("cookies", null);
    sp.setString("username", null);
    sp.setString("headimage", null);
    sp.setString("userId", null);
  }

}