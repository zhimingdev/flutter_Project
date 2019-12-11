import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/router/Routers.dart';


class DataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DataPageState();
}

class DataPageState extends State<DataPage> {
  String dizhi = '定位中...';
  String city = '';
  static const MethodChannel _platform =
      const MethodChannel('com.example.flutter_app.MapRegistrant');
  static const EventChannel eventchannel =
      const EventChannel('flutter_event_channel');

  void _onData(jsonObject) {
    setState(() {
      Map<String,dynamic> map = json.decode(jsonObject);
      dizhi = map['address'];
      city = map['city'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventchannel.receiveBroadcastStream().listen(_onData);
    getInfo();
  }

  //在Flutter端的MethodChannel设置MethodHandler，去处理Native申请要调用的method的值。
  Future<Null> getInfo() async {
    var add = await _platform.invokeMethod('getAddress');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 15, left: 15),
                  child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on, color: Colors.blue, size: 25),
                              Container(
                                child: Text(dizhi,
                                    style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                          onTap: () {
                            Routers.router.navigateTo(context, Routers.city+'?city=${Uri.encodeComponent(city)}');
                          },
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 15,right: 15),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.white),
                            child: Stack(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 10,top: 6,bottom: 6),
                                      child: Icon(Icons.search,
                                        color: Colors.grey[500],
                                        size: 15,
                                      ),
                                    ),
                                    Container(
                                      child: Text('搜索',style: TextStyle(fontSize: 12,color: Colors.grey[500])),
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 10),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  ),
            ],
          )),
    );
  }
}
