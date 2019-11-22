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

class HallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HallPageState();

}

class HallPageState extends State<HallPage> {

  List<HomeBannerData> images = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images.add(null);
    getBanner();
  }

  void getBanner() async{
    ApiService().banner((HomeBannerEntity homeBannerEntity) {
      if(homeBannerEntity != null) {
        if(homeBannerEntity.errorCode == 0) {
          if(homeBannerEntity.data.length > 0) {
            setState(() {
              images = homeBannerEntity.data;
            });
          }
        }else{
          Fluttertoast.showToast(msg: homeBannerEntity.errorMsg);
        }
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
            banner()
          ],
        ),
      ),
    );
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
            if(images[index] == null || images[index].imagePath == null) {
              return Container(
                color: Colors.grey[100]
              );
            }else{
              return GestureDetector(
                child: Image.network(
                  images[index].imagePath == null ? 'http://via.placeholder.com/288x188' : images[index].imagePath,
                  fit: BoxFit.fill
                ),
                onTap: () {
                  String newtitle = images[index].title;
                  String newurl = images[index].url;
                  Routers.router.navigateTo(context, '${Routers.webViewPage}?title=${Uri.encodeComponent(newtitle)}&url=${Uri.encodeComponent(newurl)}',transition: TransitionType.inFromRight);
                },
              );
            }
        },
        itemCount: images.length,
        autoplay: true,
      ),
    );
  }

}