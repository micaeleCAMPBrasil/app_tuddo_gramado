// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, file_names
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class InAppView extends StatefulWidget {
  int page, index;
  String url;
  Map data;

  InAppView({
    super.key,
    required this.page,
    required this.index,
    required this.url,
    required this.data,
  });

  @override
  _InAppViewState createState() => _InAppViewState();
}

class _InAppViewState extends State<InAppView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HeadlessInAppWebView? headlessWebView;
  PullToRefreshController? pullToRefreshController;
  InAppWebViewController? webViewController;

  int progress = 0;
  bool convertFlag = false;

  bool loading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            options: PullToRefreshOptions(color: primaryColor),
            /*settings: PullToRefreshSettings(
              color: color00,
            ),*/
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );

    // ########## -- Read here --- ####
    // this is us creating a full fleged webview but headless

    /*headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      initialSettings: InAppWebViewSettings(isInspectable: kDebugMode),
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        webViewController = controller;
        /*const snackBar = SnackBar(
          content: Text('HeadlessInAppWebView created!'),
          duration: Duration(microseconds: 100),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
      },
      onLoadStart: (controller, url) async {
        setState(() {
          widget.url = url?.toString() ?? '';
        });
      },
      onProgressChanged: (controller, progress) {
        setState(() {
          this.progress = progress;
        });
        debugPrint('Progress - $progress');
      },
      onLoadStop: (controller, url) async {
        setState(() {
          widget.url = url?.toString() ?? '';
        });
      },
    );*/

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
    webViewController?.dispose();
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (!await webViewController!.canGoBack()) {
            /*Navigator.pushReplacement(
            context,
            widget.routa,
          );*/
            Provider.of<ControlNav>(context, listen: false)
                .updateIndex(widget.page, widget.index);
          } else {
            webViewController!.goBack();
          }
          return false;
        },
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.url),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
          },
        ),
      ),
    );*/

    return WillPopScope(
      onWillPop: () async {
        /*if (!await webViewController!.canGoBack()) {
          /*Navigator.pushReplacement(
            context,
            widget.routa,
          );*/
          Provider.of<ControlNav>(context, listen: false)
              .updateIndex(widget.page, widget.index);
        } else {
          webViewController!.goBack();
        }*/

        webViewController!.goBack();
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        /*appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MyAppBar(
            backgroundColor: color00,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () async {
                /*if (!await webViewController!.canGoBack()) {
                  /*Navigator.pushReplacement(
                    context,
                    widget.routa,
                  );*/

                } else {}*/
                /*Provider.of<ControlNav>(context, listen: false)
                    .updateIndex(widget.page, widget.index);*/
                //webViewController!.goBack();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),*/
        body: Stack(
          children: [
            InAppWebView(
              pullToRefreshController: pullToRefreshController,
              initialUrlRequest: URLRequest(
                url: WebUri(widget.url),
              ),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  textZoom: 120,
                  geolocationEnabled: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              androidOnGeolocationPermissionsShowPrompt:
                  (InAppWebViewController controller, String origin) async {
                return GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: true, retain: true);
              },
              onReceivedHttpAuthRequest:
                  (InAppWebViewController controller, challenge) async {
                return HttpAuthResponse(
                  username: widget.data['usuario'],
                  password: widget.data['senha'],
                  action: HttpAuthResponseAction.PROCEED,
                );
              },
              onLoadStart:
                  (InAppWebViewController controller, Uri? uri) async {},
              onProgressChanged: (controller, progres) {
                setState(() {
                  progress = progres;
                });
              },
            ),
            /*progress < 100
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          //value: double.parse(progress.toString()),
                          //backgroundColor: Colors.redAccent.withOpacity(0.2),
                        ),
                      ),
                    ],
                  )
                : Container(),*/
            loading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          //value: double.parse(progress.toString()),
                          //backgroundColor: Colors.redAccent.withOpacity(0.2),
                        ),
                      ),
                    ],
                  )
                : Container(),
            /*progress < 100
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            //value: double.parse(progress.toString()),
                            //backgroundColor: Colors.redAccent.withOpacity(0.2),
                            ),
                      ),
                    ],
                  )
                : InAppWebView(
                    headlessWebView: headlessWebView,
                    onWebViewCreated: (controller) {
                      headlessWebView = null;
                      webViewController = controller;

                      /*const snackBar = SnackBar(
                        content: Text(
                            'HeadlessInAppWebView converted to InAppWebView!'),
                        duration: Duration(seconds: 1),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        widget.url = url?.toString() ?? "";
                      });
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress;
                      });
                    },
                    onLoadStop: (controller, url) {
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        widget.url = url?.toString() ?? "";
                      });
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                  ),*/
          ],
        ),

        /* Scaffold(
          appBar: AppBar(
              title: const Text(
            "HeadlessInAppWebView to InAppWebView",
            textScaleFactor: .8,
          )),
          body: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    "URL: ${(widget.url.length > 40) ? "${widget.url.substring(0, 40)}..." : widget.url} - $progress%"),
              ),
              !convertFlag
                  ? Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            var headlessWebView = this.headlessWebView;
                            if (headlessWebView != null &&
                                !headlessWebView.isRunning()) {
// ##### loading the headlesswebview in bg
                              await headlessWebView.run();
                            }
                          },
                          child: const Text("Run HeadlessInAppWebView")),
                    )
                  : Container(),
              !convertFlag
                  ? Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (!convertFlag) {
                              setState(() {
                                convertFlag = true;
                              });
                            }
                          },
                          child: const Text("Convert to InAppWebView")),
                    )
                  : Container(),
              convertFlag
                  ? Expanded(
                      child: InAppWebView(
// ### --- this is how to convert it to a regular visible webview
                        headlessWebView: headlessWebView,
                        onWebViewCreated: (controller) {
                          headlessWebView = null;
                          webViewController = controller;

                          const snackBar = SnackBar(
                            content: Text(
                                'HeadlessInAppWebView converted to InAppWebView!'),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            widget.url = url?.toString() ?? "";
                          });
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController?.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress;
                          });
                        },
                        onLoadStop: (controller, url) {
                          pullToRefreshController?.endRefreshing();
                          setState(() {
                            widget.url = url?.toString() ?? "";
                          });
                        },
                        onReceivedError: (controller, request, error) {
                          pullToRefreshController?.endRefreshing();
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),*/
        //),
      ),
    );
  }

  Widget backButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!await webViewController!.canGoBack()) {
          debugPrint('Cannot navigate back!');
        } else {
          webViewController!.goBack();
        }
      },
      child: const Icon(Icons.navigate_before),
    );
  }
}
