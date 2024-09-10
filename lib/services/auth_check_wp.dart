import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class LoginWP extends StatefulWidget {
  String usuario, senha;

  LoginWP({
    super.key,
    required this.usuario,
    required this.senha,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginWPState createState() => _LoginWPState();
}

class _LoginWPState extends State<LoginWP> {
  late APIService apiService;

  String token = "";

  String url = "https://tuddogramado.com.br/wp-login.php";
  double progress = 0;

  late InAppWebViewController webView;
  HeadlessInAppWebView? headlessWebView;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    apiService = APIService();

    /*Timer(
      const Duration(seconds: 10),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
                //usuario: widget.usuario,
                //senha: widget.senha,
                ),
          ),
        );
      },
    );*/

    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://tuddogramado.com.br/wp-login.php")),
      onWebViewCreated: (controller) {
        webView = controller;
        const snackBar = SnackBar(
          content: Text('HeadlessInAppWebView created!'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onLoadStart: (controller, url) async {
        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
      onProgressChanged: (controller, progres) {
        setState(() {
          progress = progres / 100;
        });
      },
      onLoadStop: (controller, url) async {
        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  loading() {
    return Scaffold(
      backgroundColor: color00,
      body: Center(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                    '$url?is_api=true&user=${widget.usuario}&pass=${widget.senha}'),
                headers: {
                  "Authorization": '*',
                  'user_token': token,
                },
              ),
              onWebViewCreated: (controller) {
                webView = controller;
              },
              onReceivedHttpAuthRequest:
                  (InAppWebViewController controller, challenge) async {
                return HttpAuthResponse(
                  username: widget.usuario,
                  password: widget.senha,
                  action: HttpAuthResponseAction.PROCEED,
                );
              },
              onLoadStart:
                  (InAppWebViewController controller, Uri? uri) async {},
              onProgressChanged: (controller, progres) {
                setState(() {
                  progress = progres / 100;
                });
              },
            ),
            /*Container(
              color: color00,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Aguarde... estamos efetuando o login.'),
                  )
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginWP2 extends StatefulWidget {
  String usuario, senha;

  LoginWP2({
    super.key,
    required this.usuario,
    required this.senha,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginWP2State createState() => _LoginWP2State();
}

class _LoginWP2State extends State<LoginWP2> {
  late APIService apiService;

  String token = "";

  @override
  void initState() {
    apiService = APIService();

    /* Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(),
          ),
        );
      },
    );*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  String url2 = "https://d.tuddogramado.com.br/wp-login.php";
  double progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  loading() {
    return Scaffold(
      backgroundColor: color00,
      body: Center(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                    '$url2?is_api=true&user=${widget.usuario}&pass=${widget.senha}'),
                headers: {
                  "Authorization": '*',
                  'user_token': token,
                },
              ),
              onWebViewCreated: (controller) {
                webView = controller;
              },
              onReceivedHttpAuthRequest:
                  (InAppWebViewController controller, challenge) async {
                return HttpAuthResponse(
                  username: widget.usuario,
                  password: widget.senha,
                  action: HttpAuthResponseAction.PROCEED,
                );
              },
              onLoadStart:
                  (InAppWebViewController controller, Uri? uri) async {},
              onProgressChanged: (controller, progres) {
                setState(() {
                  progress = progres / 100;
                });
              },
            ),
            /*Container(
              color: color00,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Aguarde... estamos efetuando o login.'),
                  )
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
