import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app/constans/constans_page.dart';
import 'intercept_manager.dart';

class DioManager {
  Dio _dio;

  static DioManager _instance = DioManager._internal();

  factory DioManager() => _instance;

  //通用全局单例，第一次使用时初始化
  DioManager._internal() {
    _dio = new Dio();
    //设置连接超时时间
    _dio.options.connectTimeout = 10000;
    //设置数据接收超时时间
    _dio.options.receiveTimeout = 10000;
    //添加拦截器
//    _dio.interceptors.add(new LogsInterceptors());
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    (_dio.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      // config the http client
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  get dio {
    return _dio;
  }

  static DioManager getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }


  //用于指定特定域名，比如cdn和kline首次的http请求
  DioManager _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  //一般请求，默认域名
  DioManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != Constans.baseUrl) {
        _dio.options.baseUrl = Constans.baseUrl;
      }
    }
    return this;
  }

}