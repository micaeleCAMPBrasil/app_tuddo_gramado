import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class LoginWordPress extends StatefulWidget {
  Usuario usuario;
  LoginWordPress({super.key, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _LoginWordPressState createState() => _LoginWordPressState();
}

class _LoginWordPressState extends State<LoginWordPress> {
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
            url: Uri.parse(
                '${Config.urltuddogramado}?is_api=true&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            headers: {
              "Authorization": '*',
              'user_token': widget.usuario.tokenTG,
            },
          ),
          onWebViewCreated: (controller) {
            webView = controller;
          },
          onReceivedHttpAuthRequest:
              (InAppWebViewController controller, challenge) async {
            return HttpAuthResponse(
              username: widget.usuario.email,
              password: widget.usuario.uid,
              action: HttpAuthResponseAction.PROCEED,
            );
          },
          onLoadStart: (InAppWebViewController controller, Uri? uri) async {},
          onProgressChanged: (controller, progres) {
            setState(() {
              progress = progres / 100;
            });
          },
        ),
        /*: Container(),
          jalogou
              ?*/
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(
                '${Config.urltuddoemdobro}?is_api=true&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            headers: {
              "Authorization": '*',
              'user_token': widget.usuario.tokenTD,
            },
          ),
          onWebViewCreated: (controller) {
            webView = controller;
          },
          onReceivedHttpAuthRequest:
              (InAppWebViewController controller, challenge) async {
            return HttpAuthResponse(
              username: widget.usuario.email,
              password: widget.usuario.uid,
              action: HttpAuthResponseAction.PROCEED,
            );
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
