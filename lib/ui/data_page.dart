import 'dart:async';
import 'dart:convert';

import 'package:amap_location_plugin/amap_location_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/module/city_model.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DataPageState();
}

class DataPageState extends State<DataPage> {
  String dizhi = '定位中...';
  String city = '';

  AmapLocationPlugin _amapLocation = AmapLocationPlugin();
  StreamSubscription<String> _locationSubscription;


  void onData(jsonObject) {
    Map<String,dynamic> map = json.decode(jsonObject);
    dizhi = map['address'];
    city = map['city'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startLocation();
    _locationSubscription = _amapLocation.onLocationChanged.listen((String location) {
      print('=================$location');
      setState(() {
        city = json.decode(location)['city'];
        dizhi = json.decode(location)['info'];
      });
    });
  }

  Future<void> startLocation() async {
    await _amapLocation.startLocation;
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
                            Routers.router.navigateTo(context, Routers.city+'?city=${Uri.encodeComponent(city)}').then((value) {
                              CityInfo cityinfo = value ;
                              if(cityinfo != null) {
                                Fluttertoast.showToast(msg: cityinfo.name);
                              }
                            });
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
