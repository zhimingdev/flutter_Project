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

  static DioManager getInstance(String baseUrl,Map header) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl,header);
    }
  }


  //用于指定特定域名，比如cdn和kline首次的http请求
  DioManager _baseUrl(String baseUrl,Map header) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    if(_dio != null && header != null) {
      _dio.options.headers = httpHeaders;
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

  static Future getHomePageList(url) async {
    Dio dio = new Dio();
    var response = await dio.get(
      url,
      options: Options(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        headers: httpHeaders,
      ),
    );
    return response;
  }


}

const httpHeaders = {
  'Accept': 'application/json, text/plain, */*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'zh-CN,zh;q=0.9',
  'Connection': 'keep-alive',
  'Content-Type': 'application/json',
  'User-Agent':
  'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1',
};