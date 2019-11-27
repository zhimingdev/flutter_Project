import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:flutter_app/utils/theme_utils.dart';
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
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  //listview控制器
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int _maxPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
//    滑到了底部，加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }

      //当前位置是否超过屏幕高度
      if (_scrollController.offset < 200 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 200 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  Future _onRefresh() async {
    page = 1;
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
          _maxPage = homeDataEntity.data.pageCount;
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
          } else {
            //数据为空
            Fluttertoast.showToast(msg: "没有更多数据了");
          }
        } else {
          Fluttertoast.showToast(msg: homeDataEntity.errorMsg);
        }
      }
    });
  }

  bool _hasMore() {
    return page < _maxPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          displacement: 40.0, // 默认40， 多添加的80为Header高度
          child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 0),
              itemBuilder: choiceItemWidget,
              itemCount: datas.length + 2),
          onRefresh: _onRefresh),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              }),
    );
  }

  ///加载哪个子组件
  // ignore: missing_return
  Widget choiceItemWidget(BuildContext context, int position) {
    final style = ThemeUtils.isDark(context)
        ? TextStyles.textGray14
        : const TextStyle(color: Color(0x8A000000));
    if (position == 0) {
      return banner();
    }
    if (position < datas.length + 1) {
      return InkWell(
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      datas[position - 1].author,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        datas[position - 1].niceDate,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                )),
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                datas[position - 1].title,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3D4E5F),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                datas[position - 1].superChapterName,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 0.6,
              width: double.infinity,
              child: Divider(),
            )
          ],
        ),
        onTap: () {
          String title = datas[position-1].title;
          String url = datas[position-1].link;
          Routers.router.navigateTo(context, '${Routers.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
        },
      );
    }
    if (position == datas.length + 1) {
      if (_hasMore()) {
        return Container(
          width: double.infinity,
          height: 50,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CupertinoActivityIndicator(),
                Text(
                  "正在加载中...",
                  style: style,
                )
              ]),
        );
      }
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
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            if (images == null ||
                images.isEmpty ||
                images[index] == null ||
                images[index].imagePath == null) {
              return Container(color: Colors.grey[100]);
            } else {
              return GestureDetector(
                child: Image.network(images[index].imagePath, fit: BoxFit.fill),
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
        ));
  }

  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
