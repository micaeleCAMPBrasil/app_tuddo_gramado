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
    return Column(
      children: [
        SizedBox(
          width: 1,
          height: 1,
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                  '${Config.urltuddogramado}?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            ),
            onWebViewCreated: (controller) {
              webView = controller;
            },
          ),
        ),
        SizedBox(
          width: 1,
          height: 1,
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                  '${Config.urltranfer}?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            ),
            onWebViewCreated: (controller) {
              webView = controller;
            },
          ),
        ),
        SizedBox(
          width: 1,
          height: 1,
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                  '${Config.urltuddoemdobro}?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            ),
            onWebViewCreated: (controller) {
              webView = controller;
            },
          ),
        ),
      ],
    );
  }
}
