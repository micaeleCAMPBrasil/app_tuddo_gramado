import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LogOutWordPress extends StatefulWidget {
  const LogOutWordPress({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogOutWordPressState createState() => _LogOutWordPressState();
}

class _LogOutWordPressState extends State<LogOutWordPress> {
  @override
  void initState() {
    super.initState();
  }

  late InAppWebViewController webView;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('${Config.urltuddogramado}?is_api=true&acao=logout'),
          ),
          onWebViewCreated: (controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, Uri? uri) async {},
          onProgressChanged: (controller, progres) {
            setState(() {
              progress = progres / 100;
            });
          },
        ),
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('${Config.urltuddoemdobro}?is_api=true&acao=logout'),
          ),
          onWebViewCreated: (controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, Uri? uri) async {},
          onProgressChanged: (controller, progres) {
            setState(() {
              progress = progres / 100;
            });
          },
        ),
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('${Config.urltranfer}?is_api=true&acao=logout'),
          ),
          onWebViewCreated: (controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, Uri? uri) async {},
          onProgressChanged: (controller, progres) {
            setState(() {
              progress = progres / 100;
            });
          },
        ),
      ],
    );
  }
}
