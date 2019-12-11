import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/module/video_entity.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/utils/fluro_convert_util.dart';
import 'package:flutter_app/utils/time_util.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_package/chewie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

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
  String videoUrl ;
  List<Item> itemList = [];
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  bool isPlay = true;
  List list = List();
  String defaultCollextText ='+ 关注';
  Color color1 = Colors.black;
  bool isGuanzhu = false;
  bool isLove = false;
  int count = 0;
  String imagepath = 'assets/images/video/icon_like.png';

  @override
  void initState() {
    item = Item.fromJson(FluroConvertUtils.string2map(widget.itemJson));
    count = item.data.consumption.collectionCount;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
//    getVideoUrl();
    getChewieUrl();
    getAboutVideo();
  }

  /// 获取视频播放地址，并播放，默认播放高清视频
  /// chewie视频播放
  void getChewieUrl() {
    List<PlayInfo> playInfoList = item.data.playInfo;
    if (playInfoList.length >= 1) {
      for (var playInfo in playInfoList) {
        if (playInfo.type == 'high') {
          videoUrl = playInfo.url;
          videoPlayerController = VideoPlayerController.network(videoUrl);
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            aspectRatio: 16/9,
            autoPlay: true,
            looping: true,
            // 占位图
            placeholder: new Container(
              color: Colors.transparent,
            )
          );
        }
      }
    } else {
      videoUrl = item.data.playUrl;
      videoPlayerController = VideoPlayerController.network(videoUrl);
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: 16/9,
        autoPlay: true,
        looping: true,
        // 占位图
        placeholder: new Container(
          color: Colors.grey,
        )
      );
    }
  }

  ///ijkplayer视频播放
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


  Future getAboutVideo() async{
    ApiService().aboutVideo(item.data.id, (Issue issue) {
      if(issue != null && issue.itemList.length != 0) {
        setState(() {
          itemList.clear();
          itemList.addAll(issue.itemList);
        });
      }
    });
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
    videoPlayerController.dispose();
    chewieController.dispose();
    chewieController.pause();
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
              width: double.infinity,
//              child: IjkPlayer(mediaController: _controller),
              child: Chewie(
                controller: chewieController
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
                          defaultCollextText,
                          style: TextStyle(
                            fontSize: 12,
                            color: color1,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if(!isGuanzhu) {
                            defaultCollextText = '已关注';
                            color1 = Colors.grey[700];
                            isGuanzhu = true;
                          }else{
                            defaultCollextText = '+ 关注';
                            color1 = Colors.black;
                            isGuanzhu = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
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
                                GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        imagepath,
                                        width: 22,
                                        height: 22,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                          '$count',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if(!isLove) {
                                        imagepath = 'assets/images/video/ic_love.png';
                                        count += 1;
                                        isLove = true;
                                      }else{
                                        imagepath = 'assets/images/video/icon_like.png';
                                        count -= 1;
                                        isLove = false;
                                      }
                                    });
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/video/icon_share_white.png',
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
                                      'assets/images/video/icon_comment.png',
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
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context,index) {
                        if(itemList[index].type == 'videoSmallCard') {
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: 15,top: 10,right: 15),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          width: 135,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          imageUrl: itemList[index].data.cover.detail,
                                          errorWidget: (context, url,
                                              error) =>
                                              Image.asset(
                                                  'assets/images/video/img_load_fail.png'),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: Container(
                                              padding: EdgeInsets.all(3),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(2),
                                              ),
                                              child: Text(
                                                  TimeUtil.formatDuration(itemList[index].data.duration),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  )
                                              ),
                                            )
                                        ),
                                        Positioned(
                                          child: Offstage(
                                            offstage: list.contains(index) ? false : true,
                                            child: Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Image.asset("assets/images/video/ic_play.png",width: 14,height: 10,fit: BoxFit.fill),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 3),
                                                    child: Text("播放中...",style: TextStyle(color: Colors.white,fontSize: 10)),
                                                  )
                                                ],
                                              ),
                                            )
                                          ),
                                          left: 7.0,
                                          bottom: 10.0,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15),
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              itemList[index].data.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 15),
                                            child: Text(
                                              '#${itemList[index].data.category} / ${itemList[index].data.author.name}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    flex: 1,
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              List<PlayInfo> playInfoList = itemList[index].data.playInfo;
                              if (playInfoList.length >= 1) {
                                for (var playInfo in playInfoList) {
                                  if (playInfo.type == 'high') {
                                    String url = playInfo.url;
                                    setState(() {
                                      list.clear();
                                      list.add(index);
                                      refreshvideo(url);
                                    });
                                  }
                                }
                              }
                            },
                          );
                        }else{
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 15, top: 10, bottom: 10
                            ),
                            child: Text(
                              itemList[index].data.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          );
                        }
                      },
                      childCount: itemList.length
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refreshvideo(String url) {
    chewieController.dispose();
    videoPlayerController.dispose();
    videoPlayerController = VideoPlayerController.network(url);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: 16/9,
        autoPlay: true,
        looping: true,
        // 占位图
        placeholder: new Container(
          color: Colors.grey,
        )
    );
  }

}
