import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';

class CommonWebview extends StatefulWidget {
  final String url;
  final String title;

  const CommonWebview({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommonWebviewPage();
}

class _CommonWebviewPage extends State<CommonWebview> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: WebviewScaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 20),
              onPressed: (){
                Navigator.of(context).pop();
              }
          ),
          centerTitle: true,
          title: Text(widget.title,style: TextStyle(color: Colors.black,fontSize: 18)),
          elevation: 2.0,
        ),
        url: "http://www.baidu.com",
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
