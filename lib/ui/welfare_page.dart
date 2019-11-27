import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/res/colors.dart';
import 'package:flutter_app/utils/fluro_convert_util.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:flutter_app/utils/time_util.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/module/welfare_entity.dart';
import 'package:flutter_app/module/video_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/http/dio_manager.dart';
import 'package:flutter_app/router/Routers.dart';

class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelfarePageState();
}

// 继承SingleTickerProviderStateMixin，提供单个Ticker（每个动画帧调用它的回调一次）
class WelfarePageState extends State<WelfarePage>
    with TickerProviderStateMixin {
  List<String> tabList;
  TabController mController;
  int _currentIndex = 0; //选中下标
  int page = 1;
  int videopage = 1;
  List<WelfareResult> images = new List();
  List<Item> videos = new List();
  ScrollController controller = ScrollController();
  String data = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabList = new List();
    tabList.add("养眼");
    tabList.add("休息视频");
    mController = TabController(length: tabList.length, vsync: this);
    mController.addListener(() {
      //滑动和点击都执行代码块且只有一次
      if (mController.index.toDouble() == mController.animation.value) {
        setState(() {
          _currentIndex = mController.index;
          if (_currentIndex == 0) {
            getImageData();
          } else {
            getVideoData();
          }
        });
      }
    });
    getImageData();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (_currentIndex == 0) {
          getImageDataMore();
        } else {
          getVideoDataMore();
        }
      }
    });
  }

  Future getImageData() async {
    page = 1;
    ApiService().welfare(page, (WelfareEntity welfareEntity) {
      if (welfareEntity != null) {
        if (!welfareEntity.error) {
          setState(() {
            images.clear();
            images.addAll(welfareEntity.results);
          });
        } else {
          Fluttertoast.showToast(msg: "请求失败");
        }
      }
    });
  }

  Future getImageDataMore() async {
    page++;
    ApiService().welfare(page, (WelfareEntity welfareEntity) {
      if (welfareEntity != null) {
        if (!welfareEntity.error) {
          setState(() {
            images.addAll(welfareEntity.results);
          });
        } else {
          Fluttertoast.showToast(msg: "请求失败");
        }
      }
    });
  }

  Future getVideoData() async {
    ApiService().video("num=1", (VideoEntity videoEntity) {
      if (videoEntity != null) {
        if (videoEntity.issueList != null &&
            videoEntity.issueList.length != 0) {
          var list = videoEntity.issueList[0].itemList;
          data = Uri.parse(videoEntity.nextPageUrl).queryParameters['date'];
          print('========>$data');
          list.removeWhere((item) {
            return item.type == 'banner2'|| item.type == 'textHeader';
          });
          setState(() {
            videos.clear();
            videos.addAll(list);
          });
        } else {
          Fluttertoast.showToast(msg: "请求失败");
        }
      }
    });
  }

  Future getVideoDataMore() async {
    ApiService().video("date=$data&num=1", (VideoEntity videoEntity) {
      print('========>date=$data&num=1');
      if (videoEntity != null) {
        if (videoEntity.issueList != null &&
            videoEntity.issueList.length != 0) {
          var list = videoEntity.issueList[0].itemList;
          data = Uri.parse(videoEntity.nextPageUrl).queryParameters['date'];
          list.removeWhere((item) {
            return item.type == 'banner2' || item.type == 'textHeader';
          });
          setState(() {
            videos.addAll(list);
          });
        } else {
          Fluttertoast.showToast(msg: "请求失败");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("福利",
                style: TextStyle(color: Colors.black, fontSize: 18.0)),
            centerTitle: true,
            backgroundColor: Colors.white,
            bottom: TabBar(
                controller: mController,
                labelColor: Colors.red,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyle(fontSize: 14.0),
                labelStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                tabs: tabList.map((item) {
                  return Tab(text: item);
                }).toList()),
          ),
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.15)),
      body: Container(
        child: TabBarView(
            controller: mController,
            children: tabList.map((String item) {
              return _currentIndex == 0
                  ? RefreshIndicator(
                      displacement: 40.0,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0),
                          itemBuilder: (_, position) {
                            if (images == null || images[position] == null) {
                              return Container(
                                height: 80,
                                color: Colors.grey[100],
                              );
                            } else {
                              return Container(
                                height: 120.0,
                                child: Image.network(images[position].url,
                                    fit: BoxFit.fill),
                              );
                            }
                          },
                          itemCount: images.length,
                          controller: controller
                      ),
                      onRefresh: getImageData,
                    )
                  : RefreshIndicator(
                      child: ListView.builder(
                        controller: controller,
                        itemBuilder: (_, position) {
                          if (videos == null) {
                            return Container(
                              color: Colors.grey[400],
                            );
                          } else {
                            return Container(
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15, right: 15, top: 10),
                                      child: Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                            child: CachedNetworkImage(
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              imageUrl: videos[position].data.cover.feed,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/video/img_load_fail.png'),
                                            ),
                                            onTap: () {
                                              String itemJson =
                                                  FluroConvertUtils
                                                      .object2string(
                                                          videos[position]);
                                              Routers.router.navigateTo(
                                                context,
                                                Routers.video + "?itemJson=$itemJson",
                                                transition: TransitionType.inFromRight,
                                              );
                                            },
                                          ),
                                          Positioned(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 15,
                                                top: 10,
                                                bottom: 10,
                                                right: 15,
                                              ),
                                              height: 200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 35,
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Text(
                                                            videos[position]
                                                                .data
                                                                .category,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Color(0x4DFAEBD7),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color(0x4DCD8C95),
                                                              Color(0x4DF0FFFF)
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          child: Text(
                                                            TimeUtil.formatDuration(
                                                                videos[position]
                                                                    .data
                                                                    .duration),
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black26,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ClipOval(
                                            child: GestureDetector(
                                              child: CachedNetworkImage(
                                                imageUrl: videos[position]
                                                    .data
                                                    .author
                                                    .icon,
                                                width: 40,
                                                height: 40,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  backgroundColor:
                                                      Colors.deepPurple[600],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                                right: 15,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    videos[position].data.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2, bottom: 2)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        videos[position]
                                                            .data
                                                            .author
                                                            .name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          GestureDetector(
                                            child: Image.asset(
                                              'assets/images/video/icon_share.png',
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                          }
                        },
                        itemCount: videos.length,
                      ),
                      onRefresh: () {},
                    );
            }).toList()),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
