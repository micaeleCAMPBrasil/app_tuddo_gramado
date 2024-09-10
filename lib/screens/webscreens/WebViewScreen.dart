// ignore_for_file: library_private_types_in_public_api, file_names, deprecated_member_use, use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewScreensss extends StatefulWidget {
  String url;
  int index;
  String? token;

  WebViewScreensss({
    super.key,
    required this.url,
    this.token,
    this.index = 0,
  });

  @override
  _WebViewScreensssState createState() => _WebViewScreensssState();
}

class _WebViewScreensssState extends State<WebViewScreensss> {
  //late WebViewController controller;
  late final Completer<WebViewController> controller;
  //final bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final WebViewController? controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return const Row(
            children: <Widget>[
              Icon(Icons.arrow_back_ios),
              Icon(Icons.arrow_forward_ios),
              Icon(Icons.replay),
            ],
          );
        }

        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No back history item')),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No forward history item')),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );

    /*_loading
        ? WillPopScope(
            onWillPop: () async {
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                    selectedIndex: widget.index,
                  ),
                ),
              );*/

              Provider.of<ControlNav>(context, listen: false)
                  .updateIndex(widget.index, 0);
              return false;
            },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: MyAppBar(
                  backgroundColor: color00,
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () {
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigation(
                            selectedIndex: widget.index,
                          ),
                        ),
                      );*/

                      Provider.of<ControlNav>(context, listen: false)
                          .updateIndex(widget.index, 0);
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              body: WebViewWidget(
                controller: controller,
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );*/
  }
}
