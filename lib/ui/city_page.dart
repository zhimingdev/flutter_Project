import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/module/city_model.dart';
import 'package:flutter_app/router/Routers.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:lpinyin/lpinyin.dart';

class CityPage extends StatefulWidget{

  final String city;
  CityPage(this.city);

  @override
  State<StatefulWidget> createState() => _CityPageState();

}

class _CityPageState extends State<CityPage> {

  List<CityInfo> _cityList = List();
  List<CityInfo> _hotCityList = List();
  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _hotCityList.add(CityInfo(name: "北京市", tagIndex: "★"));
    _hotCityList.add(CityInfo(name: "广州市", tagIndex: "★"));
    _hotCityList.add(CityInfo(name: "成都市", tagIndex: "★"));
    _hotCityList.add(CityInfo(name: "深圳市", tagIndex: "★"));
    _hotCityList.add(CityInfo(name: "杭州市", tagIndex: "★"));
    _hotCityList.add(CityInfo(name: "武汉市", tagIndex: "★"));

    //加载城市列表
    rootBundle.loadString('assets/data/china.json').then((value) {
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      list.forEach((value) {
        _cityList.add(CityInfo(name: value['name']));
      });
      _handleList(_cityList);
      setState(() {
        _suspensionTag = _hotCityList[0].getSuspensionTag();
      });
    });
  }

  void _handleList(List<CityInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin =
      PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(CityInfo model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              print("OnItemClick: $model");
              Navigator.pop(context, model);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBar(
        isBack: true,
        centerTitle: '城市列表',
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15.0),
                    height: 50.0,
                    child: Text("当前城市: ${widget.city}"),
                  ),
                  flex: 1,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add_location,color: Colors.blue,size: 20),
                        Text('重新定位',style: TextStyle(color: Colors.blue,fontSize: 14))
                      ],
                    ),
                    onTap: () {
                      Routers.router.navigateTo(context, Routers.map);
                    },
                  ),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: AzListView(
                data: _cityList,
                topData: _hotCityList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                //showCenterTip: false,
              )
            ),
          ],
        ),
      ),
    );
  }

}