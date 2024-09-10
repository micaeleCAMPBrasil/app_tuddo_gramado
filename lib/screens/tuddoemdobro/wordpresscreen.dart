// ignore_for_file: library_private_types_in_public_api, file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:html/parser.dart' as parser;
import 'package:html/parser.dart' show parse;

// ignore: must_be_immutable
class WordPressScreen extends StatefulWidget {
  const WordPressScreen({
    super.key,
  });

  @override
  _WordPressScreenState createState() => _WordPressScreenState();
}

class _WordPressScreenState extends State<WordPressScreen> {
  late WebViewController controller;

  Future<Map<String, dynamic>> fetchPage(int pageId) async {
    final response = await http.get(
        Uri.parse('https://d.tuddogramado.com.br/wp-json/wp/v2/pages/$pageId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load page');
    }
  }

  Future<List<dynamic>> fetchPosts() async {
    final response = await http
        .get(Uri.parse('https://d.tuddogramado.com.br/wp-json/wp/v2/posts'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  List<Widget> extractImageUrls(String htmlContent) {
    final document = parser.parse(htmlContent);
    final List<Widget> widgets = [];

    /*document.getElementsByClassName('title').forEach((element) {
      widgets.add(Text(
        element.text,
        style: TextStyle(color: Colors.white),
      ));
    });*/

    // event_meta_cat
    // loop_title
    // start-time
    document.getElementsByClassName('start-time').forEach((element) {
      widgets.add(Text(
        element.text,
        style: const TextStyle(color: Colors.white),
      ));
    });

    /*document.querySelectorAll('img').forEach((element) {
      final src = element.attributes['src'];
      if (src != null &&
          src !=
              'https://d.tuddogramado.com.br/wp-content/plugins/eventlist/assets/img/unknow_user.png') {
        widgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            src,
            width: 50,
            height: 50,
          ),
        ));
      }
    });*/

    return widgets;
  }

  List<Widget> _buildContentWidgets(String content) {
    final document = parse(content);
    final List<Widget> widgets = [];

    document.querySelectorAll('p').forEach((element) {
      widgets.add(Text(element.text));
    });

    document.querySelectorAll('img').forEach((element) {
      final src = element.attributes['src'];
      if (src != null &&
          src !=
              'https://d.tuddogramado.com.br/wp-content/plugins/eventlist/assets/img/unknow_user.png') {
        widgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            src,
            width: 50,
            height: 50,
          ),
        ));
      }
    });

    return widgets;
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://d.tuddogramado.com.br'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPage(11265),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Erro ao carregar a página')));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
              body: Center(child: Text('Página não encontrada')));
        } else {
          final page = snapshot.data!;
          final htmlContent = page['content']['rendered'];

          debugPrint(htmlContent);

          //final document = parser.parse(htmlContent);

          // Extraia elementos específicos, como imagens ou links
          //final images = document.getElementsByTagName('img');
          //final links = document.getElementsByTagName('a');

          final imageUrls = extractImageUrls(htmlContent);

          return Scaffold(
            appBar: AppBar(title: Text(page['title']['rendered'])),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...imageUrls.map((e) {
                      return e;
                    }),
                    /*Html(data: htmlContent),
                    ...imageUrls.map(
                      (url) {
                        debugPrint('url $url');
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            url,
                            width: 40,
                            height: 40,
                          ),
                        );
                      },
                    ),*/
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
