import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  final Completer<WebViewController> _webcontrol = Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /// FutureBuilder关联之前的小操作,类似Android的AsyncTask    WillPopScope  双击/单击操作
    return FutureBuilder<WebViewController>(
      future: _webcontrol.future,
      builder: (context,snapshot){
        return WillPopScope(
            child: Scaffold(
              appBar: MyAppBar(
                centerTitle: widget.title,
                isBack: true,
              ),
              body: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webcontrol.complete(webViewController);
                },
              ),
            ),
            onWillPop: () async{
              if(snapshot.hasData) {
                bool canGoBack = await snapshot.data.canGoBack();
                if(canGoBack) {
                  // 网页可以返回时，优先返回上一页
                  snapshot.data.goBack();
                  return Future.value(false);
                }else{
                  /// Future返回一个延迟对象和awiat,async作用
                  return Future.value(true);
                }
              }else{
                return Future.value(true);
              }
            }
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
