import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/providers/login_provider.dart';

class TambahAlamatPage extends StatefulWidget {
  @override
  _TambahAlamatPageState createState() => new _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  InAppWebViewController? _webViewController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          "http://10.10.10.90:3000/api/v2/map?lat=-7&lng=112&kategori=customer&id=${loginProvider.loginModel.data?.id}")),
                  initialOptions: InAppWebViewGroupOptions(
                    android: AndroidInAppWebViewOptions(
                      // allowFileAccessFromFileURLs: true,
                      // allowUniversalAccessFromFileURLs: true,
                      mixedContentMode:
                          AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                    ),
                  ),

                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  // onLoadStart: (InAppWebViewController controller, String url) {
                  //   setState(() {
                  //     this.url = url;
                  //   });
                  // },
                  // onLoadStop:
                  //     (InAppWebViewController controller, String url) async {
                  //   setState(() {
                  //     this.url = url;
                  //   });
                  // },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController?.goBack();
                    }
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController?.goForward();
                    }
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController?.reload();
                    }
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
