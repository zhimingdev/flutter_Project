import 'package:flutter/material.dart';
import 'package:flutter_app/res/colors.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AccountRecordListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountRecordListPageState();
}

class _AccountRecordListPageState extends State<AccountRecordListPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "账户流水",
        isBack: true,
        backgroundColor: Colours.material_bg,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return StickyHeader(
                header: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  color: Colours.bg_gray_,
                  padding: const EdgeInsets.only(left: 16.0),
                  height: 34.0,
                  child: Text("2018/06/0${index + 1}"),
                ),
                content: _buildItem(index)
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    List<Widget> list = List.generate(index + 1, (i) {
      return Container(
        height: 72.0,
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colours.material_bg,
          border: Border(
              bottom:
                  Divider.createBorderSide(context,  width: 0.8)
          )
        ),
        child: Stack(
          children: <Widget>[
            Text(i % 2 == 0 ? "采购订单结算营收" : '提现'),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Text(i % 2 == 0 ? "+10.00" : "-10.00",
                  style: i % 2 == 0
                      ? TextStyle(
                          fontWeight: FontWeight.bold, color: Colours.red)
                      : TextStyles.textBold14),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Text("2019-11-25 14:11:3$i",style: TextStyles.textGray14)
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Text("余额: 120$i.00",style: TextStyles.textGray14)
            )
          ],
        ),
      );
    });
    return Column(
      children: list
    );
  }
}
