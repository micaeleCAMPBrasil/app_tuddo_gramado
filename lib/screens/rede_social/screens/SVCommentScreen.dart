// ignore_for_file: file_names, deprecated_member_use

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/screens/rede_social/SVHomeFragment.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentReplyComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVCommentScreen extends StatefulWidget {
  const SVCommentScreen({super.key});

  @override
  State<SVCommentScreen> createState() => _SVCommentScreenState();
}

class _SVCommentScreenState extends State<SVCommentScreen> {
  List<SVCommentModel> commentList = [];

  @override
  void initState() {
    commentList = getComments();
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SVHomeFragment(),
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          backgroundColor: color00,
          iconTheme: IconThemeData(color: color94),
          title: Text(
            'Comentários',
            style: whiteBold18,
          ),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SVHomeFragment(),
                ),
              );
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: commentList.map((e) {
                    return SVCommentComponent(comment: e);
                  }).toList(),
                ),
              ),
            ),
            const SVCommentReplyComponent()
          ],
        ),
      ),
    );
  }
}
