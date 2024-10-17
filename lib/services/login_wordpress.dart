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
  //late WebViewController _controllerweb;
  @override
  void initState() {
    super.initState();
    /*_controllerweb = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));*/
  }

  late InAppWebViewController webView;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return /*!kIsWeb
        ? */
        Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(
                '${Config.urltuddogramado}?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            headers: {
              "Authorization": '*',
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
                '${Config.urltuddoemdobro}?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            headers: {
              "Authorization": '*',
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
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(
                '${Config.urltranfer}?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}'),
            headers: {
              "Authorization": '*',
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
    ); /*
        : Scaffold(
            appBar: AppBar(title: const Text('Flutter Simple Example')),
            body: Webview(
              // ?is_api=true&acao=login&user=${widget.usuario.email}&pass=${widget.usuario.uid}
              url: Config.urltranfer,
              appName: '',
            ),
          );*/
  }
}
