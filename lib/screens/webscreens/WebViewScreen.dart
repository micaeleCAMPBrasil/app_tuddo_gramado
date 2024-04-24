// ignore_for_file: library_private_types_in_public_api, file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewScreen extends StatefulWidget {
  String url;
  int index;

  WebViewScreen({
    super.key,
    required this.url,
    this.index = 0,
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          setState(() {
            _loading = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                    selectedIndex: widget.index,
                  ),
                ),
              );
              return true;
            },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: MyAppBar(
                  backgroundColor: color00,
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigation(
                            selectedIndex: widget.index,
                          ),
                        ),
                      );
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
          );
  }
}
