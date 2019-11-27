import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/module/video_entity.dart';
import 'package:flutter_app/utils/fluro_convert_util.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

/// 视频详情页
class VideoDetailsPage extends StatefulWidget {
  final String itemJson;

  VideoDetailsPage({Key key, this.itemJson}) : super(key: key);

  @override
  State<StatefulWidget> createState() => VideoDetailsPageState();
}

class VideoDetailsPageState extends State<VideoDetailsPage>
    with WidgetsBindingObserver {
  IjkMediaController _controller = IjkMediaController();

  Item item;
  String videoUrl;

  @override
  void initState() {
    item = Item.fromJson(FluroConvertUtils.string2map(widget.itemJson));
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getVideoUrl();
  }

  /// 获取视频播放地址，并播放，默认播放高清视频
  void getVideoUrl() {
    List<PlayInfo> playInfoList = item.data.playInfo;
    if (playInfoList.length >= 1) {
      for (var playInfo in playInfoList) {
        if (playInfo.type == 'high') {
          videoUrl = playInfo.url;
          _controller.setNetworkDataSource(
            videoUrl,
            autoPlay: true,
          );
        }
      }
    } else {
      videoUrl = item.data.playUrl;
      _controller.setNetworkDataSource(
        videoUrl,
        autoPlay: true,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("pageState: $state");
    if (state == AppLifecycleState.paused) {
      if (_controller.isPlaying) {
        _controller.pause();
      }
    }
  }

  /// 释放资源
  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// 设置背景图片
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              '${item.data.cover.blurred}/thumbnail/${ScreenUtil.getScreenH(context)}x${ScreenUtil.getScreenW(context)}',
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            /// 视频播放器
            Container(
              height: 230,
              child: IjkPlayer(mediaController: _controller),
            ),
            Flexible(
              flex: 1,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// 标题栏
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                              bottom: 5,
                            ),
                            child: Text(
                              item.data.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),

                          /// 标签/时间栏
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              '#${item.data.category} / ${DateUtil.formatDateMs(item.data.author.latestReleaseTime, format: 'yyyy/MM/dd HH:mm')}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          /// 视频描述
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            child: Text(
                              item.data.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          /// 点赞、分享、评论栏
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/icon_like.png',
                                      width: 22,
                                      height: 22,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Text(
                                        '${item.data.consumption.collectionCount}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'images/icon_share_white.png',
                                        width: 22,
                                        height: 22,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                          '${item.data.consumption.shareCount}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/icon_comment.png',
                                      width: 22,
                                      height: 22,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Text(
                                        '${item.data.consumption.replyCount}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(
                              height: .5,
                              color: Color(0xFFDDDDDD),
                            ),
                          ),

                          /// 作者信息
                          InkWell(
                            onTap: () {
                              String itemJson =
                                  FluroConvertUtils.object2string(item);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 15,
                                top: 10,
                                right: 15,
                                bottom: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      width: 40,
                                      height: 40,
                                      imageUrl: item.data.author.icon,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        backgroundColor: Colors.deepPurple[600],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item.data.author.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 3),
                                            child: Text(
                                              item.data.author.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        '+ 关注',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF4F4F4),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    onTap: (() {
                                      print('点击关注');
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Divider(
                            height: .5,
                            color: Color(0xFFDDDDDD),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
