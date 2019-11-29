import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/module/mine_integral_entity.dart';
import 'package:flutter_app/module/mine_integral_rank_entity.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:flutter_app/utils/theme_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MineIntegralRank extends StatefulWidget {
  final MineIntegralData data;

  MineIntegralRank(this.data);

  @override
  State<StatefulWidget> createState() => _MineIntegralRankPage();
}

class _MineIntegralRankPage extends State<MineIntegralRank> {
  int page = 1;
  List<MineIntegralRankDataData> list = List();
  int maxpage = 0;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRankData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMoreRank();
      }
    });
  }

  Future getRankData() async {
    page = 1;
    ApiService().userRank(page,
        (MineIntegralRankEntity mineIntegralRankEntity) {
      if (mineIntegralRankEntity != null &&
          mineIntegralRankEntity.errorCode == 0) {
        if (mineIntegralRankEntity.data.datas.length > 0) {
          maxpage = mineIntegralRankEntity.data.pageCount;
          setState(() {
            list.clear();
            list.addAll(mineIntegralRankEntity.data.datas);
          });
        }
      } else {
        Fluttertoast.showToast(msg: mineIntegralRankEntity.errorMsg);
      }
    });
  }

  Future getMoreRank() async {
    ++page;
    ApiService().userRank(page,
        (MineIntegralRankEntity mineIntegralRankEntity) {
      if (mineIntegralRankEntity != null &&
          mineIntegralRankEntity.errorCode == 0) {
        if (mineIntegralRankEntity.data.datas.length > 0) {
          setState(() {
            list.addAll(mineIntegralRankEntity.data.datas);
          });
        }
      } else {
        Fluttertoast.showToast(msg: mineIntegralRankEntity.errorMsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Column(
        children: <Widget>[
          Container(
              height: 45.0,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.only(
                  top: MediaQueryData.fromWindow(window).padding.top),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text("积分排行",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15),
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Image.asset("assets/images/ic_back_black.png",
                          width: 20, height: 20),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            height: 40,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("排名",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16))),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("昵称",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16))),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("等级",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16))),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("积分",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16))),
                  flex: 1,
                )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: widget.data.rank == 1
                          ? Image.asset("assets/images/mine/ic_one.png",
                          width: 30, height: 30)
                          : (widget.data.rank == 2
                          ? Image.asset("assets/images/mine/ic_two.png",
                          width: 30, height: 30)
                          : (widget.data.rank == 3
                          ? Image.asset("assets/images/mine/ic_three.png",
                          width: 30, height: 30)
                          : Text(widget.data.rank.toString(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 16))))),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(widget.data.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14))),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.data.level.toString() ?? 0,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      )),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(widget.data.coinCount.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16))),
                  flex: 1,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: RefreshIndicator(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    controller: scrollController,
                    itemBuilder: itemView,
                    itemCount: list.length + 1,
                  ),
                  onRefresh: getRankData),
            ),
            flex: 1,
          ),
        ],
      )),
    );
  }

  bool _hasMore() {
    return page < maxpage;
  }

  Widget itemView(BuildContext context, int index) {
    final style = ThemeUtils.isDark(context)
        ? TextStyles.textGray14
        : const TextStyle(color: Color(0x8A000000));
    if (index < list.length) {
      if (list == null) {
        return Container(
          color: Colors.grey[400],
        );
      } else {
        return Container(
          color: Colors.white,
          height: 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: index == 0
                        ? Image.asset("assets/images/mine/ic_one.png",
                            width: 30, height: 30)
                        : (index == 1
                            ? Image.asset("assets/images/mine/ic_two.png",
                                width: 30, height: 30)
                            : (index == 2
                                ? Image.asset("assets/images/mine/ic_three.png",
                                    width: 30, height: 30)
                                : Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16))))),
                flex: 1,
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(list[index].username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14))),
                flex: 1,
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      list[index].level.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    )),
                flex: 1,
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(list[index].coinCount.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16))),
                flex: 1,
              )
            ],
          ),
        );
      }
    }
    if (index == list.length) {
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
}
