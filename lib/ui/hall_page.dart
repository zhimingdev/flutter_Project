import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/http/dio_manager.dart';
import 'package:flutter_app/module/home_banner_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/module/home_data_entity.dart';

class HallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HallPageState();
}

class HallPageState extends State<HallPage> {
  List<HomeBannerData> images = new List();
  List<HomeDataDataData> datas = new List();

  /// 是否正在加载数据
  bool _isLoading = false;

  //listview控制器
  ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
    //滑到了底部，加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  Future _onRefresh() async {
    page =1;
    ApiService().banner((HomeBannerEntity homeBannerEntity) {
      if (homeBannerEntity != null) {
        if (homeBannerEntity.errorCode == 0) {
          if (homeBannerEntity.data.length > 0) {
            setState(() {
              images.clear();
              images.addAll(homeBannerEntity.data);
            });
          }
        } else {
          Fluttertoast.showToast(msg: homeBannerEntity.errorMsg);
        }
      }
    });
    ApiService().homedata(page.toString(), (HomeDataEntity homeDataEntity) {
      if (homeDataEntity != null) {
        if (homeDataEntity.errorCode == 0) {
          if (homeDataEntity.data.datas.length > 0) {
            setState(() {
              datas.clear();
              datas.addAll(homeDataEntity.data.datas);
            });
          }
        } else {
          Fluttertoast.showToast(msg: homeDataEntity.errorMsg);
        }
      }
    });
  }

  Future<Null> _getMore() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    page++;
    ApiService().homedata(page.toString(), (HomeDataEntity homeDataEntity) {
      if (homeDataEntity != null) {
        if (homeDataEntity.errorCode == 0) {
          if (homeDataEntity.data.datas.length > 0) {
            setState(() {
              datas.addAll(homeDataEntity.data.datas);
              _isLoading = false;
            });
          }else{
            //数据为空
            Fluttertoast.showToast(msg: "没有更多数据了");
          }
        } else {
          Fluttertoast.showToast(msg: homeDataEntity.errorMsg);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
            displacement: 120.0, // 默认40， 多添加的80为Header高度
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 0),
              itemBuilder: choiceItemWidget,
              itemCount: datas.length + 2
            ),
            onRefresh: _onRefresh
        )
    );
  }

  /**
   * 加载哪个子组件
   */
  Widget choiceItemWidget(BuildContext context, int position) {
    if (position == 0) {
      return banner();
    }
    if (position < datas.length - 1) {
      return Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            datas[position - 1].superChapterName,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ));
    }
  }

  Widget banner() {
    return Container(
      width: double.infinity,
      height: 180,
      child: Swiper(
        pagination: SwiperPagination(),
        control: SwiperControl(
          iconNext: null,
          iconPrevious: null,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (images[index] == null || images[index].imagePath == null) {
            return Container(color: Colors.grey[100]);
          } else {
            return GestureDetector(
              child: Image.network(
                  images[index].imagePath == null
                      ? 'http://via.placeholder.com/288x188'
                      : images[index].imagePath,
                  fit: BoxFit.fill),
              onTap: () {
                String newtitle = images[index].title;
                String newurl = images[index].url;
                Routers.router.navigateTo(context,
                    '${Routers.webViewPage}?title=${Uri.encodeComponent(newtitle)}&url=${Uri.encodeComponent(newurl)}');
              },
            );
          }
        },
        itemCount: images.length,
        autoplay: true,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
